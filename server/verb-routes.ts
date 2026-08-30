import { Hono } from "hono";
import { and, eq, gte, lt } from "drizzle-orm";
import { db } from "./db/client";
import { verbs, verbReviewState, verbReviews } from "./db/schema";
import { checkConjugation, checkPerfekt } from "./verbs/check";
import {
  planVerbDay,
  planPastVerbDay,
  mergeVerbPlans,
  type VerbToday,
} from "./verbs/plan";
import { scheduleNext, type StoredSrs } from "./srs/scheduler";
import {
  startOfDay,
  isFirstAttemptOfDay,
  freshPool,
  practicePool,
  missesPool,
} from "./srs/day";
import { summarizeProgress, tierFor } from "./srs/tiers";
import { markVerbsDone } from "./db/daily-progress";
import { requireAuth, type AppEnv } from "./auth";
import {
  VERB_FORMS,
  type Conjugation,
  type ExtraType,
  type PastKind,
  type SessionVerb,
  type VerbExtraResponse,
  type VerbListItem,
  type VerbProgressResponse,
  type VerbReviewRequest,
  type VerbReviewResult,
  type VerbRegularity,
  type VerbTense,
  type VerbTodayResponse,
} from "../shared/types";

export const verbRoutes = new Hono<AppEnv>();
verbRoutes.use("*", requireAuth);

// In-place Fisher-Yates shuffle (Math.random is fine outside workflow scripts).
function shuffle<T>(arr: T[]): T[] {
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

// Pull the six PRESENT form columns off a verb row into a Conjugation.
function conjugationOf(v: {
  formIch: string;
  formDu: string;
  formEr: string;
  formWir: string;
  formIhr: string;
  formSie: string;
}): Conjugation {
  return { ich: v.formIch, du: v.formDu, er: v.formEr, wir: v.formWir, ihr: v.formIhr, sie: v.formSie };
}

// Pull the six PRÄTERITUM columns into a Conjugation (only set for Präteritum verbs).
function praetConjugationOf(v: {
  praetIch: string | null;
  praetDu: string | null;
  praetEr: string | null;
  praetWir: string | null;
  praetIhr: string | null;
  praetSie: string | null;
}): Conjugation {
  return {
    ich: v.praetIch ?? "",
    du: v.praetDu ?? "",
    er: v.praetEr ?? "",
    wir: v.praetWir ?? "",
    ihr: v.praetIhr ?? "",
    sie: v.praetSie ?? "",
  };
}

// One drillable thing = a (verb, tense) pair. Present always exists; past exists
// only when the verb carries past data (pastKind). Each is an independent SRS
// item (VERBS.md §7); `itemId` is its stable queue key.
type VerbItem = {
  itemId: string; // `${verbId}:${tense}`
  verbId: string;
  tense: VerbTense;
  pastKind: PastKind | null;
  infinitive: string;
  english: string;
  regularity: VerbRegularity;
  frequencyRank: number;
  due: Date | null;
  stability: number | null;
  hasState: boolean;
};

const itemKey = (verbId: string, tense: VerbTense) => `${verbId}:${tense}`;

// The whole global catalog + this user's per-(verb,tense) schedule state, expanded
// into one VerbItem per drillable card. Shared by /session/today and /session/extra.
async function loadItems(userId: string): Promise<VerbItem[]> {
  const catalog = await db.select().from(verbs).orderBy(verbs.frequencyRank);
  const states = await db
    .select({
      verbId: verbReviewState.verbId,
      tense: verbReviewState.tense,
      due: verbReviewState.due,
      stability: verbReviewState.stability,
    })
    .from(verbReviewState)
    .where(eq(verbReviewState.userId, userId));
  const stateByKey = new Map(states.map((s) => [itemKey(s.verbId, s.tense as VerbTense), s]));

  const items: VerbItem[] = [];
  const push = (v: (typeof catalog)[number], tense: VerbTense) => {
    const st = stateByKey.get(itemKey(v.id, tense));
    items.push({
      itemId: itemKey(v.id, tense),
      verbId: v.id,
      tense,
      pastKind: (v.pastKind as PastKind | null) ?? null,
      infinitive: v.infinitive,
      english: v.english,
      regularity: v.regularity as VerbRegularity,
      frequencyRank: v.frequencyRank,
      due: st?.due ?? null,
      stability: st?.stability ?? null,
      hasState: st !== undefined,
    });
  };
  for (const v of catalog) {
    push(v, "present");
    if (v.pastKind) push(v, "past");
  }
  return items;
}

// Per-(verb,tense) attempts split around the start of today (mirrors words). Keyed
// by itemId. `reviewedTodayAny` = bonus + non-bonus (pool exclusion); required-set
// signals are non-bonus only; `reviewedBefore` is all prior attempts. See EXTRA_WORK.md.
async function todayVerbReviewSets(userId: string, dayStart: Date) {
  const todays = await db
    .select({
      verbId: verbReviews.verbId,
      tense: verbReviews.tense,
      rating: verbReviews.rating,
      bonus: verbReviews.bonus,
      graded: verbReviews.graded,
    })
    .from(verbReviews)
    .where(and(eq(verbReviews.userId, userId), gte(verbReviews.reviewedAt, dayStart)));
  const earlier = await db
    .select({ verbId: verbReviews.verbId, tense: verbReviews.tense })
    .from(verbReviews)
    .where(and(eq(verbReviews.userId, userId), lt(verbReviews.reviewedAt, dayStart)));

  const key = (r: { verbId: string; tense: string }) => itemKey(r.verbId, r.tense as VerbTense);
  const nonBonus = todays.filter((r) => !r.bonus);
  const reviewedBefore = new Set(earlier.map(key));
  return {
    reviewedTodayAny: new Set(todays.map(key)),
    reviewedToday: new Set(nonBonus.map(key)),
    correctToday: new Set(nonBonus.filter((r) => r.rating >= 3).map(key)),
    missedToday: new Set(todays.filter((r) => r.graded && r.rating < 3).map(key)),
    reviewedBefore,
    bonusNewToday: new Set(
      todays.filter((r) => r.bonus && r.graded && !reviewedBefore.has(key(r))).map(key),
    ).size,
  };
}

type ReviewSets = Awaited<ReturnType<typeof todayVerbReviewSets>>;

function toToday(it: VerbItem, sets: ReviewSets): VerbToday {
  return {
    id: it.itemId,
    regularity: it.regularity,
    frequencyRank: it.frequencyRank,
    hasState: it.hasState,
    due: it.due,
    reviewedToday: sets.reviewedToday.has(it.itemId),
    correctToday: sets.correctToday.has(it.itemId),
    reviewedBeforeToday: sets.reviewedBefore.has(it.itemId),
  };
}

// One FSRS stability per drillable (verb, tense) item — null = unstudied. Both
// tenses count, so mastery reflects the full amount of work (VERBS.md §6a). Shared
// by /verbs/progress and the Stats mastery bar so their totals agree.
export async function verbItemStabilities(userId: string): Promise<(number | null)[]> {
  const items = await loadItems(userId);
  return items.map((i) => (i.hasState ? i.stability : null));
}

// Today's merged verb plan (both tense streams) + the loaded items/sets, so callers
// that also need the pools (session/today) don't re-query. Reused by the daily
// reminder so "verbs due today" can never drift from the dashboard.
export async function verbPlanFor(userId: string, now: Date) {
  const items = await loadItems(userId);
  const sets = await todayVerbReviewSets(userId, startOfDay(now));
  const presentToday = items.filter((i) => i.tense === "present").map((i) => toToday(i, sets));
  const pastToday = items.filter((i) => i.tense === "past").map((i) => toToday(i, sets));
  const plan = mergeVerbPlans(planVerbDay(presentToday, now), planPastVerbDay(pastToday, now));
  return { items, sets, plan };
}

function sessionVerbOf(it: VerbItem): SessionVerb {
  return {
    id: it.itemId,
    verbId: it.verbId,
    tense: it.tense,
    pastKind: it.tense === "past" ? (it.pastKind ?? undefined) : undefined,
    infinitive: it.infinitive,
    english: it.english,
    regularity: it.regularity,
    tier: tierFor(it.hasState ? it.stability : null),
  };
}

// Today's required verb set + progress (VERBS.md), across BOTH tense streams merged
// (present with the 3:2 mix, past in frequency order). Returns only still-pending
// items. NEVER leaks the forms — those are the answer.
verbRoutes.get("/verbs/session/today", async (c) => {
  const userId = c.get("user").id;
  const now = new Date();

  const { items, sets, plan } = await verbPlanFor(userId, now);

  // Record a finished verb-day (client re-fetches on "done"). See markWordsDone.
  if (plan.complete) await markVerbsDone(userId, now);

  const newAvailable = freshPool(
    items.map((i) => ({
      id: i.itemId,
      hasState: i.hasState,
      reviewedToday: sets.reviewedTodayAny.has(i.itemId),
    })),
    Infinity,
  ).length;
  const practiceAvailable = practicePool(
    items.map((i) => ({
      id: i.itemId,
      due: i.due,
      stability: i.stability ?? 0,
      reviewedToday: sets.reviewedTodayAny.has(i.itemId),
    })),
    now,
    { limit: Infinity },
  ).length;
  const missesAvailable = missesPool(
    items.map((i) => ({ id: i.itemId, missedToday: sets.missedToday.has(i.itemId) })),
  ).length;

  const byId = new Map(items.map((i) => [i.itemId, i]));
  const pending = shuffle(plan.pendingIds.map((id) => sessionVerbOf(byId.get(id)!)));

  const body: VerbTodayResponse = {
    verbs: pending,
    dueTotal: plan.dueTotal,
    newTotal: plan.newTotal,
    done: plan.done,
    pending: plan.pending,
    complete: plan.complete,
    newAvailable,
    practiceAvailable,
    missesAvailable,
    bonusToday: sets.bonusNewToday,
  };
  return c.json(body);
});

// Extra/bonus verb work (EXTRA_WORK.md), across both tense streams. `new` = fresh
// items (frequency order); `practice` = studied, not-due items weakest-first;
// `misses` = items missed today, re-drillable (FSRS untouched). Never leaks forms.
verbRoutes.get("/verbs/session/extra", async (c) => {
  const userId = c.get("user").id;
  const type = (c.req.query("type") ?? "new") as ExtraType;
  const now = new Date();
  const dayStart = startOfDay(now);

  const items = await loadItems(userId);
  const sets = await todayVerbReviewSets(userId, dayStart);

  const ids =
    type === "misses"
      ? missesPool(items.map((i) => ({ id: i.itemId, missedToday: sets.missedToday.has(i.itemId) })))
      : type === "practice"
        ? practicePool(
            items.map((i) => ({
              id: i.itemId,
              due: i.due,
              stability: i.stability ?? 0,
              reviewedToday: sets.reviewedTodayAny.has(i.itemId),
            })),
            now,
          )
        : freshPool(
            items.map((i) => ({
              id: i.itemId,
              hasState: i.hasState,
              reviewedToday: sets.reviewedTodayAny.has(i.itemId),
            })),
          );

  const byId = new Map(items.map((i) => [i.itemId, i]));
  const body: VerbExtraResponse = { verbs: ids.map((id) => sessionVerbOf(byId.get(id)!)) };
  return c.json(body);
});

// The whole global catalog (frequency order) tagged with this user's PRESENT-tense
// mastery tier — a browse-all reference view, like a deck detail. Never leaks forms.
verbRoutes.get("/verbs/list", async (c) => {
  const userId = c.get("user").id;

  const rows = await db
    .select({
      id: verbs.id,
      infinitive: verbs.infinitive,
      english: verbs.english,
      regularity: verbs.regularity,
      stability: verbReviewState.stability,
      stateId: verbReviewState.id,
    })
    .from(verbs)
    .leftJoin(
      verbReviewState,
      and(
        eq(verbReviewState.verbId, verbs.id),
        eq(verbReviewState.userId, userId),
        eq(verbReviewState.tense, "present"),
      ),
    )
    .orderBy(verbs.frequencyRank);

  const body: VerbListItem[] = rows.map((r) => ({
    id: r.id,
    infinitive: r.infinitive,
    english: r.english,
    regularity: r.regularity as VerbRegularity,
    tier: tierFor(r.stateId === null ? null : r.stability),
  }));
  return c.json(body);
});

verbRoutes.post("/verbs/reviews", async (c) => {
  const userId = c.get("user").id;
  const { verbId, tense: tenseIn, typed, pastForm, elapsedMs, bonus } =
    (await c.req.json()) as VerbReviewRequest;
  const tense: VerbTense = tenseIn ?? "present";

  const [verb] = await db.select().from(verbs).where(eq(verbs.id, verbId)).limit(1);
  if (!verb) return c.json({ error: "verb not found" }, 404);
  if (tense === "past" && !verb.pastKind) return c.json({ error: "verb has no past card" }, 400);

  // Grade against the right forms for this (tense, pastKind). Perfekt is a single
  // string; present and Präteritum are six-form grids.
  let correct: boolean;
  let gridExpected: Conjugation | undefined;
  let perForm: VerbReviewResult["perForm"];
  let expectedForm: string | undefined;
  let typedAnswer: unknown;

  if (tense === "past" && verb.pastKind === "perfekt") {
    const r = checkPerfekt(verb.perfekt ?? "", pastForm ?? "");
    correct = r.correct;
    expectedForm = r.expected;
    typedAnswer = { perfekt: pastForm ?? "" };
  } else {
    const expected = tense === "past" ? praetConjugationOf(verb) : conjugationOf(verb);
    const cleanTyped: Partial<Conjugation> = {};
    for (const f of VERB_FORMS) cleanTyped[f] = typed?.[f] ?? "";
    const r = checkConjugation(expected, cleanTyped);
    correct = r.correct;
    gridExpected = r.expected;
    perForm = r.perForm;
    typedAnswer = cleanTyped;
  }

  const [existing] = await db
    .select()
    .from(verbReviewState)
    .where(
      and(
        eq(verbReviewState.userId, userId),
        eq(verbReviewState.verbId, verbId),
        eq(verbReviewState.tense, tense),
      ),
    )
    .limit(1);

  const now = new Date();

  // First attempt of the day drives FSRS; later same-day attempts are training-only
  // re-drills that leave the schedule untouched (PLAN.md §5a).
  const graded = isFirstAttemptOfDay(existing?.lastReview ?? null, now);

  let nextDue: Date;
  if (graded) {
    const prev: StoredSrs | null = existing
      ? {
          due: existing.due,
          stability: existing.stability,
          difficulty: existing.difficulty,
          reps: existing.reps,
          lapses: existing.lapses,
          lastReview: existing.lastReview,
          state: existing.state,
        }
      : null;

    // Verbs stay all-or-nothing: no near-miss grade (a card is a whole form set).
    const next = scheduleNext(prev, correct ? "pass" : "fail", now);
    await db
      .insert(verbReviewState)
      .values({ userId, verbId, tense, ...next })
      .onConflictDoUpdate({
        target: [verbReviewState.userId, verbReviewState.verbId, verbReviewState.tense],
        set: next,
      });
    nextDue = next.due;
  } else {
    nextDue = existing?.due ?? now;
  }

  await db.insert(verbReviews).values({
    userId,
    verbId,
    tense,
    rating: correct ? 3 : 1,
    graded,
    bonus: bonus ?? false,
    typedAnswer,
    elapsedMs: elapsedMs ?? null,
  });

  const body: VerbReviewResult = {
    correct,
    nextDue: nextDue.toISOString(),
    graded,
    needsRedrill: !correct,
    ...(gridExpected ? { expected: gridExpected, perForm } : {}),
    ...(expectedForm !== undefined ? { expectedForm } : {}),
  };
  return c.json(body);
});

// Verb mastery tiers + headline count, from FSRS stability (reused from
// srs/tiers.ts). Counts EVERY (verb, tense) item, so the total reflects all the
// work left across present + past. `reviewsToday` counts graded verb reviews (all
// tenses; re-drills excluded).
verbRoutes.get("/verbs/progress", async (c) => {
  const userId = c.get("user").id;
  const dayStart = startOfDay(new Date());

  const stabilities = await verbItemStabilities(userId);

  const gradedToday = await db
    .select({ id: verbReviews.id })
    .from(verbReviews)
    .where(
      and(
        eq(verbReviews.userId, userId),
        gte(verbReviews.reviewedAt, dayStart),
        eq(verbReviews.graded, true),
      ),
    );

  const body: VerbProgressResponse = summarizeProgress(stabilities, gradedToday.length);
  return c.json(body);
});
