import { and, eq } from "drizzle-orm";
import { db } from "./client";
import { cards, decks } from "./schema";

type StarterWord = {
  prompt: string; // English
  answer: string; // German (bare noun for nouns; full word otherwise)
  article?: string; // der/die/das for nouns
  pos?: string; // part of speech
};

// A small A1 starter set to exercise the loop on day one. Nouns include gender.
export const STARTER_WORDS: StarterWord[] = [
  { prompt: "the man", answer: "Mann", article: "der", pos: "noun" },
  { prompt: "the woman", answer: "Frau", article: "die", pos: "noun" },
  { prompt: "the child", answer: "Kind", article: "das", pos: "noun" },
  { prompt: "the house", answer: "Haus", article: "das", pos: "noun" },
  { prompt: "the dog", answer: "Hund", article: "der", pos: "noun" },
  { prompt: "the cat", answer: "Katze", article: "die", pos: "noun" },
  { prompt: "the water", answer: "Wasser", article: "das", pos: "noun" },
  { prompt: "the city", answer: "Stadt", article: "die", pos: "noun" },
  { prompt: "the day", answer: "Tag", article: "der", pos: "noun" },
  { prompt: "the night", answer: "Nacht", article: "die", pos: "noun" },
  { prompt: "the book", answer: "Buch", article: "das", pos: "noun" },
  { prompt: "the car", answer: "Auto", article: "das", pos: "noun" },
  { prompt: "the door", answer: "Tür", article: "die", pos: "noun" },
  { prompt: "the street", answer: "Straße", article: "die", pos: "noun" },
  { prompt: "the friend (male)", answer: "Freund", article: "der", pos: "noun" },
  { prompt: "the food / meal", answer: "Essen", article: "das", pos: "noun" },
  { prompt: "to be", answer: "sein", pos: "verb" },
  { prompt: "to have", answer: "haben", pos: "verb" },
  { prompt: "to go", answer: "gehen", pos: "verb" },
  { prompt: "to come", answer: "kommen", pos: "verb" },
  { prompt: "to eat", answer: "essen", pos: "verb" },
  { prompt: "to drink", answer: "trinken", pos: "verb" },
  { prompt: "to speak", answer: "sprechen", pos: "verb" },
  { prompt: "to see", answer: "sehen", pos: "verb" },
  { prompt: "to make / do", answer: "machen", pos: "verb" },
  { prompt: "to want", answer: "wollen", pos: "verb" },
  { prompt: "good", answer: "gut", pos: "adjective" },
  { prompt: "big / tall", answer: "groß", pos: "adjective" },
  { prompt: "small", answer: "klein", pos: "adjective" },
  { prompt: "new", answer: "neu", pos: "adjective" },
  { prompt: "and", answer: "und", pos: "conjunction" },
  { prompt: "but", answer: "aber", pos: "conjunction" },
  { prompt: "today", answer: "heute", pos: "adverb" },
  { prompt: "tomorrow", answer: "morgen", pos: "adverb" },
  { prompt: "always", answer: "immer", pos: "adverb" },
  { prompt: "thank you", answer: "danke", pos: "phrase" },
];

/**
 * Give a user their starter deck. Idempotent: does nothing if they already have
 * a seed deck. Returns true if it created one.
 */
export async function seedUser(userId: string): Promise<boolean> {
  const [existing] = await db
    .select({ id: decks.id })
    .from(decks)
    .where(and(eq(decks.ownerId, userId), eq(decks.source, "seed")))
    .limit(1);
  if (existing) return false;

  const [deck] = await db
    .insert(decks)
    .values({
      ownerId: userId,
      name: "Starter — A1",
      source: "seed",
      description: "Common German words to get you started.",
    })
    .returning();

  await db.insert(cards).values(
    STARTER_WORDS.map((w) => ({
      deckId: deck.id,
      prompt: w.prompt,
      answer: w.answer,
      article: w.article ?? null,
      partOfSpeech: w.pos ?? null,
      source: "seed",
    })),
  );
  return true;
}
