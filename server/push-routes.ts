import { Hono } from "hono";
import { timingSafeEqual } from "node:crypto";
import { eq } from "drizzle-orm";
import { db } from "./db/client";
import { pushSubscriptions } from "./db/schema";
import { requireAuth, type AppEnv } from "./auth";
import { env } from "./env";
import { pushEnabled, sendPush } from "./push/send";
import { pendingTodayFor } from "./push/reminders";
import { freundCountToday } from "./db/daily-progress";
import { SCENARIOS } from "./freund/agent";
import { freundNudge, reminderMessage } from "./push/message";
import type { PushConfigResponse, PushSubscriptionInput } from "../shared/types";

// Web Push for the daily training reminder. Additive module (cf. the AI-module
// pattern in CLAUDE.md): the review core is untouched — this only reads today's
// pending counts (via the session helpers) and stores browser subscriptions.
//
// Three of the four routes are cookie-authed (the user managing their own subs);
// /push/send-reminders is called by the GitHub Actions cron with a shared secret,
// so it authenticates with CRON_SECRET instead of a session.
export const pushRoutes = new Hono<AppEnv>();

// Whether the client should offer the reminder toggle, plus the VAPID public key
// the browser needs to build a subscription.
pushRoutes.get("/push/config", requireAuth, (c) => {
  const body: PushConfigResponse = {
    enabled: pushEnabled(),
    publicKey: pushEnabled() ? env.vapidPublicKey! : null,
  };
  return c.json(body);
});

// Store (or refresh) this browser's subscription. `endpoint` is unique, so a
// re-subscribe on the same device updates the keys / owner in place.
pushRoutes.post("/push/subscribe", requireAuth, async (c) => {
  const userId = c.get("user").id;
  const sub = (await c.req.json()) as PushSubscriptionInput;
  if (!sub?.endpoint || !sub.keys?.p256dh || !sub.keys?.auth) {
    return c.json({ error: "invalid subscription" }, 400);
  }

  await db
    .insert(pushSubscriptions)
    .values({
      userId,
      endpoint: sub.endpoint,
      p256dh: sub.keys.p256dh,
      auth: sub.keys.auth,
    })
    .onConflictDoUpdate({
      target: pushSubscriptions.endpoint,
      set: { userId, p256dh: sub.keys.p256dh, auth: sub.keys.auth },
    });

  return c.json({ ok: true });
});

// Drop this browser's subscription (user toggled reminders off).
pushRoutes.post("/push/unsubscribe", requireAuth, async (c) => {
  const { endpoint } = (await c.req.json()) as { endpoint?: string };
  if (endpoint) {
    await db.delete(pushSubscriptions).where(eq(pushSubscriptions.endpoint, endpoint));
  }
  return c.json({ ok: true });
});

// Constant-time secret check (avoids leaking length/timing). Both must be set.
function cronAuthorized(header: string | undefined): boolean {
  if (!env.cronSecret || !header) return false;
  const presented = header.replace(/^Bearer\s+/i, "");
  const a = Buffer.from(presented);
  const b = Buffer.from(env.cronSecret);
  return a.length === b.length && timingSafeEqual(a, b);
}

// All stored subscriptions grouped by user, so a per-user payload is computed once
// and fanned out to that user's devices. Shared by the two cron endpoints below.
async function subsByUser() {
  const subs = await db
    .select({
      userId: pushSubscriptions.userId,
      endpoint: pushSubscriptions.endpoint,
      p256dh: pushSubscriptions.p256dh,
      auth: pushSubscriptions.auth,
    })
    .from(pushSubscriptions);

  const byUser = new Map<string, typeof subs>();
  for (const s of subs) {
    const list = byUser.get(s.userId) ?? [];
    list.push(s);
    byUser.set(s.userId, list);
  }
  return byUser;
}

// Drop subscriptions the push service reported as gone (404/410).
async function pruneEndpoints(endpoints: string[]) {
  for (const endpoint of endpoints) {
    await db.delete(pushSubscriptions).where(eq(pushSubscriptions.endpoint, endpoint));
  }
}

// Called once a day by the reminders GitHub Actions workflow. For every user with
// at least one subscription, send a push IF they still have cards/verbs due today
// (no nag on an empty day). Prunes subscriptions the push service reports as gone.
pushRoutes.post("/push/send-reminders", async (c) => {
  if (!pushEnabled()) return c.json({ error: "push not configured" }, 503);
  if (!cronAuthorized(c.req.header("authorization"))) {
    return c.json({ error: "unauthorized" }, 401);
  }

  const byUser = await subsByUser();
  const now = new Date();
  let sent = 0;
  let skipped = 0;
  const pruned: string[] = [];

  for (const [userId, userSubs] of byUser) {
    const payload = reminderMessage(await pendingTodayFor(userId, now));
    if (!payload) {
      skipped++;
      continue;
    }
    for (const s of userSubs) {
      const outcome = await sendPush(s, payload);
      if (outcome === "sent") sent++;
      else if (outcome === "gone") pruned.push(s.endpoint);
    }
  }

  await pruneEndpoints(pruned);
  return c.json({ users: byUser.size, sent, skippedUsers: skipped, pruned: pruned.length });
});

// Called once a day (earlier than the review reminder) by the freund-nudge workflow.
// Nudges each subscribed user into a role-play IFF they haven't chatted with Freund
// yet today — so it never fires once you've done your daily conversation. Each user
// gets a random scenario; clicking deep-links straight into it (see freund.tsx).
pushRoutes.post("/push/send-freund-nudge", async (c) => {
  if (!pushEnabled()) return c.json({ error: "push not configured" }, 503);
  if (!cronAuthorized(c.req.header("authorization"))) {
    return c.json({ error: "unauthorized" }, 401);
  }

  const byUser = await subsByUser();
  const now = new Date();
  let sent = 0;
  let skipped = 0;
  const pruned: string[] = [];

  for (const [userId, userSubs] of byUser) {
    if ((await freundCountToday(userId, now)) > 0) {
      skipped++; // already chatted today — no nudge
      continue;
    }
    const scenario = SCENARIOS[Math.floor(Math.random() * SCENARIOS.length)];
    const payload = freundNudge(scenario);
    for (const s of userSubs) {
      const outcome = await sendPush(s, payload);
      if (outcome === "sent") sent++;
      else if (outcome === "gone") pruned.push(s.endpoint);
    }
  }

  await pruneEndpoints(pruned);
  return c.json({ users: byUser.size, sent, skippedUsers: skipped, pruned: pruned.length });
});
