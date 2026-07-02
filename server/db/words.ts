// The global frequency word corpus: a single ownerless (global) deck of ~3,700
// frequency-ranked German words that every user reviews through the normal Words
// loop. Analogous to the verb catalog (server/db/verbs.ts) — shared reference
// data, edited in one place — but it reuses the decks/cards model rather than its
// own tables, because a word IS a card.
//
// The corpus itself lives in the generated words.data.json (see scripts/gen-words.ts);
// this module just knows how to load it into a DB. Prod gets it via the data
// migration drizzle/0005_seed_words.sql; use `npm run db:seed:words` locally.

import { eq } from "drizzle-orm";
import { db } from "./client";
import { cards, decks } from "./schema";
import type { ParsedWord } from "./words-parse";
import wordsData from "./words.data.json" with { type: "json" };

// Fixed id of the global corpus deck. MUST match scripts/gen-words.ts and the
// deck row in drizzle/0005_seed_words.sql.
export const WORD_DECK_ID = "b7c8e3a0-6d4f-4e2a-9c1b-000000005000";
const DECK_NAME = "German — Frequency 5000";
const DECK_DESC = "The ~3,700 most frequent German words, ordered by frequency.";

const WORDS = wordsData as ParsedWord[];

// Rows ready for a `cards` insert into the global deck.
export function wordRows() {
  return WORDS.map((w) => ({
    deckId: WORD_DECK_ID,
    prompt: w.prompt,
    answer: w.answer,
    answerAlts: w.answerAlts,
    partOfSpeech: w.partOfSpeech,
    article: w.article,
    notes: w.notes,
    frequencyRank: w.frequencyRank,
    source: "seed",
  }));
}

/**
 * Seed the global word corpus. Idempotent: if the global deck already exists it's
 * left untouched (returns 0). Otherwise creates the ownerless deck + all cards and
 * returns how many cards were inserted. Used by `npm run db:seed:words`; the
 * initial prod load is the data migration.
 */
export async function seedWords(): Promise<number> {
  const [existing] = await db
    .select({ id: decks.id })
    .from(decks)
    .where(eq(decks.id, WORD_DECK_ID))
    .limit(1);
  if (existing) return 0;

  await db.insert(decks).values({
    id: WORD_DECK_ID,
    ownerId: null, // global — no owner
    name: DECK_NAME,
    source: "seed",
    description: DECK_DESC,
  });

  const rows = wordRows();
  await db.insert(cards).values(rows);
  return rows.length;
}
