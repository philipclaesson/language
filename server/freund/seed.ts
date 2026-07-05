// Gather the words and verbs the learner is practicing right now, so Freund's
// system prompt can weave them into the conversation. Server-side only — this
// deliberately includes the German answers (the review APIs never do), which is
// fine because it never reaches the client.
import { and, asc, eq, isNull, lte, or, sql } from "drizzle-orm";
import { db } from "../db/client";
import { cards, decks, reviewState, verbs, verbReviewState } from "../db/schema";
import { fullAnswer } from "../srs/check";
import { endOfDay } from "../srs/day";
import type { VocabSeed } from "./agent";

// Caps so the prompt stays lean regardless of how much is due.
const DUE_WORDS = 20;
const NEW_WORDS = 8;
const DUE_VERBS = 8;
const NEW_VERBS = 4;

export async function todaysVocab(userId: string): Promise<VocabSeed> {
  const end = endOfDay(new Date());
  const ownedOrGlobal = or(eq(decks.ownerId, userId), isNull(decks.ownerId));

  // Words due (or overdue) today — the review words in rotation right now.
  const dueWords = await db
    .select({ answer: cards.answer, article: cards.article, partOfSpeech: cards.partOfSpeech })
    .from(cards)
    .innerJoin(decks, eq(decks.id, cards.deckId))
    .innerJoin(
      reviewState,
      and(eq(reviewState.cardId, cards.id), eq(reviewState.userId, userId)),
    )
    .where(and(ownedOrGlobal, lte(reviewState.due, end)))
    .orderBy(asc(reviewState.due))
    .limit(DUE_WORDS);

  // The next new words to be introduced (no review state yet), in introduction order.
  const newWords = await db
    .select({ answer: cards.answer, article: cards.article, partOfSpeech: cards.partOfSpeech })
    .from(cards)
    .innerJoin(decks, eq(decks.id, cards.deckId))
    .leftJoin(
      reviewState,
      and(eq(reviewState.cardId, cards.id), eq(reviewState.userId, userId)),
    )
    .where(and(ownedOrGlobal, isNull(reviewState.id)))
    .orderBy(sql`${cards.frequencyRank} asc nulls first`, asc(cards.createdAt))
    .limit(NEW_WORDS);

  const dueVerbs = await db
    .select({ infinitive: verbs.infinitive, english: verbs.english })
    .from(verbs)
    .innerJoin(
      verbReviewState,
      and(eq(verbReviewState.verbId, verbs.id), eq(verbReviewState.userId, userId)),
    )
    .where(lte(verbReviewState.due, end))
    .orderBy(asc(verbReviewState.due))
    .limit(DUE_VERBS);

  const newVerbs = await db
    .select({ infinitive: verbs.infinitive, english: verbs.english })
    .from(verbs)
    .leftJoin(
      verbReviewState,
      and(eq(verbReviewState.verbId, verbs.id), eq(verbReviewState.userId, userId)),
    )
    .where(isNull(verbReviewState.id))
    .orderBy(asc(verbs.frequencyRank))
    .limit(NEW_VERBS);

  // De-dupe while preserving order (a word could appear in both pools via race).
  const words = [...new Set([...dueWords, ...newWords].map((w) => fullAnswer(w)))];
  const verbList = [
    ...new Map(
      [...dueVerbs, ...newVerbs].map((v) => [v.infinitive, `${v.infinitive} (${v.english})`]),
    ).values(),
  ];

  return { words, verbs: verbList };
}
