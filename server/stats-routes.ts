import { Hono } from "hono";
import { and, eq, isNull, or, sql } from "drizzle-orm";
import { db } from "./db/client";
import { cards, dailyProgress, decks, reviewState, reviews, verbReviews } from "./db/schema";
import { DAY_TZ } from "./srs/day";
import { verbItemStabilities } from "./verb-routes";
import { summarizeProgress } from "./srs/tiers";
import { tierHistory, type ReplayReview } from "./srs/tier-history";
import {
  buildHeatmap,
  computeStreaks,
  localDateString,
  perfectPct,
  sumLastWeek,
} from "./srs/stats";
import { requireAuth, type AppEnv } from "./auth";
import type { StatsResponse, TierHistoryResponse } from "../shared/types";

export const statsRoutes = new Hono<AppEnv>();
statsRoutes.use("*", requireAuth);

const HEATMAP_WEEKS = 6;

// Per-day count of cards done (graded first-of-day reviews) for one user, bucketed
// by local calendar day in DAY_TZ. Returns [{ day: "YYYY-MM-DD", n }]. Small: at
// most one row per active day. `column`/`table` are trusted (this module's own).
function dailyCounts(table: typeof reviews | typeof verbReviews, userId: string) {
  return db.execute<{ day: string; n: number }>(sql`
    select to_char((${table.reviewedAt} at time zone ${DAY_TZ})::date, 'YYYY-MM-DD') as day,
           count(*)::int as n
    from ${table}
    where ${table.userId} = ${userId} and ${table.graded} = true
    group by day
  `);
}

// All motivation stats, derived ad-hoc — nothing is stored. Everything here is a
// simple per-user read: two day-bucketed count queries + two stability scans.
statsRoutes.get("/stats", async (c) => {
  const userId = c.get("user").id;
  const today = localDateString(new Date(), DAY_TZ);

  const [wordDays, verbDays] = await Promise.all([
    dailyCounts(reviews, userId),
    dailyCounts(verbReviews, userId),
  ]);

  // Merge words + verbs into one activity count per day.
  const counts = new Map<string, number>();
  for (const r of [...wordDays.rows, ...verbDays.rows]) {
    counts.set(r.day, (counts.get(r.day) ?? 0) + r.n);
  }

  const active = new Set(counts.keys());
  const { current, longest } = computeStreaks(active, today);

  // Perfect days: all words + all verbs done and ≥1 Freund chat. Read straight from
  // daily_progress (one small row per active day); the definition lives here so it
  // can change without a schema backfill.
  const progressRows = await db
    .select({
      day: dailyProgress.day,
      wordsDone: dailyProgress.wordsDone,
      verbsDone: dailyProgress.verbsDone,
      freundCount: dailyProgress.freundCount,
    })
    .from(dailyProgress)
    .where(eq(dailyProgress.userId, userId));
  const perfect = new Set(
    progressRows
      .filter((r) => r.wordsDone && r.verbsDone && r.freundCount > 0)
      .map((r) => r.day),
  );

  // Mastery bar: the whole library (words + verbs), same tiers as the home cards.
  // Verbs count every (verb, tense) item (present + past), matching /verbs/progress.
  const [wordStates, verbStabilities] = await Promise.all([
    db
      .select({ stability: reviewState.stability, stateId: reviewState.id })
      .from(cards)
      .innerJoin(decks, eq(decks.id, cards.deckId))
      .leftJoin(
        reviewState,
        and(eq(reviewState.cardId, cards.id), eq(reviewState.userId, userId)),
      )
      .where(or(eq(decks.ownerId, userId), isNull(decks.ownerId))),
    verbItemStabilities(userId),
  ]);
  const stabilities = [
    ...wordStates.map((r) => (r.stateId === null ? null : r.stability)),
    ...verbStabilities,
  ];

  const body: StatsResponse = {
    heatmap: buildHeatmap(counts, today, HEATMAP_WEEKS, perfect),
    weeks: HEATMAP_WEEKS,
    currentStreak: current,
    longestStreak: longest,
    practicedLastWeek: sumLastWeek(counts, today),
    perfectDays30: perfectPct(perfect, today),
    mastery: summarizeProgress(stabilities, 0),
  };
  return c.json(body);
});

// Mastery over the last 30 days for the growth chart. Recomputed on every load
// (no stored snapshots — the graded-review log is authoritative): replay each
// card's/verb's log through FSRS to get its tier timeline, then bucket per day.
// Words + verbs are merged into one library, matching the mastery bar. A separate
// endpoint from /stats so the main paint isn't blocked on this second log read.
statsRoutes.get("/stats/history", async (c) => {
  const userId = c.get("user").id;
  const today = localDateString(new Date(), DAY_TZ);

  const [wordRows, verbRows] = await Promise.all([
    db
      .select({ id: reviews.cardId, rating: reviews.rating, reviewedAt: reviews.reviewedAt })
      .from(reviews)
      .where(and(eq(reviews.userId, userId), eq(reviews.graded, true))),
    db
      .select({
        id: verbReviews.verbId,
        tense: verbReviews.tense,
        rating: verbReviews.rating,
        reviewedAt: verbReviews.reviewedAt,
      })
      .from(verbReviews)
      .where(and(eq(verbReviews.userId, userId), eq(verbReviews.graded, true))),
  ]);

  // Group by entity into one review list each. Card and verb ids live in separate
  // uuid spaces; prefix so a (vanishingly unlikely) collision can't merge two.
  const byEntity = new Map<string, ReplayReview[]>();
  const add = (prefix: string, id: string, rating: number, reviewedAt: Date) => {
    const key = prefix + id;
    const list = byEntity.get(key);
    const review = { rating, reviewedAt };
    if (list) list.push(review);
    else byEntity.set(key, [review]);
  };
  for (const r of wordRows) add("c:", r.id, r.rating, r.reviewedAt);
  // Present and past are separate items — key by tense so their FSRS timelines
  // replay independently (matching the mastery bar's per-(verb,tense) count).
  for (const r of verbRows) add("v:", `${r.id}:${r.tense}`, r.rating, r.reviewedAt);

  const body: TierHistoryResponse = {
    history: tierHistory([...byEntity.values()], today),
  };
  return c.json(body);
});
