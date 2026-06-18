import { Hono } from "hono";
import { and, eq } from "drizzle-orm";
import { db } from "./db/client";
import { cards, decks, reviewState } from "./db/schema";
import { requireAuth, type AppEnv } from "./auth";
import type { DeckCard, DeckCardState, DeckDetail, DeckSummary } from "../shared/types";

export const deckRoutes = new Hono<AppEnv>();
deckRoutes.use("*", requireAuth);

// List the user's decks with per-deck progress. Card counts are aggregated in JS
// (the dataset is tiny) to keep the query simple and the logic obvious.
deckRoutes.get("/decks", async (c) => {
  const userId = c.get("user").id;
  const now = Date.now();

  const rows = await db
    .select({
      deckId: decks.id,
      name: decks.name,
      source: decks.source,
      cardId: cards.id,
      state: reviewState.state,
      due: reviewState.due,
    })
    .from(decks)
    .leftJoin(cards, eq(cards.deckId, decks.id))
    .leftJoin(
      reviewState,
      and(eq(reviewState.cardId, cards.id), eq(reviewState.userId, userId)),
    )
    .where(eq(decks.ownerId, userId))
    .orderBy(decks.createdAt);

  const byDeck = new Map<string, DeckSummary>();
  for (const r of rows) {
    let d = byDeck.get(r.deckId);
    if (!d) {
      d = { id: r.deckId, name: r.name, source: r.source, total: 0, due: 0, newCount: 0, learning: 0, known: 0 };
      byDeck.set(r.deckId, d); // insertion order = createdAt order
    }
    if (!r.cardId) continue; // deck with no cards
    d.total++;
    const state = (r.state ?? "new") as DeckCardState;
    if (state === "review") d.known++;
    else if (state === "learning" || state === "relearning") d.learning++;
    else d.newCount++;
    if (r.due && r.due.getTime() <= now) d.due++;
  }

  return c.json([...byDeck.values()]);
});

// A single deck and all its cards, each tagged with this user's progress state.
deckRoutes.get("/decks/:id", async (c) => {
  const userId = c.get("user").id;
  const id = c.req.param("id");

  const [deck] = await db
    .select()
    .from(decks)
    .where(and(eq(decks.id, id), eq(decks.ownerId, userId)))
    .limit(1);
  if (!deck) return c.json({ error: "deck not found" }, 404);

  const rows = await db
    .select({
      id: cards.id,
      prompt: cards.prompt,
      answer: cards.answer,
      article: cards.article,
      partOfSpeech: cards.partOfSpeech,
      state: reviewState.state,
    })
    .from(cards)
    .leftJoin(
      reviewState,
      and(eq(reviewState.cardId, cards.id), eq(reviewState.userId, userId)),
    )
    .where(eq(cards.deckId, id))
    .orderBy(cards.createdAt);

  const deckCards: DeckCard[] = rows.map((r) => ({
    id: r.id,
    prompt: r.prompt,
    answer: r.answer,
    article: r.article,
    partOfSpeech: r.partOfSpeech,
    state: (r.state ?? "new") as DeckCardState,
  }));

  const body: DeckDetail = {
    id: deck.id,
    name: deck.name,
    source: deck.source,
    description: deck.description,
    cards: deckCards,
  };
  return c.json(body);
});
