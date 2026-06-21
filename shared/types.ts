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
  newCount: number; // not yet studied
  learning: number; // in learning/relearning
  known: number; // graduated to 'review' state — "mastered"
};

export type DeckCard = {
  id: string;
  prompt: string; // English
  answer: string; // bare German (compose with article for nouns)
  article: string | null;
  partOfSpeech: string | null;
  state: DeckCardState;
};

export type DeckDetail = {
  id: string;
  name: string;
  source: string;
  description: string | null;
  cards: DeckCard[];
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
