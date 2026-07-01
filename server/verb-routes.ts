import { Hono } from "hono";
import { and, eq, gte, lt } from "drizzle-orm";
import { db } from "./db/client";
import { verbs, verbReviewState, verbReviews } from "./db/schema";
import { checkConjugation } from "./verbs/check";
import { planVerbDay, type VerbToday } from "./verbs/plan";
import { scheduleNext, type StoredSrs } from "./srs/scheduler";
import { startOfDay, isFirstAttemptOfDay } from "./srs/day";
import { summarizeProgress, tierFor } from "./srs/tiers";
import { requireAuth, type AppEnv } from "./auth";
import {
  VERB_FORMS,
  type Conjugation,
  type VerbListItem,
  type VerbProgressResponse,
  type VerbReviewRequest,
  type VerbReviewResult,
  type VerbRegularity,
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

// Pull the six form columns off a verb row into a Conjugation.
function conjugationOf(v: {
  formIch: string;
  formDu: string;
  formEr: string;
  formWir: string;
  formIhr: string;
  formSie: string;
}): Conjugation {
  return {
    ich: v.formIch,
    du: v.formDu,
    er: v.formEr,
    wir: v.formWir,
    ihr: v.formIhr,
    sie: v.formSie,
  };
}

// Today's required verb set + progress (VERBS.md), mirroring /session/today for
// words. Returns only still-pending verbs (no correct conjugation today yet).
// NEVER leaks the six forms — those are the answer.
verbRoutes.get("/verbs/session/today", async (c) => {
  const userId = c.get("user").id;
  const now = new Date();
  const dayStart = startOfDay(now);

  // Whole global catalog + this user's schedule state (left join → null = unstudied).
  const rows = await db
    .select({
      id: verbs.id,
      infinitive: verbs.infinitive,
      english: verbs.english,
      regularity: verbs.regularity,
      frequencyRank: verbs.frequencyRank,
      due: verbReviewState.due,
      stateId: verbReviewState.id,
    })
    .from(verbs)
    .leftJoin(
      verbReviewState,
      and(eq(verbReviewState.verbId, verbs.id), eq(verbReviewState.userId, userId)),
    )
    .orderBy(verbs.frequencyRank);

  const todays = await db
    .select({ verbId: verbReviews.verbId, rating: verbReviews.rating })
    .from(verbReviews)
    .where(and(eq(verbReviews.userId, userId), gte(verbReviews.reviewedAt, dayStart)));
  const earlier = await db
    .select({ verbId: verbReviews.verbId })
    .from(verbReviews)
    .where(and(eq(verbReviews.userId, userId), lt(verbReviews.reviewedAt, dayStart)));

  const reviewedToday = new Set(todays.map((r) => r.verbId));
  const correctToday = new Set(todays.filter((r) => r.rating >= 3).map((r) => r.verbId));
  const reviewedBefore = new Set(earlier.map((r) => r.verbId));

  const todayVerbs: VerbToday[] = rows.map((r) => ({
    id: r.id,
    regularity: r.regularity as VerbRegularity,
    frequencyRank: r.frequencyRank,
    hasState: r.stateId !== null,
    due: r.due,
    reviewedToday: reviewedToday.has(r.id),
    correctToday: correctToday.has(r.id),
    reviewedBeforeToday: reviewedBefore.has(r.id),
  }));

  const plan = planVerbDay(todayVerbs, now);

  const byId = new Map(rows.map((r) => [r.id, r]));
  const pending = shuffle(
    plan.pendingIds.map((id) => {
      const r = byId.get(id)!;
      return {
        id: r.id,
        infinitive: r.infinitive,
        english: r.english,
        regularity: r.regularity as VerbRegularity,
      };
    }),
  );

  const body: VerbTodayResponse = {
    verbs: pending,
    dueTotal: plan.dueTotal,
    newTotal: plan.newTotal,
    done: plan.done,
    pending: plan.pending,
    complete: plan.complete,
  };
  return c.json(body);
});

// The whole global catalog (frequency order) tagged with this user's mastery tier
// — a browse-all reference view, like a deck detail. Never leaks the six forms.
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
      and(eq(verbReviewState.verbId, verbs.id), eq(verbReviewState.userId, userId)),
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
  const { verbId, typed, elapsedMs } = (await c.req.json()) as VerbReviewRequest;

  const [verb] = await db.select().from(verbs).where(eq(verbs.id, verbId)).limit(1);
  if (!verb) return c.json({ error: "verb not found" }, 404);

  const expected = conjugationOf(verb);
  // Keep only the six known form keys from the client payload.
  const cleanTyped: Partial<Conjugation> = {};
  for (const f of VERB_FORMS) cleanTyped[f] = typed?.[f] ?? "";
  const result = checkConjugation(expected, cleanTyped);

  const [existing] = await db
    .select()
    .from(verbReviewState)
    .where(and(eq(verbReviewState.userId, userId), eq(verbReviewState.verbId, verbId)))
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

    const next = scheduleNext(prev, result.correct, now);
    await db
      .insert(verbReviewState)
      .values({ userId, verbId, ...next })
      .onConflictDoUpdate({
        target: [verbReviewState.userId, verbReviewState.verbId],
        set: next,
      });
    nextDue = next.due;
  } else {
    nextDue = existing?.due ?? now;
  }

  await db.insert(verbReviews).values({
    userId,
    verbId,
    rating: result.correct ? 3 : 1,
    graded,
    typedAnswer: cleanTyped,
    elapsedMs: elapsedMs ?? null,
  });

  const body: VerbReviewResult = {
    correct: result.correct,
    expected: result.expected,
    perForm: result.perForm,
    nextDue: nextDue.toISOString(),
    graded,
    needsRedrill: !result.correct,
  };
  return c.json(body);
});

// Verb mastery tiers + headline count, derived from FSRS stability (reused from
// srs/tiers.ts). `reviewsToday` counts graded verb reviews (re-drills excluded).
verbRoutes.get("/verbs/progress", async (c) => {
  const userId = c.get("user").id;
  const dayStart = startOfDay(new Date());

  const rows = await db
    .select({ stability: verbReviewState.stability, stateId: verbReviewState.id })
    .from(verbs)
    .leftJoin(
      verbReviewState,
      and(eq(verbReviewState.verbId, verbs.id), eq(verbReviewState.userId, userId)),
    );

  const stabilities = rows.map((r) => (r.stateId === null ? null : r.stability));

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
