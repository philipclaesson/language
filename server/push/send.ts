// Thin wrapper around `web-push`: configure VAPID once, send one notification,
// and classify the outcome so the caller can prune dead subscriptions. Kept
// separate from the route glue (cf. chat/cards.ts) — the reminder logic and the
// route both send through here.

// web-push is CommonJS — default-import the whole module (named ESM imports fail
// at runtime under Node's CJS interop, even though the type stubs allow them).
import webpush from "web-push";
import type { PushSubscription } from "web-push";
import { env } from "../env";

// Push is only available when a VAPID pair is configured (see env.ts). Local dev /
// CI run without it; the routes report `enabled: false` and skip sending.
export function pushEnabled(): boolean {
  return Boolean(env.vapidPublicKey && env.vapidPrivateKey);
}

let configured = false;
function ensureConfigured() {
  if (configured) return;
  webpush.setVapidDetails(env.vapidSubject, env.vapidPublicKey!, env.vapidPrivateKey!);
  configured = true;
}

// What the service worker's `push` handler reads (see web/public/sw.js).
export type PushPayload = { title: string; body: string; url?: string };

export type StoredSubscription = { endpoint: string; p256dh: string; auth: string };

// "sent" — delivered to the push service; "gone" — the subscription is dead
// (404/410), the caller should delete it; "error" — a transient/other failure.
export type SendOutcome = "sent" | "gone" | "error";

export async function sendPush(
  sub: StoredSubscription,
  payload: PushPayload,
): Promise<SendOutcome> {
  if (!pushEnabled()) return "error";
  ensureConfigured();

  const subscription: PushSubscription = {
    endpoint: sub.endpoint,
    keys: { p256dh: sub.p256dh, auth: sub.auth },
  };

  try {
    await webpush.sendNotification(subscription, JSON.stringify(payload));
    return "sent";
  } catch (e) {
    if (e instanceof webpush.WebPushError && (e.statusCode === 404 || e.statusCode === 410)) {
      return "gone";
    }
    console.error("push send failed", e);
    return "error";
  }
}
