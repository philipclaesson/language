import { Hono } from "hono";
import { and, eq } from "drizzle-orm";
import Anthropic from "@anthropic-ai/sdk";
import { db } from "./db/client";
import { cards, decks } from "./db/schema";
import { requireAuth, type AppEnv } from "./auth";
import { env } from "./env";
import { fullAnswer } from "./srs/check";
import { normalizeCardInput, type RawCardInput } from "./chat/cards";
import { MODEL, MAX_TOOL_TURNS, tools, systemPrompt } from "./chat/agent";
import type { ChatAction, ChatMessage, ChatRequest, ChatResponse } from "../shared/types";

const anthropic = new Anthropic({ apiKey: env.anthropicApiKey });

// ---- Tool execution --------------------------------------------------------

type ToolOutcome = { text: string; action?: ChatAction; isError?: boolean };

function field<T = unknown>(input: unknown, key: string): T | undefined {
  if (input && typeof input === "object" && key in input) {
    return (input as Record<string, unknown>)[key] as T;
  }
  return undefined;
}

async function ownDeck(userId: string, deckId: string) {
  const [deck] = await db
    .select()
    .from(decks)
    .where(and(eq(decks.id, deckId), eq(decks.ownerId, userId)))
    .limit(1);
  return deck;
}

async function ownCard(userId: string, cardId: string) {
  const [row] = await db
    .select({
      id: cards.id,
      deckId: cards.deckId,
      prompt: cards.prompt,
      answer: cards.answer,
      article: cards.article,
      partOfSpeech: cards.partOfSpeech,
      answerAlts: cards.answerAlts,
      notes: cards.notes,
      exampleEn: cards.exampleEn,
      exampleDe: cards.exampleDe,
    })
    .from(cards)
    .innerJoin(decks, eq(cards.deckId, decks.id))
    .where(and(eq(cards.id, cardId), eq(decks.ownerId, userId)))
    .limit(1);
  return row;
}

async function execTool(name: string, input: unknown, userId: string): Promise<ToolOutcome> {
  switch (name) {
    case "create_deck": {
      const deckName = field<string>(input, "name")?.trim();
      if (!deckName) return { text: "Error: name is required.", isError: true };
      const [deck] = await db
        .insert(decks)
        .values({
          ownerId: userId,
          name: deckName,
          source: "ai_chat",
          description: field<string>(input, "description")?.trim() || null,
        })
        .returning();
      return {
        text: `Created deck "${deck.name}" with id ${deck.id}. Add cards with add_cards.`,
        action: { kind: "deck_created", summary: `Created deck “${deck.name}”` },
      };
    }

    case "add_cards": {
      const deckId = field<string>(input, "deck_id");
      const rawCards = field<unknown[]>(input, "cards");
      if (!deckId || !Array.isArray(rawCards) || rawCards.length === 0) {
        return { text: "Error: deck_id and a non-empty cards array are required.", isError: true };
      }
      const deck = await ownDeck(userId, deckId);
      if (!deck) return { text: "Error: no such deck (or not yours).", isError: true };

      let normalized;
      try {
        normalized = rawCards.map((c) => normalizeCardInput(c as RawCardInput));
      } catch (e) {
        return { text: `Error: ${(e as Error).message}`, isError: true };
      }
      await db.insert(cards).values(
        normalized.map((c) => ({
          deckId: deck.id,
          prompt: c.prompt,
          answer: c.answer,
          answerAlts: c.answerAlts,
          partOfSpeech: c.partOfSpeech,
          article: c.article,
          notes: c.notes,
          exampleEn: c.exampleEn,
          exampleDe: c.exampleDe,
          source: "ai_chat",
        })),
      );
      const n = normalized.length;
      return {
        text: `Added ${n} card${n === 1 ? "" : "s"} to "${deck.name}".`,
        action: { kind: "cards_added", summary: `Added ${n} card${n === 1 ? "" : "s"} to “${deck.name}”` },
      };
    }

    case "edit_card": {
      const cardId = field<string>(input, "card_id");
      if (!cardId) return { text: "Error: card_id is required.", isError: true };
      const existing = await ownCard(userId, cardId);
      if (!existing) return { text: "Error: no such card (or not yours).", isError: true };

      // Merge the provided fields over the current card, then re-normalize the
      // whole thing so the bare-noun/article rules hold for edits too.
      const merged: RawCardInput = {
        prompt: field(input, "prompt") ?? existing.prompt,
        answer: field(input, "answer") ?? existing.answer,
        article: field(input, "article") ?? existing.article ?? undefined,
        part_of_speech: field(input, "part_of_speech") ?? existing.partOfSpeech ?? undefined,
        answer_alts: field(input, "answer_alts") ?? existing.answerAlts,
        notes: field(input, "notes") ?? existing.notes ?? undefined,
        example_en: field(input, "example_en") ?? existing.exampleEn ?? undefined,
        example_de: field(input, "example_de") ?? existing.exampleDe ?? undefined,
      };
      let c;
      try {
        c = normalizeCardInput(merged);
      } catch (e) {
        return { text: `Error: ${(e as Error).message}`, isError: true };
      }
      await db
        .update(cards)
        .set({
          prompt: c.prompt,
          answer: c.answer,
          answerAlts: c.answerAlts,
          partOfSpeech: c.partOfSpeech,
          article: c.article,
          notes: c.notes,
          exampleEn: c.exampleEn,
          exampleDe: c.exampleDe,
        })
        .where(eq(cards.id, cardId));
      return {
        text: `Updated card ${cardId}: ${c.prompt} → ${fullAnswer(c)}.`,
        action: { kind: "card_edited", summary: `Edited “${c.prompt}”` },
      };
    }

    case "delete_card": {
      const cardId = field<string>(input, "card_id");
      if (!cardId) return { text: "Error: card_id is required.", isError: true };
      const existing = await ownCard(userId, cardId);
      if (!existing) return { text: "Error: no such card (or not yours).", isError: true };
      await db.delete(cards).where(eq(cards.id, cardId));
      return {
        text: `Deleted card "${existing.prompt}".`,
        action: { kind: "card_deleted", summary: `Deleted “${existing.prompt}”` },
      };
    }

    case "rename_deck": {
      const deckId = field<string>(input, "deck_id");
      const newName = field<string>(input, "name")?.trim();
      if (!deckId || !newName) return { text: "Error: deck_id and name are required.", isError: true };
      const deck = await ownDeck(userId, deckId);
      if (!deck) return { text: "Error: no such deck (or not yours).", isError: true };
      await db.update(decks).set({ name: newName }).where(eq(decks.id, deckId));
      return {
        text: `Renamed "${deck.name}" to "${newName}".`,
        action: { kind: "deck_renamed", summary: `Renamed “${deck.name}” → “${newName}”` },
      };
    }

    case "delete_deck": {
      const deckId = field<string>(input, "deck_id");
      if (!deckId) return { text: "Error: deck_id is required.", isError: true };
      const deck = await ownDeck(userId, deckId);
      if (!deck) return { text: "Error: no such deck (or not yours).", isError: true };
      await db.delete(decks).where(eq(decks.id, deckId)); // cascades to cards + review_state
      return {
        text: `Deleted deck "${deck.name}" and all its cards.`,
        action: { kind: "deck_deleted", summary: `Deleted deck “${deck.name}”` },
      };
    }

    case "get_deck": {
      const deckId = field<string>(input, "deck_id");
      if (!deckId) return { text: "Error: deck_id is required.", isError: true };
      const deck = await ownDeck(userId, deckId);
      if (!deck) return { text: "Error: no such deck (or not yours).", isError: true };
      const rows = await db
        .select({
          id: cards.id,
          prompt: cards.prompt,
          answer: cards.answer,
          article: cards.article,
          partOfSpeech: cards.partOfSpeech,
        })
        .from(cards)
        .where(eq(cards.deckId, deckId))
        .orderBy(cards.createdAt);
      if (rows.length === 0) return { text: `Deck "${deck.name}" is empty.` };
      const lines = rows.map(
        (r) => `- ${r.id} | ${r.prompt} → ${fullAnswer(r)}${r.partOfSpeech ? ` (${r.partOfSpeech})` : ""}`,
      );
      return { text: `Deck "${deck.name}" cards:\n${lines.join("\n")}` };
    }

    default:
      return { text: `Error: unknown tool ${name}.`, isError: true };
  }
}

// ---- System prompt ---------------------------------------------------------

async function deckOverview(userId: string): Promise<string> {
  const rows = await db
    .select({ deckId: decks.id, name: decks.name, source: decks.source, cardId: cards.id })
    .from(decks)
    .leftJoin(cards, eq(cards.deckId, decks.id))
    .where(eq(decks.ownerId, userId))
    .orderBy(decks.createdAt);

  const byDeck = new Map<string, { name: string; source: string; count: number }>();
  for (const r of rows) {
    let d = byDeck.get(r.deckId);
    if (!d) byDeck.set(r.deckId, (d = { name: r.name, source: r.source, count: 0 }));
    if (r.cardId) d.count++;
  }
  if (byDeck.size === 0) return "The learner has no decks yet.";
  return [...byDeck.entries()]
    .map(([id, d]) => `- ${id} | "${d.name}" (${d.count} cards, source: ${d.source})`)
    .join("\n");
}

// ---- Route -----------------------------------------------------------------

export const chatRoutes = new Hono<AppEnv>();
chatRoutes.use("*", requireAuth);

chatRoutes.post("/chat", async (c) => {
  const userId = c.get("user").id;
  const payload = (await c.req.json()) as ChatRequest;
  const history = Array.isArray(payload.messages) ? payload.messages : [];

  const messages: Anthropic.MessageParam[] = history
    .filter((m: ChatMessage) => m && typeof m.content === "string" && m.content.trim())
    .map((m) => ({ role: m.role === "assistant" ? "assistant" : "user", content: m.content }));

  if (messages.length === 0 || messages[messages.length - 1].role !== "user") {
    return c.json({ error: "expected a non-empty history ending in a user message" }, 400);
  }

  const system = systemPrompt(await deckOverview(userId));
  const actions: ChatAction[] = [];
  let reply = "";

  for (let turn = 0; turn < MAX_TOOL_TURNS; turn++) {
    const res = await anthropic.messages.create({
      model: MODEL,
      max_tokens: 4096,
      thinking: { type: "adaptive" },
      output_config: { effort: "medium" },
      system,
      tools,
      messages,
    });

    if (res.stop_reason === "tool_use") {
      messages.push({ role: "assistant", content: res.content });
      const toolResults: Anthropic.ToolResultBlockParam[] = [];
      for (const block of res.content) {
        if (block.type !== "tool_use") continue;
        const outcome = await execTool(block.name, block.input, userId);
        if (outcome.action) actions.push(outcome.action);
        toolResults.push({
          type: "tool_result",
          tool_use_id: block.id,
          content: outcome.text,
          is_error: outcome.isError,
        });
      }
      messages.push({ role: "user", content: toolResults });
      continue;
    }

    reply = res.content
      .filter((b): b is Anthropic.TextBlock => b.type === "text")
      .map((b) => b.text)
      .join("\n")
      .trim();
    break;
  }

  if (!reply) {
    reply = actions.length
      ? "Done."
      : "Sorry — I couldn't finish that. Could you rephrase?";
  }

  const body: ChatResponse = { reply, actions };
  return c.json(body);
});
