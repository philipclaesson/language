import type {
  ArticleRoundResponse,
  ChatMessage,
  ChatRequest,
  ChatResponse,
  DeckDetail,
  DeckSummary,
  ExtraResponse,
  ExtraType,
  FreundMessage,
  FreundRequest,
  FreundResponse,
  FreundReviewRequest,
  FreundReviewResponse,
  FreundSaveRequest,
  FreundSaveResponse,
  FreundStartRequest,
  FreundStartResponse,
  FreundSuggestedCard,
  GameId,
  HighScoresResponse,
  MatchPairsResponse,
  MeResponse,
  ProgressResponse,
  PushConfigResponse,
  PushSubscriptionInput,
  ReviewRequest,
  ReviewResult,
  StatsResponse,
  TierHistoryResponse,
  SubmitScoreRequest,
  SubmitScoreResponse,
  TodayResponse,
  VerbExtraResponse,
  VerbListItem,
  VerbProgressResponse,
  VerbReviewRequest,
  VerbReviewResult,
  VerbTodayResponse,
} from "../../shared/types";

// Same-origin in prod; in dev Vite proxies /api to the Hono server.
async function api<T>(path: string, init?: RequestInit): Promise<T> {
  const res = await fetch(`/api${path}`, {
    credentials: "include",
    headers: init?.body ? { "Content-Type": "application/json" } : undefined,
    ...init,
  });
  if (!res.ok) throw Object.assign(new Error(`${path} -> ${res.status}`), { status: res.status });
  return res.json() as Promise<T>;
}

export function getMe() {
  return api<MeResponse>("/me");
}

export function logout() {
  return api<{ ok: boolean }>("/auth/logout", { method: "POST" });
}

export function getToday() {
  return api<TodayResponse>("/session/today");
}

export function getProgress() {
  return api<ProgressResponse>("/progress");
}

export function getStats() {
  return api<StatsResponse>("/stats");
}

export function getTierHistory() {
  return api<TierHistoryResponse>("/stats/history");
}

export function postReview(req: ReviewRequest) {
  return api<ReviewResult>("/reviews", { method: "POST", body: JSON.stringify(req) });
}

export function getExtra(type: ExtraType) {
  return api<ExtraResponse>(`/session/extra?type=${type}`);
}

export function getMatchPairs() {
  return api<MatchPairsResponse>("/session/pairs?type=misses");
}

export function getArticleRound() {
  return api<ArticleRoundResponse>("/games/article-mania/round");
}

export function getHighScores(game: GameId) {
  return api<HighScoresResponse>(`/games/scores?game=${game}`);
}

export function submitScore(game: GameId, score: number) {
  const req: SubmitScoreRequest = { game, score };
  return api<SubmitScoreResponse>("/games/scores", { method: "POST", body: JSON.stringify(req) });
}

export function getDecks() {
  return api<DeckSummary[]>("/decks");
}

export function getDeck(id: string) {
  return api<DeckDetail>(`/decks/${id}`);
}

export function getVerbToday() {
  return api<VerbTodayResponse>("/verbs/session/today");
}

export function getVerbProgress() {
  return api<VerbProgressResponse>("/verbs/progress");
}

export function getVerbList() {
  return api<VerbListItem[]>("/verbs/list");
}

export function postVerbReview(req: VerbReviewRequest) {
  return api<VerbReviewResult>("/verbs/reviews", { method: "POST", body: JSON.stringify(req) });
}

export function getVerbExtra(type: ExtraType) {
  return api<VerbExtraResponse>(`/verbs/session/extra?type=${type}`);
}

export function postChat(messages: ChatMessage[]) {
  const req: ChatRequest = { messages };
  return api<ChatResponse>("/chat", { method: "POST", body: JSON.stringify(req) });
}

export function postFreundStart(scenario?: string | null) {
  const req: FreundStartRequest = { scenario: scenario ?? null };
  return api<FreundStartResponse>("/freund/start", {
    method: "POST",
    body: JSON.stringify(req),
  });
}

export function postFreundMessage(messages: FreundMessage[], scenario: string | null) {
  const req: FreundRequest = { messages, scenario };
  return api<FreundResponse>("/freund/message", { method: "POST", body: JSON.stringify(req) });
}

export function postFreundReview(messages: FreundMessage[]) {
  const req: FreundReviewRequest = { messages };
  return api<FreundReviewResponse>("/freund/review", { method: "POST", body: JSON.stringify(req) });
}

export function postFreundCards(cards: FreundSuggestedCard[]) {
  const req: FreundSaveRequest = { cards };
  return api<FreundSaveResponse>("/freund/cards", { method: "POST", body: JSON.stringify(req) });
}

export function getPushConfig() {
  return api<PushConfigResponse>("/push/config");
}

export function subscribePush(sub: PushSubscriptionInput) {
  return api<{ ok: boolean }>("/push/subscribe", {
    method: "POST",
    body: JSON.stringify(sub),
  });
}

export function unsubscribePush(endpoint: string) {
  return api<{ ok: boolean }>("/push/unsubscribe", {
    method: "POST",
    body: JSON.stringify({ endpoint }),
  });
}
