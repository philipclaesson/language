// Client side of Web Push: register the service worker, subscribe/unsubscribe via
// the PushManager, and sync the subscription with the server. The UI (app.tsx's
// ReminderToggle) drives these; the server contract is in shared/types.ts.

import { getPushConfig, subscribePush, unsubscribePush } from "./api";

export type PushState =
  | "unsupported" // this browser can't do Web Push (e.g. iOS Safari tab — see needsInstall)
  | "denied" // the user blocked notifications
  | "off" // supported, not subscribed
  | "on"; // subscribed

export function pushSupported(): boolean {
  return (
    "serviceWorker" in navigator &&
    "PushManager" in window &&
    "Notification" in window
  );
}

function isIos(): boolean {
  return /iphone|ipad|ipod/i.test(navigator.userAgent);
}

function isStandalone(): boolean {
  return (
    window.matchMedia?.("(display-mode: standalone)").matches ||
    // Safari-specific flag for a home-screen web app.
    (navigator as unknown as { standalone?: boolean }).standalone === true
  );
}

// On iPhone/iPad, Web Push only works once the app is added to the Home Screen —
// the toggle should show install guidance rather than a dead switch.
export function needsInstall(): boolean {
  return isIos() && !isStandalone() && !pushSupported();
}

// VAPID keys are base64url; PushManager wants a Uint8Array. Backed by an explicit
// ArrayBuffer so the type is a plain BufferSource (not ArrayBufferLike).
function urlBase64ToUint8Array(base64: string): Uint8Array<ArrayBuffer> {
  const padding = "=".repeat((4 - (base64.length % 4)) % 4);
  const b64 = (base64 + padding).replace(/-/g, "+").replace(/_/g, "/");
  const raw = atob(b64);
  const arr = new Uint8Array(new ArrayBuffer(raw.length));
  for (let i = 0; i < raw.length; i++) arr[i] = raw.charCodeAt(i);
  return arr;
}

// Current on/off state without prompting for permission.
export async function currentPushState(): Promise<PushState> {
  if (!pushSupported()) return "unsupported";
  if (Notification.permission === "denied") return "denied";
  const reg = await navigator.serviceWorker.getRegistration();
  const sub = reg ? await reg.pushManager.getSubscription() : null;
  return sub ? "on" : "off";
}

// Ask permission, subscribe, and register the subscription with the server.
export async function enablePush(): Promise<PushState> {
  if (!pushSupported()) return "unsupported";

  const config = await getPushConfig();
  if (!config.enabled || !config.publicKey) return "unsupported";

  const permission = await Notification.requestPermission();
  if (permission !== "granted") {
    return permission === "denied" ? "denied" : "off";
  }

  const reg = await navigator.serviceWorker.register("/sw.js");
  await navigator.serviceWorker.ready;

  const sub =
    (await reg.pushManager.getSubscription()) ??
    (await reg.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: urlBase64ToUint8Array(config.publicKey),
    }));

  const json = sub.toJSON();
  if (!json.endpoint || !json.keys?.p256dh || !json.keys?.auth) {
    return "off";
  }
  await subscribePush({
    endpoint: json.endpoint,
    keys: { p256dh: json.keys.p256dh, auth: json.keys.auth },
  });
  return "on";
}

// Unsubscribe locally and tell the server to drop the row.
export async function disablePush(): Promise<PushState> {
  const reg = await navigator.serviceWorker.getRegistration();
  const sub = reg ? await reg.pushManager.getSubscription() : null;
  if (sub) {
    await unsubscribePush(sub.endpoint).catch(() => {});
    await sub.unsubscribe().catch(() => {});
  }
  return "off";
}
