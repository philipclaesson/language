// FSRS parameter optimizer (one-off / re-runnable analysis; writes NOTHING to the DB).
//
// Fits FSRS weights to *our own* review history and reports whether they beat the
// stock defaults on held-out data — so we ship tuned parameters only if they're
// actually better calibrated, not overfit. See the lapse discussion in PLAN.md §5.
//
// Engine mismatch, handled: the optimizer (fsrs-rs-nodejs 0.9.0) speaks FSRS-5
// (19 params); our scheduler (ts-fsrs 5.4.1) speaks FSRS-6 (21). We optimize in
// FSRS-5, then `migrateParameters` lifts the 19 fitted values into a 21-vector
// (appending the two short-term params, which never fire — the scheduler runs
// `enable_short_term: false`). The lifted vector is what you paste into
// server/srs/scheduler.ts.
//
// Data source (pick one):
//   npm run optimize:fsrs                 -> reads graded reviews from $DATABASE_URL
//   npm run optimize:fsrs -- --csv <path> -> reads a psql dump (offline; no DB creds)
// The CSV must have columns: user_id,card_id,rating,reviewed_at  (header row ok).
// reviewed_at may be epoch-millis (preferred — unambiguous) or a timestamp string.
// Dump it from prod with:
//   \copy (select user_id, card_id, rating, (extract(epoch from reviewed_at)*1000)::bigint
//          from reviews where graded order by user_id, card_id, reviewed_at) to 'reviews.csv' csv header
//
// Only `graded` reviews are used: they are the one-per-day, schedule-driving
// attempts (re-drills are graded=false), which is exactly FSRS's day-grained model.

import "dotenv/config";
import { readFileSync } from "node:fs";
import { FSRS, FSRSItem, FSRSReview, DEFAULT_PARAMETERS } from "fsrs-rs-nodejs";
import { migrateParameters, checkParameters } from "ts-fsrs";

type Row = { userId: string; cardId: string; rating: number; reviewedAt: Date };

// ---- load ------------------------------------------------------------------

async function loadFromDb(): Promise<Row[]> {
  const { db } = await import("../server/db/client");
  const { reviews } = await import("../server/db/schema");
  const { and, asc, eq } = await import("drizzle-orm");
  const rows = await db
    .select({
      userId: reviews.userId,
      cardId: reviews.cardId,
      rating: reviews.rating,
      reviewedAt: reviews.reviewedAt,
    })
    .from(reviews)
    .where(eq(reviews.graded, true))
    .orderBy(asc(reviews.userId), asc(reviews.cardId), asc(reviews.reviewedAt));
  return rows as Row[];
}

function loadFromCsv(path: string): Row[] {
  const text = readFileSync(path, "utf8").trim();
  const lines = text.split(/\r?\n/);
  if (lines.length && /user_id/i.test(lines[0])) lines.shift(); // drop header
  return lines.map((line) => {
    const [userId, cardId, rating, reviewedAt] = line.split(",");
    // Epoch millis (preferred) or a timestamp string; normalize psql's
    // space-separated form ("2026-06-18 14:31:37+00") to ISO so Date parses it.
    const at = /^\d+$/.test(reviewedAt.trim())
      ? new Date(Number(reviewedAt))
      : new Date(reviewedAt.trim().replace(" ", "T"));
    return { userId, cardId, rating: Number(rating), reviewedAt: at };
  });
}

// ---- data prep (fsrs-rs convention) ----------------------------------------

// Complete UTC days between two dates — FSRS counts intervals in whole days.
function dayDiff(a: Date, b: Date): number {
  const MS = 86400000;
  const ua = Date.UTC(a.getUTCFullYear(), a.getUTCMonth(), a.getUTCDate());
  const ub = Date.UTC(b.getUTCFullYear(), b.getUTCMonth(), b.getUTCDate());
  return Math.floor((ub - ua) / MS);
}

// One card's chronological (date,rating) history -> expanding-prefix FSRSItems.
// Mirrors fsrs-rs-nodejs/examples/train_csv.js: push a review each step, emit an
// item whenever deltaT>0 (drops the first review and any same-day repeat), then
// keep only items that contain at least one long-term (cross-day) review.
function itemsForHistory(history: Row[]): FSRSItem[] {
  const reviews: FSRSReview[] = [];
  const items: FSRSItem[] = [];
  let last = history[0].reviewedAt;
  for (const r of history) {
    const deltaT = dayDiff(last, r.reviewedAt);
    reviews.push(new FSRSReview(r.rating, deltaT));
    if (deltaT > 0) items.push(new FSRSItem([...reviews]));
    last = r.reviewedAt;
  }
  return items.filter((it) => it.longTermReviewCnt() > 0);
}

// Group rows by (user,card) and flatten to a train set. Returns items tagged with
// the timestamp of their final review, so we can split train/test temporally.
function buildTrainSet(rows: Row[]): { item: FSRSItem; at: Date }[] {
  const byKey = new Map<string, Row[]>();
  for (const r of rows) {
    const k = `${r.userId}|${r.cardId}`;
    (byKey.get(k) ?? byKey.set(k, []).get(k)!).push(r);
  }
  const out: { item: FSRSItem; at: Date }[] = [];
  for (const hist of byKey.values()) {
    hist.sort((a, b) => +a.reviewedAt - +b.reviewedAt);
    let last = hist[0].reviewedAt;
    const reviews: FSRSReview[] = [];
    for (const r of hist) {
      const deltaT = dayDiff(last, r.reviewedAt);
      reviews.push(new FSRSReview(r.rating, deltaT));
      if (deltaT > 0) {
        const it = new FSRSItem([...reviews]);
        if (it.longTermReviewCnt() > 0) out.push({ item: it, at: r.reviewedAt });
      }
      last = r.reviewedAt;
    }
  }
  return out;
}

// ---- data summary ----------------------------------------------------------

function summarize(rows: Row[]) {
  const users = new Set(rows.map((r) => r.userId));
  const cards = new Set(rows.map((r) => r.cardId));
  const dist: Record<number, number> = {};
  for (const r of rows) dist[r.rating] = (dist[r.rating] ?? 0) + 1;

  // Lapses: a fail (rating 1) on a card whose previous graded review was a success
  // (rating >= 3). "mature" if that success sat on an interval >= 7 days — those are
  // the transitions that inform the post-lapse (forgetting) parameters.
  const byKey = new Map<string, Row[]>();
  for (const r of rows) {
    const k = `${r.userId}|${r.cardId}`;
    (byKey.get(k) ?? byKey.set(k, []).get(k)!).push(r);
  }
  let lapses = 0;
  let matureLapses = 0;
  for (const hist of byKey.values()) {
    hist.sort((a, b) => +a.reviewedAt - +b.reviewedAt);
    for (let i = 1; i < hist.length; i++) {
      if (hist[i].rating === 1 && hist[i - 1].rating >= 3) {
        lapses++;
        const gap = dayDiff(hist[i - 1].reviewedAt, hist[i].reviewedAt);
        if (gap >= 7) matureLapses++;
      }
    }
  }

  console.log("── data summary ──────────────────────────────────────────");
  console.log(`graded reviews : ${rows.length}`);
  console.log(`users          : ${users.size}`);
  console.log(`cards          : ${cards.size}`);
  console.log(
    `rating dist    : fail(1)=${dist[1] ?? 0}  near(2)=${dist[2] ?? 0}  pass(3)=${dist[3] ?? 0}`,
  );
  console.log(`lapses         : ${lapses}  (mature, gap>=7d: ${matureLapses})`);
  return { matureLapses };
}

// ---- eval helpers ----------------------------------------------------------

function evaluate(params: number[], items: FSRSItem[]) {
  return new FSRS(params).evaluate(items); // { logLoss, rmseBins }
}

// Recovery trajectory of a mastered card after one lapse, under a 21-param vector,
// using the *actual shipped engine* (ts-fsrs). Answers "does this soften the lapse?"
async function simulateLapse(w21: number[], label: string) {
  const { fsrs, Rating, State, createEmptyCard } = await import("ts-fsrs");
  const sch = fsrs({ enable_short_term: false, w: w21 });
  const DAY = 86400000;
  const now = new Date("2026-06-01T09:00:00Z");
  const card = {
    ...createEmptyCard(now),
    stability: 60,
    difficulty: 5,
    reps: 10,
    state: State.Review,
    last_review: new Date(+now - 60 * DAY),
    due: new Date(+now),
  };
  const { card: failed } = sch.next(card, now, Rating.Again);
  const ivFail = Math.round((+failed.due - +now) / DAY);
  let s = failed;
  let t = new Date(+failed.due);
  const path: number[] = [];
  for (let i = 0; i < 4; i++) {
    const { card: n } = sch.next(s, t, Rating.Good);
    path.push(Math.round((+n.due - +t) / DAY));
    s = n;
    t = new Date(+n.due);
  }
  console.log(
    `  ${label.padEnd(20)} fail: S=${failed.stability.toFixed(1)}d D=${failed.difficulty.toFixed(2)} ` +
      `next ${ivFail}d | then passes: ${path.map((d) => d + "d").join(" → ")}`,
  );
}

// ---- main ------------------------------------------------------------------

async function main() {
  const csvArg = process.argv.indexOf("--csv");
  const rows =
    csvArg !== -1 ? loadFromCsv(process.argv[csvArg + 1]) : await loadFromDb();
  if (!rows.length) throw new Error("no graded reviews found");

  const { matureLapses } = summarize(rows);

  const tagged = buildTrainSet(rows);
  console.log(`train items    : ${tagged.length}`);
  if (tagged.length < 400) {
    console.log(
      "\n⚠️  Fewer than ~400 training items — results will be noisy/overfit. " +
        "Treat any output as informational only.",
    );
  }
  if (matureLapses < 30) {
    console.log(
      `\n⚠️  Only ${matureLapses} mature lapses — the post-lapse (forgetting) ` +
        "parameters can't be well-determined yet. The knob you care about is the " +
        "least trustworthy part of this fit.",
    );
  }

  // Temporal 80/20 holdout: train on the older items, test on the newest. This is
  // the honest "will it generalize" check — no peeking at the future.
  tagged.sort((a, b) => +a.at - +b.at);
  const cut = Math.floor(tagged.length * 0.8);
  const train = tagged.slice(0, cut).map((t) => t.item);
  const test = tagged.slice(cut).map((t) => t.item);

  console.log("\n── optimizing (holdout) ──────────────────────────────────");
  const fsrs = new FSRS();
  const fittedHoldout = await fsrs.computeParameters(train, false);

  const stockTest = evaluate(DEFAULT_PARAMETERS, test);
  const tunedTest = evaluate(fittedHoldout, test);
  const rel = ((stockTest.rmseBins - tunedTest.rmseBins) / stockTest.rmseBins) * 100;
  const relLL = ((stockTest.logLoss - tunedTest.logLoss) / stockTest.logLoss) * 100;
  console.log(`test set       : ${test.length} items`);
  console.log(
    `stock (FSRS-5) : logLoss=${stockTest.logLoss.toFixed(4)}  rmseBins=${stockTest.rmseBins.toFixed(4)}`,
  );
  console.log(
    `tuned          : logLoss=${tunedTest.logLoss.toFixed(4)}  rmseBins=${tunedTest.rmseBins.toFixed(4)}`,
  );
  console.log(
    `Δ rmseBins     : ${rel >= 0 ? "+" : "-"}${Math.abs(rel).toFixed(1)}% (positive = tuned is better calibrated)`,
  );
  console.log(
    `Δ logLoss      : ${relLL >= 0 ? "+" : "-"}${Math.abs(relLL).toFixed(1)}% (positive = tuned is better; if the two Δ disagree, the win is marginal)`,
  );

  // Ship candidate: refit on ALL data, then lift 19 → 21 for ts-fsrs.
  console.log("\n── final fit (all data) ──────────────────────────────────");
  const fittedAll = await fsrs.computeParameters(
    tagged.map((t) => t.item),
    false,
  );
  const w21 = migrateParameters(fittedAll);
  checkParameters(w21);

  console.log("\n── lapse behaviour (ts-fsrs, mastered card S=60d D=5) ─────");
  const { default_w } = await import("ts-fsrs");
  await simulateLapse(default_w, "stock (current)");
  await simulateLapse(w21, "tuned (candidate)");

  console.log("\n── paste into server/srs/scheduler.ts ────────────────────");
  console.log(`w: [${w21.map((x) => x.toFixed(4)).join(", ")}],`);

  process.exit(0);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
