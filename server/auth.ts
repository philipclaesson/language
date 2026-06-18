import { Hono } from "hono";
import type { MiddlewareHandler } from "hono";
import { getCookie, setCookie, deleteCookie } from "hono/cookie";
import { sign, verify } from "hono/jwt";
import { Google, generateState, generateCodeVerifier } from "arctic";
import { env } from "./env";
import { db } from "./db/client";
import { users } from "./db/schema";
import type { SessionUser } from "../shared/types";

export type AppEnv = { Variables: { user: SessionUser } };

const redirectUri = `${env.baseUrl}/api/auth/callback`;
const google = new Google(env.googleClientId, env.googleClientSecret, redirectUri);

const SESSION_COOKIE = "session";
const SESSION_TTL = 60 * 60 * 24 * 30; // 30 days, in seconds

const baseCookie = {
  httpOnly: true,
  secure: env.isProd,
  sameSite: "Lax" as const,
  path: "/",
};

type GoogleClaims = {
  sub: string;
  email?: string;
  email_verified?: boolean;
  name?: string;
};

export const authRoutes = new Hono();

authRoutes.get("/login", (c) => {
  const state = generateState();
  const codeVerifier = generateCodeVerifier();
  const url = google.createAuthorizationURL(state, codeVerifier, [
    "openid",
    "profile",
    "email",
  ]);
  setCookie(c, "g_state", state, { ...baseCookie, maxAge: 600 });
  setCookie(c, "g_verifier", codeVerifier, { ...baseCookie, maxAge: 600 });
  return c.redirect(url.toString());
});

authRoutes.get("/callback", async (c) => {
  const code = c.req.query("code");
  const state = c.req.query("state");
  const storedState = getCookie(c, "g_state");
  const codeVerifier = getCookie(c, "g_verifier");

  if (!code || !state || !storedState || state !== storedState || !codeVerifier) {
    return c.text("Invalid authentication state. Please try again.", 400);
  }

  let claims: GoogleClaims;
  try {
    const tokens = await google.validateAuthorizationCode(code, codeVerifier);
    const res = await fetch("https://openidconnect.googleapis.com/v1/userinfo", {
      headers: { Authorization: `Bearer ${tokens.accessToken()}` },
    });
    if (!res.ok) throw new Error(`userinfo ${res.status}`);
    claims = (await res.json()) as GoogleClaims;
  } catch {
    return c.text("Authentication failed. Please try again.", 400);
  }

  const email = (claims.email ?? "").toLowerCase();
  if (!claims.email_verified || !env.allowedEmails.includes(email)) {
    return c.html(
      `<p>Sorry — <strong>${email || "this account"}</strong> is not on the allowlist.</p><p><a href="/">Back</a></p>`,
      403,
    );
  }

  const displayName = claims.name ?? null;
  const [user] = await db
    .insert(users)
    .values({ email, displayName })
    .onConflictDoUpdate({ target: users.email, set: { displayName } })
    .returning();

  const token = await sign(
    {
      sub: user.id,
      email: user.email,
      name: user.displayName ?? "",
      exp: Math.floor(Date.now() / 1000) + SESSION_TTL,
    },
    env.sessionSecret,
  );

  deleteCookie(c, "g_state", baseCookie);
  deleteCookie(c, "g_verifier", baseCookie);
  setCookie(c, SESSION_COOKIE, token, { ...baseCookie, maxAge: SESSION_TTL });
  return c.redirect("/");
});

authRoutes.post("/logout", (c) => {
  deleteCookie(c, SESSION_COOKIE, baseCookie);
  return c.json({ ok: true });
});

// Gate for /api routes: verifies the session cookie and attaches the user.
export const requireAuth: MiddlewareHandler<AppEnv> = async (c, next) => {
  const token = getCookie(c, SESSION_COOKIE);
  if (!token) return c.json({ error: "unauthenticated" }, 401);
  try {
    const payload = await verify(token, env.sessionSecret, "HS256");
    c.set("user", {
      id: String(payload.sub),
      email: String(payload.email),
      name: String(payload.name ?? ""),
    });
  } catch {
    return c.json({ error: "unauthenticated" }, 401);
  }
  await next();
};
