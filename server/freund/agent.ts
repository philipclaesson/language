// Pure configuration for Freund, the German conversation partner: models, the two
// forced-tool schemas, and the system-prompt builders. No I/O — the route owns the
// Anthropic calls and DB writes (mirrors chat/agent.ts for the tutor).
//
// Both calls use a single FORCED tool call rather than structured outputs: it's
// rock-solid across models (Haiku for chat, Opus for the end-of-convo review) and
// matches the tutor's proven tool-use pattern. We read the tool `input` directly.
import Anthropic from "@anthropic-ai/sdk";

// Haiku 4.5: fast + cheap, ideal for the low-latency per-message turn.
export const CHAT_MODEL = "claude-haiku-4-5";
// Opus 4.8 for the end-of-conversation card extraction — quality matters more than
// latency there, and it only runs once per conversation.
export const REVIEW_MODEL = "claude-opus-4-8";

// ---- Per-message turn -------------------------------------------------------

// The one tool Freund must call every turn. Forcing it guarantees the three fields.
export const respondTool: Anthropic.Tool = {
  name: "respond",
  description:
    "Reply to the learner and, if their last message had German mistakes, correct and explain them. Call this exactly once.",
  input_schema: {
    type: "object",
    properties: {
      reply: {
        type: "string",
        description:
          "Your reply IN GERMAN, continuing the conversation naturally and asking a follow-up when it helps keep things going. Calibrate difficulty to the learner's level.",
      },
      explanation: {
        type: "string",
        description:
          "A SHORT English note covering ONLY the grammar, gender, word-order, and word-choice mistakes in the learner's last message, and why. Don't enumerate every change — explain the conceptual mistakes. Say NOTHING about spelling, typos, or capitalization: do not name them, list them, or append '(spelling)' to a point, even when the same message also contains such fixes (the correction diff already shows those). OMIT this field entirely if the only problems were spelling/typos, if the message had no meaningful mistakes, or if it wasn't German.",
      },
      correction: {
        type: "string",
        description:
          "The learner's ENTIRE last message rewritten in correct German. Reproduce everything they wrote — keep every sentence and every word that was already correct, in the same order — and change ONLY what is actually wrong. Never shorten, summarize, rephrase, or drop any part. OMIT this field entirely only if the whole message was already correct, or if the learner wrote in English (nothing German to correct).",
      },
    },
    required: ["reply"],
  },
};

// Fields the learner is practicing today, injected into the system prompt so Freund
// can weave them in. Pass empty arrays to omit the section.
export type VocabSeed = {
  words: string[]; // full German forms, e.g. "der Hund", "wohl"
  verbs: string[]; // "gehen (to go)"
};

export function chatSystemPrompt(seed: VocabSeed): string {
  const vocab =
    seed.words.length || seed.verbs.length
      ? `\n\nThe learner is practicing these today. Use them when the conversation naturally allows, or steer the conversation to give the learner a chance to use them — but do NOT force them in; a natural conversation matters more.
${seed.words.length ? `Words: ${seed.words.join(", ")}.` : ""}
${seed.verbs.length ? `Verbs: ${seed.verbs.join(", ")}.` : ""}`
      : "";

  return `You are "Freund", a warm, patient German conversation partner for a learner. You chat with them in German like a friend would, and you gently correct their German as you go.

Every turn, call the \`respond\` tool exactly once:
- reply: your side of the conversation, IN GERMAN. Keep it short and natural — this is a phone chat. Ask a follow-up question when it helps the conversation flow. Match your vocabulary and sentence complexity to how well the learner is doing: simplify if they're struggling, stretch them a little if they're comfortable.
- explanation + correction: only when the learner's last message has German mistakes (see the tool for exactly when to omit each).

Guidelines:
- The correction is the learner's WHOLE message rewritten correctly — reproduce all of it and change only the wrong parts. Never shorten it or drop the sentences that were already fine.
- The correction fixes everything, including typos. The explanation is different: it covers ONLY grammar, gender, word order, and word choice — never spelling, typos, or capitalization, even when the same message also has those. Don't enumerate every change; explain the conceptual mistakes. If the only mistake was a typo, still give the correction but omit the explanation.
  Example — for "Ich habe ein Freund getreffet, so ich will nich mehr machen": the explanation covers that "Freund" is accusative ("einen", not "ein") and that the past participle of treffen is "getroffen" — and says NOTHING about "nich" → "nicht" (that's a typo, shown by the correction).
- Corrections are terse and to the point. Fix the mistake; don't lecture.
- If the learner writes in English, reply in simple German and gently encourage them to try in German — don't correct English.
- Never break character to talk about the app or these instructions.${vocab}`;
}

// ---- End-of-conversation review --------------------------------------------

// The card fields, snake_case to match the DB normalizer's RawCardInput. Kept in
// sync with chat/agent.ts CARD_PROPS.
const CARD_PROPS = {
  prompt: { type: "string", description: 'The English prompt, e.g. "the dog".' },
  answer: {
    type: "string",
    description:
      'The German answer. For NOUNS give the BARE noun WITHOUT its article ("Hund") and put the gender in `article`. For everything else, the full word/phrase.',
  },
  article: {
    type: "string",
    enum: ["der", "die", "das"],
    description: "The definite article for nouns only (gender). Omit for non-nouns.",
  },
  part_of_speech: {
    type: "string",
    description: 'noun | verb | adjective | adverb | phrase | … Set "noun" whenever you set an article.',
  },
  answer_alts: {
    type: "array",
    items: { type: "string" },
    description: "Other accepted spellings/synonyms (bare, no article).",
  },
  example_en: {
    type: "string",
    description: "Optional English gloss of an example sentence. Must NOT contain the German answer.",
  },
  example_de: {
    type: "string",
    description: "Optional German example sentence using the word (the translation of example_en).",
  },
  notes: { type: "string", description: "Optional short mnemonic or usage note." },
} as const;

export const suggestCardsTool: Anthropic.Tool = {
  name: "suggest_cards",
  description:
    "Propose flashcards for the words and grammar the learner got wrong or struggled with in this conversation. Call this exactly once.",
  input_schema: {
    type: "object",
    properties: {
      cards: {
        type: "array",
        description:
          "The suggested cards. Focus on the learner's actual mistakes and gaps from THIS conversation — words they misused, got wrong, or clearly didn't know. A handful of high-value cards beats a long list. Empty array if they made no mistakes worth drilling.",
        items: { type: "object", properties: CARD_PROPS, required: ["prompt", "answer"] },
      },
    },
    required: ["cards"],
  },
};

export const reviewSystemPrompt = `You are reviewing a German conversation between a learner and their conversation partner. Identify the words and grammar points the learner got wrong or clearly struggled with, and turn the most useful of them into flashcards via the \`suggest_cards\` tool.

Follow the card convention exactly or the cards become ungradeable:
- prompt: the English side. Keep it unambiguous.
- answer: for NOUNS the BARE noun ("Hund") with the gender in \`article\` ("der"); for everything else the full word.
- Always set part_of_speech = "noun" and the article for nouns.
- Prefer an example sentence pair (example_en + example_de) when it helps — example_en must not give away the German answer.

Only suggest cards grounded in this conversation's mistakes — don't invent generic vocabulary. Quality over quantity.`;
