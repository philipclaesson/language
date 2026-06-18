import type { MeResponse } from "../../shared/types";

// Same-origin in prod; in dev Vite proxies /api to the Hono server.
async function api<T>(path: string, init?: RequestInit): Promise<T> {
  const res = await fetch(`/api${path}`, { credentials: "include", ...init });
  if (!res.ok) throw Object.assign(new Error(`${path} -> ${res.status}`), { status: res.status });
  return res.json() as Promise<T>;
}

export function getMe() {
  return api<MeResponse>("/me");
}

export function logout() {
  return api<{ ok: boolean }>("/auth/logout", { method: "POST" });
}
