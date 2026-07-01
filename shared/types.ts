// Types shared between the Preact client and the Hono server.

export type SessionUser = {
  id: string;
  email: string;
  name: string;
};

export type MeResponse = {
  user: SessionUser;
};

// ---- Phase 2 ----

// What the client sees before answering. Deliberately omits the German answer
// AND the article (the article reveals a noun's gender, which is the point).
export type SessionCard = {
  id: string;
  prompt: string;
  partOfSpeech: string | null;
};

export type ReviewRequest = {
  cardId: string;
  typedAnswer: string;
  elapsedMs?: number;
};

export type ReviewResult = {
  correct: boolean;
  expected: string; // full canonical answer, e.g. "der Hund"
  reason?: "missing_article" | "wrong";
  nextDue: string; // ISO timestamp
  // Whether this attempt drove the FSRS schedule. The first attempt of the day
  // on a card is graded; all later same-day attempts are training-only re-drills
  // (graded=false) and leave the schedule untouched. See PLAN.md §5a.
  graded: boolean;
  // True when the card still needs a correct typing today to be "done" (i.e. this
  // answer was wrong). The client keeps re-showing it until this is false.
  needsRedrill: boolean;
};

// ---- Daily loop (PLAN.md §5a) ----

// The day's required work. `cards` is what's still PENDING — cards not yet typed
// correctly today — so on refresh the client rebuilds its queue from here.
// Answer/article are omitted, same as SessionCard.
export type TodayResponse = {
  cards: SessionCard[];
  dueTotal: number; // due reviews required today
  newTotal: number; // new cards required today (<= NEW_PER_DAY)
  done: number; // required cards already typed correctly today
  pending: number; // required cards still needing a correct typing (= cards.length)
  complete: boolean; // pending === 0 — "done for today"
};

// Mastery tiers by FSRS stability. See PLAN.md §5a.
export type MasteryTier = "new" | "learning" | "familiar" | "mastered";

export type ProgressResponse = {
  tiers: Record<MasteryTier, number>; // count of the user's cards in each tier
  mastered: number; // = tiers.mastered, the headline number
  total: number; // total cards in the user's library
  reviewsToday: number; // graded reviews completed today
};

// Bonus work beyond the required set: more new cards, or practice of known cards.
export type ExtraType = "new" | "practice";
export type ExtraResponse = {
  cards: SessionCard[];
};

export type DeckCardState = "new" | "learning" | "review" | "relearning";

export type DeckSummary = {
  id: string;
  name: string;
  source: string;
  total: number;
  due: number; // cards currently due for review
  tiers: Record<MasteryTier, number>; // count of this deck's cards in each mastery tier
};

export type DeckCard = {
  id: string;
  prompt: string; // English
  answer: string; // bare German (compose with article for nouns)
  article: string | null;
  partOfSpeech: string | null;
  tier: MasteryTier; // stability-derived mastery tier (see PLAN.md §5a)
};

export type DeckDetail = {
  id: string;
  name: string;
  source: string;
  description: string | null;
  cards: DeckCard[];
};

// ---- Verbs mode (VERBS.md) ----

// The six present-tense slots. er = er/sie/es; sie = sie/Sie (plural + formal).
export type VerbForm = "ich" | "du" | "er" | "wir" | "ihr" | "sie";
export const VERB_FORMS: VerbForm[] = ["ich", "du", "er", "wir", "ihr", "sie"];
export const VERB_FORM_LABELS: Record<VerbForm, string> = {
  ich: "ich",
  du: "du",
  er: "er/sie/es",
  wir: "wir",
  ihr: "ihr",
  sie: "sie/Sie",
};

export type Conjugation = Record<VerbForm, string>;
export type VerbRegularity = "regular" | "irregular";

// What the client sees before answering. Deliberately omits the six forms — they
// are the answer (cf. SessionCard omitting the noun's article).
export type SessionVerb = {
  id: string;
  infinitive: string; // "gehen"
  english: string; // "to go"
  regularity: VerbRegularity;
};

export type VerbReviewRequest = {
  verbId: string;
  typed: Conjugation; // the six forms the user filled in
  elapsedMs?: number;
};

export type VerbReviewResult = {
  correct: boolean; // all six forms matched (all-or-nothing)
  expected: Conjugation; // full correct set, revealed on a miss
  perForm: Record<VerbForm, boolean>; // which rows were right (for highlighting)
  nextDue: string; // ISO timestamp
  graded: boolean; // first-attempt-of-day only drives FSRS (see §5a)
  needsRedrill: boolean; // true when this answer was wrong (still needs a correct typing today)
};

// The verb day's required work — mirrors TodayResponse. `verbs` is the still-PENDING
// set (verbs not yet conjugated correctly today), so a refresh rebuilds the queue.
export type VerbTodayResponse = {
  verbs: SessionVerb[];
  dueTotal: number;
  newTotal: number;
  done: number;
  pending: number;
  complete: boolean;
};

// Verb mastery reuses the same tier scheme as words.
export type VerbProgressResponse = ProgressResponse;

// One verb in the browse-all list, tagged with this user's mastery tier.
export type VerbListItem = {
  id: string;
  infinitive: string;
  english: string;
  regularity: VerbRegularity;
  tier: MasteryTier;
};

// ---- Phase 5: AI chat tutor ----

// One turn of the tutor conversation. The client holds the whole history (chats
// aren't persisted) and replays it on each request; the server is stateless.
export type ChatRole = "user" | "assistant";
export type ChatMessage = {
  role: ChatRole;
  content: string;
};

// A deck/card mutation the agent performed this turn, for the UI to surface
// (and to know it should refresh the deck list).
export type ChatAction = {
  kind: "deck_created" | "deck_renamed" | "deck_deleted" | "cards_added" | "card_edited" | "card_deleted";
  summary: string; // human-readable, e.g. "Created deck “Irregular verbs” (10 cards)"
};

export type ChatRequest = {
  messages: ChatMessage[];
};

export type ChatResponse = {
  reply: string;
  actions: ChatAction[];
};
