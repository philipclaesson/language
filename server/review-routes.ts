import { Hono } from "hono";
import { and, asc, eq, gte, isNull, lt, or, sql } from "drizzle-orm";
import { db } from "./db/client";
import { cards, decks, reviewState, reviews } from "./db/schema";
import { checkAnswer } from "./srs/check";
import { scheduleNext, type StoredSrs } from "./srs/scheduler";
import {
  startOfDay,
  isFirstAttemptOfDay,
  planToday,
  freshPool,
  practicePool,
  missesPool,
  type CardToday,
} from "./srs/day";
import { summarizeProgress } from "./srs/tiers";
import { requireAuth, type AppEnv } from "./auth";
import type {
  ExtraResponse,
  ExtraType,
  ProgressResponse,
  ReviewRequest,
  ReviewResult,
  SessionCard,
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

// Every owned card + this user's schedule state (left join → null = unstudied),
// in new-card introduction order (most-frequent first; personal cards before the
// corpus; createdAt breaks ties). Shared by /session/today and /session/extra.
function loadCardsWithState(userId: string) {
  return db
    .select({
      id: cards.id,
      prompt: cards.prompt,
      partOfSpeech: cards.partOfSpeech,
      exampleEn: cards.exampleEn, // English context, safe pre-answer
      ownerId: decks.ownerId, // null = global/stock deck
      due: reviewState.due,
      stability: reviewState.stability,
      stateId: reviewState.id,
    })
    .from(cards)
    .innerJoin(decks, eq(decks.id, cards.deckId))
    .leftJoin(
      reviewState,
      and(eq(reviewState.cardId, cards.id), eq(reviewState.userId, userId)),
    )
    // Owned decks + global (ownerless) decks like the frequency word corpus.
    .where(or(eq(decks.ownerId, userId), isNull(decks.ownerId)))
    .orderBy(sql`${cards.frequencyRank} asc nulls first`, asc(cards.createdAt));
}

// This user's attempts split around the start of today. `reviewedTodayAny` counts
// bonus + non-bonus (used to exclude cards from the extra-work pools). The others
// are NON-BONUS only, so bonus work can't expand the required set / un-complete the
// day (EXTRA_WORK.md). `reviewedBefore` counts ALL prior reviews — a card learned
// as bonus on an earlier day is a returning card, not a fresh introduction.
async function todayReviewSets(userId: string, dayStart: Date) {
  const todays = await db
    .select({
      cardId: reviews.cardId,
      rating: reviews.rating,
      bonus: reviews.bonus,
      graded: reviews.graded,
    })
    .from(reviews)
    .where(and(eq(reviews.userId, userId), gte(reviews.reviewedAt, dayStart)));
  const earlier = await db
    .select({ cardId: reviews.cardId })
    .from(reviews)
    .where(and(eq(reviews.userId, userId), lt(reviews.reviewedAt, dayStart)));

  const nonBonus = todays.filter((r) => !r.bonus);
  return {
    reviewedTodayAny: new Set(todays.map((r) => r.cardId)),
    reviewedToday: new Set(nonBonus.map((r) => r.cardId)),
    correctToday: new Set(nonBonus.filter((r) => r.rating >= 3).map((r) => r.cardId)),
    // Every card whose first graded attempt today was a miss — the "misses" pool.
    // Includes bonus/extra cards (e.g. new cards learned today that you flunked), not
    // just the daily set: it drives the re-drill pool + its count, never completion,
    // so bonus misses are safe here. graded=true isolates the first-of-day attempt
    // (later re-drills are graded=false), so it stays stable no matter how much you
    // re-drill.
    missedToday: new Set(
      todays.filter((r) => r.graded && r.rating < 3).map((r) => r.cardId),
    ),
    reviewedBefore: new Set(earlier.map((r) => r.cardId)),
  };
}

// The daily loop (PLAN.md §5a): today's required set + progress. Returns only the
// still-pending cards (those without a correct typing today), so a refresh mid-
// session rebuilds the queue. Never leaks answer or article.
reviewRoutes.get("/session/today", async (c) => {
  const userId = c.get("user").id;
  const now = new Date();
  const dayStart = startOfDay(now);

  const cardRows = await loadCardsWithState(userId);
  const sets = await todayReviewSets(userId, dayStart);

  const todayCards: CardToday[] = cardRows.map((r) => ({
    id: r.id,
    hasState: r.stateId !== null,
    due: r.due,
    reviewedToday: sets.reviewedToday.has(r.id),
    correctToday: sets.correctToday.has(r.id),
    reviewedBeforeToday: sets.reviewedBefore.has(r.id),
    stock: r.ownerId === null, // global/stock deck → the 50/50 new-card split
  }));

  const plan = planToday(todayCards, now);

  // Extra-work availability (drives the "Done for today" buttons). Uses
  // reviewedTodayAny so a card already touched today (incl. bonus) isn't offered.
  const newAvailable = freshPool(
    cardRows.map((r) => ({
      id: r.id,
      hasState: r.stateId !== null,
      reviewedToday: sets.reviewedTodayAny.has(r.id),
    })),
    Infinity,
  ).length;
  const practiceAvailable = practicePool(
    cardRows.map((r) => ({
      id: r.id,
      due: r.due,
      stability: r.stability ?? 0,
      reviewedToday: sets.reviewedTodayAny.has(r.id),
    })),
    now,
    { limit: Infinity },
  ).length;
  const missesAvailable = missesPool(
    cardRows.map((r) => ({ id: r.id, missedToday: sets.missedToday.has(r.id) })),
  ).length;

  const byId = new Map(cardRows.map((r) => [r.id, r]));
  const pending = shuffle(
    plan.pendingIds.map((id) => {
      const r = byId.get(id)!;
      return { id: r.id, prompt: r.prompt, partOfSpeech: r.partOfSpeech, exampleEn: r.exampleEn };
    }),
  );

  const body: TodayResponse = {
    cards: pending,
    dueTotal: plan.dueTotal,
    newTotal: plan.newTotal,
    done: plan.done,
    pending: plan.pending,
    complete: plan.complete,
    newAvailable,
    practiceAvailable,
    missesAvailable,
  };
  return c.json(body);
});

// Extra/bonus work beyond the required set (EXTRA_WORK.md). `new` = fresh cards to
// learn; `practice` = studied, not-due cards weakest-first; `misses` = cards missed
// today, re-drillable (FSRS untouched). Never leaks answer/article. The client sends
// these reviews with `bonus: true`.
reviewRoutes.get("/session/extra", async (c) => {
  const userId = c.get("user").id;
  const type = (c.req.query("type") ?? "new") as ExtraType;
  const now = new Date();
  const dayStart = startOfDay(now);

  const cardRows = await loadCardsWithState(userId);
  const sets = await todayReviewSets(userId, dayStart);

  const ids =
    type === "misses"
      ? missesPool(
          cardRows.map((r) => ({ id: r.id, missedToday: sets.missedToday.has(r.id) })),
        )
      : type === "practice"
        ? practicePool(
            cardRows.map((r) => ({
              id: r.id,
              due: r.due,
              stability: r.stability ?? 0,
              reviewedToday: sets.reviewedTodayAny.has(r.id),
            })),
            now,
          )
        : freshPool(
            cardRows.map((r) => ({
              id: r.id,
              hasState: r.stateId !== null,
              reviewedToday: sets.reviewedTodayAny.has(r.id),
            })),
          );

  // Order is deliberate — practice is weakest-first, learn-more/misses are frequency
  // (introduction) order — so we don't shuffle (unlike the daily set).
  const byId = new Map(cardRows.map((r) => [r.id, r]));
  const cardsOut: SessionCard[] = ids.map((id) => {
    const r = byId.get(id)!;
    return { id: r.id, prompt: r.prompt, partOfSpeech: r.partOfSpeech, exampleEn: r.exampleEn };
  });

  const body: ExtraResponse = { cards: cardsOut };
  return c.json(body);
});

reviewRoutes.post("/reviews", async (c) => {
  const userId = c.get("user").id;
  const { cardId, typedAnswer, elapsedMs, bonus } = (await c.req.json()) as ReviewRequest;

  // Load the card and verify the user owns it (via deck ownership).
  const [card] = await db
    .select()
    .from(cards)
    .innerJoin(decks, eq(decks.id, cards.deckId))
    .where(
      and(eq(cards.id, cardId), or(eq(decks.ownerId, userId), isNull(decks.ownerId))),
    )
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
    bonus: bonus ?? false,
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
    exampleDe: card.exampleDe ?? null,
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
    .where(or(eq(decks.ownerId, userId), isNull(decks.ownerId)));

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
