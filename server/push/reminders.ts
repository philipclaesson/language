// The DB-touching half of the daily reminder: how much a user has left to do
// today. It reuses the SAME helpers the /session/today and /verbs/session/today
// routes use, so "due today" can never drift between the dashboard and the
// reminder. The pure message formatting lives in message.ts (unit-tested).

import { startOfDay, planToday, type CardToday } from "../srs/day";
import { planVerbDay, type VerbToday } from "../verbs/plan";
import { loadCardsWithState, todayReviewSets } from "../review-routes";
import { loadVerbsWithState, todayVerbReviewSets } from "../verb-routes";
import type { VerbRegularity } from "../../shared/types";
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

  const verbRows = await loadVerbsWithState(userId);
  const verbSets = await todayVerbReviewSets(userId, dayStart);
  const todayVerbs: VerbToday[] = verbRows.map((r) => ({
    id: r.id,
    regularity: r.regularity as VerbRegularity,
    frequencyRank: r.frequencyRank,
    hasState: r.stateId !== null,
    due: r.due,
    reviewedToday: verbSets.reviewedToday.has(r.id),
    correctToday: verbSets.correctToday.has(r.id),
    reviewedBeforeToday: verbSets.reviewedBefore.has(r.id),
  }));
  const verbs = planVerbDay(todayVerbs, now).pending;

  return { words, verbs, total: words + verbs };
}
