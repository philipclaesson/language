// Types shared between the Preact client and the Hono server.

export type SessionUser = {
  id: string;
  email: string;
  name: string;
};

export type MeResponse = {
  user: SessionUser;
};

// ---- Phase 2 (designed-in, not served yet) ----

export type SessionCard = {
  id: string;
  prompt: string;
  article: string | null;
  partOfSpeech: string | null;
  notes: string | null;
};

export type ReviewRequest = {
  cardId: string;
  typedAnswer: string;
  elapsedMs?: number;
};

export type ReviewResult = {
  correct: boolean;
  expected: string;
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
