import { Hono } from "hono";
import { and, eq, lte, notExists, sql } from "drizzle-orm";
import { db } from "./db/client";
import { cards, decks, reviewState, reviews } from "./db/schema";
import { checkAnswer } from "./srs/check";
import { scheduleNext, type StoredSrs } from "./srs/scheduler";
import { requireAuth, type AppEnv } from "./auth";
import type { ReviewRequest, ReviewResult, SessionResponse } from "../shared/types";

const NEW_PER_SESSION = 10; // cap on brand-new cards introduced per session
const SESSION_LIMIT = 40; // cap on total cards per session

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

reviewRoutes.get("/session/next", async (c) => {
  const userId = c.get("user").id;
  const now = new Date();

  // Due cards: already have schedule state and are due.
  const due = await db
    .select({ id: cards.id, prompt: cards.prompt, partOfSpeech: cards.partOfSpeech })
    .from(reviewState)
    .innerJoin(cards, eq(cards.id, reviewState.cardId))
    .innerJoin(decks, eq(decks.id, cards.deckId))
    .where(
      and(
        eq(decks.ownerId, userId),
        eq(reviewState.userId, userId),
        lte(reviewState.due, now),
      ),
    )
    .orderBy(reviewState.due)
    .limit(SESSION_LIMIT);

  // New cards: owned by the user with no schedule state yet.
  const fresh = await db
    .select({ id: cards.id, prompt: cards.prompt, partOfSpeech: cards.partOfSpeech })
    .from(cards)
    .innerJoin(decks, eq(decks.id, cards.deckId))
    .where(
      and(
        eq(decks.ownerId, userId),
        notExists(
          db
            .select({ x: sql`1` })
            .from(reviewState)
            .where(and(eq(reviewState.cardId, cards.id), eq(reviewState.userId, userId))),
        ),
      ),
    )
    .limit(NEW_PER_SESSION);

  const combined = shuffle([...due, ...fresh]).slice(0, SESSION_LIMIT);

  const body: SessionResponse = {
    cards: combined,
    dueCount: due.length,
    newCount: fresh.length,
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

  const now = new Date();
  const next = scheduleNext(prev, result.correct, now);

  await db
    .insert(reviewState)
    .values({ userId, cardId, ...next })
    .onConflictDoUpdate({
      target: [reviewState.userId, reviewState.cardId],
      set: next,
    });

  await db.insert(reviews).values({
    userId,
    cardId,
    rating: result.correct ? 3 : 1,
    typedAnswer: typedAnswer ?? null,
    elapsedMs: elapsedMs ?? null,
  });

  const body: ReviewResult = {
    correct: result.correct,
    expected: result.expected,
    reason: result.reason,
    nextDue: next.due.toISOString(),
  };
  return c.json(body);
});
