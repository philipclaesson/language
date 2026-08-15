// Pure reminder-copy logic (no I/O) — unit-tested. The DB-touching "how much is
// due" lives in reminders.ts; this just turns those counts into a notification.

import type { PushPayload } from "./send";

// Cards + verbs still needing a correct answer today (the dashboard's "pending").
export type PendingToday = { words: number; verbs: number; total: number };

function count(n: number, singular: string): string {
  return `${n} ${n === 1 ? singular : singular + "s"}`;
}

/**
 * The reminder to send, or null when there's nothing due (we don't nag on an
 * empty day). Clicking the notification opens the relevant review loop.
 */
export function reminderMessage(pending: PendingToday): PushPayload | null {
  if (pending.total <= 0) return null;

  const parts: string[] = [];
  if (pending.words > 0) parts.push(count(pending.words, "word"));
  if (pending.verbs > 0) parts.push(count(pending.verbs, "verb"));

  return {
    title: "Zeit zum Üben! 🇩🇪",
    body: `${parts.join(" and ")} to review today.`,
    url: pending.words > 0 ? "/review" : "/verbs/review",
    tag: "daily-reminder",
  };
}

/**
 * The Freund nudge: an invitation into a specific role-play. `scenario` is one of the
 * server's SCENARIOS; the deep-link opens Freund straight into it (see freund.tsx).
 * Its own `tag` so it doesn't collapse with the review reminder. The caller only
 * sends this when the user hasn't chatted with Freund yet today.
 */
export function freundNudge(scenario: string): PushPayload {
  return {
    title: "Freund wartet auf dich 🗣️",
    body: `${scenario} Tap to jump in.`,
    url: `/freund?scenario=${encodeURIComponent(scenario)}`,
    tag: "freund-nudge",
  };
}
