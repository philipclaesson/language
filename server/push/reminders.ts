// The DB-touching half of the daily reminder: how much a user has left to do
// today. It reuses the SAME helpers the /session/today and /verbs/session/today
// routes use, so "due today" can never drift between the dashboard and the
// reminder. The pure message formatting lives in message.ts (unit-tested).

import { startOfDay, planToday, type CardToday } from "../srs/day";
import { loadCardsWithState, todayReviewSets } from "../review-routes";
import { verbPlanFor } from "../verb-routes";
import type { PendingToday } from "./message";

export type { PendingToday } from "./message";

// Read this user's still-pending words and verbs for `now`. Read-only; mirrors the
// two session routes' data-loading + planning exactly (imported, not copied).
export async function pendingTodayFor(userId: string, now: Date): Promise<PendingToday> {
  const dayStart = startOfDay(now);

  const cardRows = await loadCardsWithState(userId);
  const cardSets = await todayReviewSets(userId, dayStart);
  const todayCards: CardToday[] = cardRows.map((r) => ({
    id: r.id,
    hasState: r.stateId !== null,
    due: r.due,
    reviewedToday: cardSets.reviewedToday.has(r.id),
    correctToday: cardSets.correctToday.has(r.id),
    reviewedBeforeToday: cardSets.reviewedBefore.has(r.id),
    stock: r.ownerId === null,
  }));
  const words = planToday(todayCards, now).pending;

  // Both tense streams, merged (present + past) — same helper the dashboard uses.
  const verbs = (await verbPlanFor(userId, now)).plan.pending;

  return { words, verbs, total: words + verbs };
}
