import type {
  MeResponse,
  ReviewRequest,
  ReviewResult,
  SessionResponse,
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

export function getSession() {
  return api<SessionResponse>("/session/next");
}

export function postReview(req: ReviewRequest) {
  return api<ReviewResult>("/reviews", { method: "POST", body: JSON.stringify(req) });
}
