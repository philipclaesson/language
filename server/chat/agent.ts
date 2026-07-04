// Pure configuration for the AI tutor: model, tool schemas, system prompt.
// No I/O — kept separate from chat-routes.ts so it can be exercised directly
// (see smoke tests) without booting the DB/env. The route owns tool *execution*.
import Anthropic from "@anthropic-ai/sdk";

// Sonnet 4.6: strong German + tool use, fast and cheap at two-user volume.
// Bump to claude-opus-4-8 here if answer quality ever needs it.
export const MODEL = "claude-sonnet-4-6";
export const MAX_TOOL_TURNS = 8; // guard against a runaway tool loop

const CARD_PROPS = {
  prompt: { type: "string", description: "The English prompt shown to the learner, e.g. \"the dog\"." },
  answer: {
    type: "string",
    description:
      "The German answer. For NOUNS give the bare noun WITHOUT its article (\"Hund\", not \"der Hund\") and put the gender in `article`. For everything else, the full word/phrase.",
  },
  article: {
    type: "string",
    enum: ["der", "die", "das"],
    description: "The definite article for nouns only (gender). Omit for non-nouns.",
  },
  part_of_speech: {
    type: "string",
    description: "noun | verb | adjective | adverb | conjunction | phrase | … Set \"noun\" whenever you set an article.",
  },
  answer_alts: {
    type: "array",
    items: { type: "string" },
    description: "Other accepted spellings/synonyms (bare, no article), e.g. [\"Wagen\"] for \"das Auto\".",
  },
  example_en: {
    type: "string",
    description:
      "Optional English gloss of an example sentence, shown to the learner UP FRONT for context (helps when the prompt is ambiguous). Must NOT contain the German answer.",
  },
  example_de: {
    type: "string",
    description:
      "Optional German example sentence using the target word, revealed only AFTER a wrong answer to reinforce it in context. It's the translation of `example_en`; supply the two together.",
  },
  notes: { type: "string", description: "Optional short mnemonic or usage note (not an example sentence)." },
} as const;

export const tools: Anthropic.Tool[] = [
  {
    name: "create_deck",
    description:
      "Create a new, empty deck owned by the learner. Use when starting a fresh topic. Returns the new deck id, which you pass to add_cards.",
    input_schema: {
      type: "object",
      properties: {
        name: { type: "string", description: "Short deck title, e.g. \"Top 10 irregular verbs\"." },
        description: { type: "string", description: "Optional one-line description / the explanation behind the deck." },
      },
      required: ["name"],
    },
  },
  {
    name: "add_cards",
    description:
      "Add one or more cards to an existing deck. Use after create_deck, or to extend a deck the learner already has. New cards automatically enter the spaced-repetition queue.",
    input_schema: {
      type: "object",
      properties: {
        deck_id: { type: "string", description: "The deck to add to." },
        cards: {
          type: "array",
          description: "The cards to add.",
          items: { type: "object", properties: CARD_PROPS, required: ["prompt", "answer"] },
        },
      },
      required: ["deck_id", "cards"],
    },
  },
  {
    name: "edit_card",
    description:
      "Edit fields of one existing card. Only pass the fields you want to change; omitted fields are left as-is. Call get_deck first to find the card id.",
    input_schema: {
      type: "object",
      properties: { card_id: { type: "string" }, ...CARD_PROPS },
      required: ["card_id"],
    },
  },
  {
    name: "delete_card",
    description: "Delete one card by id. Confirm with the learner first — this is destructive.",
    input_schema: {
      type: "object",
      properties: { card_id: { type: "string" } },
      required: ["card_id"],
    },
  },
  {
    name: "rename_deck",
    description: "Rename an existing deck.",
    input_schema: {
      type: "object",
      properties: { deck_id: { type: "string" }, name: { type: "string" } },
      required: ["deck_id", "name"],
    },
  },
  {
    name: "delete_deck",
    description:
      "Delete an entire deck and all its cards. Confirm with the learner first — this is destructive and irreversible.",
    input_schema: {
      type: "object",
      properties: { deck_id: { type: "string" } },
      required: ["deck_id"],
    },
  },
  {
    name: "get_deck",
    description:
      "List a deck's cards with their ids and current values. Call this before editing or deleting individual cards so you know their ids.",
    input_schema: {
      type: "object",
      properties: { deck_id: { type: "string" } },
      required: ["deck_id"],
    },
  },
];

export function systemPrompt(decksBlock: string): string {
  return `You are a friendly, expert German tutor inside "Sprachen", a spaced-repetition vocabulary app for two learners. You do two things:

1. Teach. Answer questions about German — grammar, usage, the difference between words (e.g. möchte vs. hätte), with clear, concise explanations and examples. Be warm and direct.
2. Build decks. Help the learner turn what you discuss into flashcards they can drill, using the tools.

How the app works: each card has an English prompt and the learner types the German. The app grades all-or-nothing and schedules reviews with FSRS. Cards you add flow into the review queue automatically.

CARD CONVENTION — follow this exactly, or cards become ungradeable:
- prompt: the English side, e.g. "the dog".
- answer: the German word. For NOUNS, the BARE noun with NO article ("Hund"), and put the gender in \`article\` ("der"). For verbs/adjectives/etc., the full word ("gehen", "gut").
- Always set part_of_speech = "noun" and the correct article for nouns — gender is a core thing the learner is testing.
- Use answer_alts for accepted synonyms or alternate spellings (bare, no article).
- Keep prompts unambiguous: if two German words share an English gloss, disambiguate the prompt (e.g. "the friend (male)").
- Prefer adding an example sentence pair: example_de (a natural German sentence using the word) and example_en (its English translation). The learner sees example_en up front for context and example_de after a miss, so it's a strong memory aid — especially for abstract or ambiguous words. example_en must not give away the German answer.

Working style:
- When the learner asks to build a deck, propose the words first (briefly), then create the deck and add the cards. Don't ask for permission for normal create/add — just do it and report what you made.
- Before deleting a deck or card, confirm with the learner first.
- To edit or delete individual cards, call get_deck to get their ids.
- Keep replies short and chatty — this is a phone-friendly chat. Don't dump the full card table back unless asked.

The learner's current decks (id | name | cards | source):
${decksBlock}`;
}
