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

export type SessionResponse = {
  cards: SessionCard[];
  dueCount: number;
  newCount: number;
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
};

export type DeckSummary = {
  id: string;
  name: string;
  source: string;
  dueCount: number;
  newCount: number;
  totalCount: number;
};
