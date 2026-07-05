import { Hono } from "hono";
import { and, eq } from "drizzle-orm";
import Anthropic from "@anthropic-ai/sdk";
import { db } from "./db/client";
import { cards, decks } from "./db/schema";
import { requireAuth, type AppEnv } from "./auth";
import { env } from "./env";
import { normalizeCardInput, type NormalizedCard, type RawCardInput } from "./chat/cards";
import { diffWords } from "./freund/diff";
import { todaysVocab } from "./freund/seed";
import {
  CHAT_MODEL,
  REVIEW_MODEL,
  chatSystemPrompt,
  respondTool,
  reviewSystemPrompt,
  suggestCardsTool,
} from "./freund/agent";
import type {
  FreundMessage,
  FreundRequest,
  FreundResponse,
  FreundReviewRequest,
  FreundReviewResponse,
  FreundSaveRequest,
  FreundSaveResponse,
  FreundSuggestedCard,
} from "../shared/types";

const anthropic = new Anthropic({ apiKey: env.anthropicApiKey });

const FREUND_DECK_NAME = "Freund cards";
const FREUND_SOURCE = "freund";

// ---- Helpers ---------------------------------------------------------------

function str(v: unknown): string | undefined {
  if (typeof v !== "string") return undefined;
  const t = v.trim();
  return t.length ? t : undefined;
}

// Map the client history into Anthropic messages, dropping empties. Returns null
// if the history is empty or doesn't end on a user turn (nothing to respond to).
function toMessages(history: FreundMessage[]): Anthropic.MessageParam[] | null {
  const messages: Anthropic.MessageParam[] = history
    .filter((m) => m && typeof m.content === "string" && m.content.trim())
    .map((m) => ({ role: m.role === "assistant" ? "assistant" : "user", content: m.content }));
  if (messages.length === 0 || messages[messages.length - 1].role !== "user") return null;
  return messages;
}

// The forced tool call's input (forced tool_choice guarantees exactly one).
function toolInput(res: Anthropic.Message, name: string): Record<string, unknown> | null {
  for (const block of res.content) {
    if (block.type === "tool_use" && block.name === name) {
      return block.input as Record<string, unknown>;
    }
  }
  return null;
}

// Turn our client-facing (camelCase) card back into the normalizer's snake_case
// input, so accepted cards are re-validated before they hit the DB.
function toRaw(c: FreundSuggestedCard): RawCardInput {
  return {
    prompt: c.prompt,
    answer: c.answer,
    article: c.article ?? undefined,
    part_of_speech: c.partOfSpeech ?? undefined,
    answer_alts: c.answerAlts,
    notes: c.notes ?? undefined,
    example_en: c.exampleEn ?? undefined,
    example_de: c.exampleDe ?? undefined,
  };
}

function toSuggested(c: NormalizedCard): FreundSuggestedCard {
  return {
    prompt: c.prompt,
    answer: c.answer,
    article: c.article,
    partOfSpeech: c.partOfSpeech,
    answerAlts: c.answerAlts,
    notes: c.notes,
    exampleEn: c.exampleEn,
    exampleDe: c.exampleDe,
  };
}

// ---- Routes ----------------------------------------------------------------

export const freundRoutes = new Hono<AppEnv>();
freundRoutes.use("*", requireAuth);

// One conversational turn: Freund replies in German and, if the learner's last
// message had mistakes, corrects + explains them. Stateless (client replays the
// history), seeded with today's practice vocab.
freundRoutes.post("/freund/message", async (c) => {
  const userId = c.get("user").id;
  const payload = (await c.req.json()) as FreundRequest;
  const history = Array.isArray(payload.messages) ? payload.messages : [];

  const messages = toMessages(history);
  if (!messages) return c.json({ error: "expected a history ending in a user message" }, 400);

  const system = chatSystemPrompt(await todaysVocab(userId));

  const res = await anthropic.messages.create({
    model: CHAT_MODEL,
    max_tokens: 1024,
    system,
    tools: [respondTool],
    tool_choice: { type: "tool", name: "respond" },
    messages,
  });

  const input = toolInput(res, "respond");
  const reply = str(input?.reply) ?? "Wie geht es dir?";
  const explanation = str(input?.explanation) ?? null;
  const correctionText = str(input?.correction);

  // Diff the correction against what the learner actually typed (the last user turn).
  const lastUser = history.filter((m) => m.role === "user").at(-1)?.content ?? "";
  const correction = correctionText ? diffWords(lastUser, correctionText) : null;

  const body: FreundResponse = { reply, explanation, correction };
  return c.json(body);
});

// End of conversation: propose flashcards for what the learner got wrong. Returns
// suggestions only — nothing is saved until the learner accepts them (/freund/cards).
freundRoutes.post("/freund/review", async (c) => {
  const payload = (await c.req.json()) as FreundReviewRequest;
  const history = Array.isArray(payload.messages) ? payload.messages : [];

  // The conversation always ends on Freund's (assistant) turn, and the 4.x+ models
  // reject a request ending on an assistant message (it reads as a prefill). So for
  // this analysis call we flatten the whole transcript into ONE user message rather
  // than replaying alternating roles — also the natural shape for "review this chat".
  const convo = history.filter((m) => m && typeof m.content === "string" && m.content.trim());
  if (convo.length === 0) return c.json({ cards: [] } satisfies FreundReviewResponse);
  const transcript = convo
    .map((m) => `${m.role === "user" ? "Learner" : "Freund"}: ${m.content}`)
    .join("\n");

  const res = await anthropic.messages.create({
    model: REVIEW_MODEL,
    max_tokens: 2048,
    system: reviewSystemPrompt,
    tools: [suggestCardsTool],
    tool_choice: { type: "tool", name: "suggest_cards" },
    messages: [
      { role: "user", content: `Here is the full conversation to review:\n\n${transcript}` },
    ],
  });

  const input = toolInput(res, "suggest_cards");
  const raw = Array.isArray(input?.cards) ? (input!.cards as unknown[]) : [];

  const cardsOut: FreundSuggestedCard[] = [];
  for (const r of raw) {
    try {
      cardsOut.push(toSuggested(normalizeCardInput(r as RawCardInput)));
    } catch {
      // Skip a malformed suggestion rather than failing the whole review.
    }
  }

  const body: FreundReviewResponse = { cards: cardsOut };
  return c.json(body);
});

// Save the accepted cards into the single, shared "Freund cards" deck (created on
// first use, reused across all conversations).
freundRoutes.post("/freund/cards", async (c) => {
  const userId = c.get("user").id;
  const payload = (await c.req.json()) as FreundSaveRequest;
  const accepted = Array.isArray(payload.cards) ? payload.cards : [];

  let normalized: NormalizedCard[];
  try {
    normalized = accepted.map((card) => normalizeCardInput(toRaw(card)));
  } catch (e) {
    return c.json({ error: (e as Error).message }, 400);
  }
  if (normalized.length === 0) return c.json({ error: "no cards to save" }, 400);

  // Find-or-create the learner's single Freund deck.
  let [deck] = await db
    .select()
    .from(decks)
    .where(and(eq(decks.ownerId, userId), eq(decks.source, FREUND_SOURCE)))
    .limit(1);
  if (!deck) {
    [deck] = await db
      .insert(decks)
      .values({
        ownerId: userId,
        name: FREUND_DECK_NAME,
        source: FREUND_SOURCE,
        description: "Words and grammar you got wrong while chatting with Freund.",
      })
      .returning();
  }

  await db.insert(cards).values(
    normalized.map((cardValue) => ({
      deckId: deck.id,
      prompt: cardValue.prompt,
      answer: cardValue.answer,
      answerAlts: cardValue.answerAlts,
      partOfSpeech: cardValue.partOfSpeech,
      article: cardValue.article,
      notes: cardValue.notes,
      exampleEn: cardValue.exampleEn,
      exampleDe: cardValue.exampleDe,
      source: FREUND_SOURCE,
    })),
  );

  const body: FreundSaveResponse = {
    added: normalized.length,
    deckId: deck.id,
    deckName: deck.name,
  };
  return c.json(body);
});
