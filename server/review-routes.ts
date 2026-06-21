import { Hono } from "hono";
import { and, eq, gte, lt } from "drizzle-orm";
import { db } from "./db/client";
import { cards, decks, reviewState, reviews } from "./db/schema";
import { checkAnswer } from "./srs/check";
import { scheduleNext, type StoredSrs } from "./srs/scheduler";
import {
  startOfDay,
  isFirstAttemptOfDay,
  planToday,
  type CardToday,
} from "./srs/day";
import { summarizeProgress } from "./srs/tiers";
import { requireAuth, type AppEnv } from "./auth";
import type {
  ProgressResponse,
  ReviewRequest,
  ReviewResult,
  TodayResponse,
} from "../shared/types";

export const reviewRoutes = new Hono<AppEnv>();
reviewRoutes.use("*", requireAuth);

// In-place Fisher-Yates shuffle (Math.random is fine outside workflow scripts).
function shuffle<T>(arr: T[]): T[] {
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

// The daily loop (PLAN.md §5a): today's required set + progress. Returns only the
// still-pending cards (those without a correct typing today), so a refresh mid-
// session rebuilds the queue. Never leaks answer or article.
reviewRoutes.get("/session/today", async (c) => {
  const userId = c.get("user").id;
  const now = new Date();
  const dayStart = startOfDay(now);

  // Every owned card + this user's schedule state (left join → null = unstudied).
  const cardRows = await db
    .select({
      id: cards.id,
      prompt: cards.prompt,
      partOfSpeech: cards.partOfSpeech,
      due: reviewState.due,
      stateId: reviewState.id,
    })
    .from(cards)
    .innerJoin(decks, eq(decks.id, cards.deckId))
    .leftJoin(
      reviewState,
      and(eq(reviewState.cardId, cards.id), eq(reviewState.userId, userId)),
    )
    .where(eq(decks.ownerId, userId))
    .orderBy(cards.createdAt); // stable order → fresh cards introduced oldest-first

  // All of the user's attempts, split around the start of today. "Correct" counts
  // any pass (rating >= 3), including a re-drill that finally landed.
  const todays = await db
    .select({ cardId: reviews.cardId, rating: reviews.rating })
    .from(reviews)
    .where(and(eq(reviews.userId, userId), gte(reviews.reviewedAt, dayStart)));
  const earlier = await db
    .select({ cardId: reviews.cardId })
    .from(reviews)
    .where(and(eq(reviews.userId, userId), lt(reviews.reviewedAt, dayStart)));

  const reviewedToday = new Set(todays.map((r) => r.cardId));
  const correctToday = new Set(todays.filter((r) => r.rating >= 3).map((r) => r.cardId));
  const reviewedBefore = new Set(earlier.map((r) => r.cardId));

  const todayCards: CardToday[] = cardRows.map((r) => ({
    id: r.id,
    hasState: r.stateId !== null,
    due: r.due,
    reviewedToday: reviewedToday.has(r.id),
    correctToday: correctToday.has(r.id),
    reviewedBeforeToday: reviewedBefore.has(r.id),
  }));

  const plan = planToday(todayCards, now);

  const byId = new Map(cardRows.map((r) => [r.id, r]));
  const pending = shuffle(
    plan.pendingIds.map((id) => {
      const r = byId.get(id)!;
      return { id: r.id, prompt: r.prompt, partOfSpeech: r.partOfSpeech };
    }),
  );

  const body: TodayResponse = {
    cards: pending,
    dueTotal: plan.dueTotal,
    newTotal: plan.newTotal,
    done: plan.done,
    pending: plan.pending,
    complete: plan.complete,
  };
  return c.json(body);
});

reviewRoutes.post("/reviews", async (c) => {
  const userId = c.get("user").id;
  const { cardId, typedAnswer, elapsedMs } = (await c.req.json()) as ReviewRequest;

  // Load the card and verify the user owns it (via deck ownership).
  const [card] = await db
    .select()
    .from(cards)
    .innerJoin(decks, eq(decks.id, cards.deckId))
    .where(and(eq(cards.id, cardId), eq(decks.ownerId, userId)))
    .limit(1)
    .then((rows) => rows.map((r) => r.cards));

  if (!card) return c.json({ error: "card not found" }, 404);

  const result = checkAnswer(
    {
      answer: card.answer,
      answerAlts: card.answerAlts,
      partOfSpeech: card.partOfSpeech,
      article: card.article,
    },
    typedAnswer ?? "",
  );

  const [existing] = await db
    .select()
    .from(reviewState)
    .where(and(eq(reviewState.userId, userId), eq(reviewState.cardId, cardId)))
    .limit(1);

  const now = new Date();

  // The first attempt of the day on a card drives the schedule; later same-day
  // attempts are training-only re-drills that leave it untouched (PLAN.md §5a).
  // `lastReview` is the time of the last *graded* review, so it's the right
  // signal — re-drills never update it.
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
      .insert(reviewState)
      .values({ userId, cardId, ...next })
      .onConflictDoUpdate({
        target: [reviewState.userId, reviewState.cardId],
        set: next,
      });
    nextDue = next.due;
  } else {
    // Re-drill: schedule unchanged. `existing` is guaranteed here (a non-first
    // attempt means a graded review already created the row today).
    nextDue = existing?.due ?? now;
  }

  await db.insert(reviews).values({
    userId,
    cardId,
    rating: result.correct ? 3 : 1,
    graded,
    typedAnswer: typedAnswer ?? null,
    elapsedMs: elapsedMs ?? null,
  });

  const body: ReviewResult = {
    correct: result.correct,
    expected: result.expected,
    reason: result.reason,
    nextDue: nextDue.toISOString(),
    graded,
    needsRedrill: !result.correct,
  };
  return c.json(body);
});

// Mastery tiers + headline count (PLAN.md §5a). Derived from each card's FSRS
// stability; new = no review state yet. `reviewsToday` counts graded reviews
// (re-drills excluded).
reviewRoutes.get("/progress", async (c) => {
  const userId = c.get("user").id;
  const dayStart = startOfDay(new Date());

  const rows = await db
    .select({ stability: reviewState.stability, stateId: reviewState.id })
    .from(cards)
    .innerJoin(decks, eq(decks.id, cards.deckId))
    .leftJoin(
      reviewState,
      and(eq(reviewState.cardId, cards.id), eq(reviewState.userId, userId)),
    )
    .where(eq(decks.ownerId, userId));

  const stabilities = rows.map((r) => (r.stateId === null ? null : r.stability));

  const gradedToday = await db
    .select({ id: reviews.id })
    .from(reviews)
    .where(
      and(
        eq(reviews.userId, userId),
        gte(reviews.reviewedAt, dayStart),
        eq(reviews.graded, true),
      ),
    );

  const body: ProgressResponse = summarizeProgress(stabilities, gradedToday.length);
  return c.json(body);
});
