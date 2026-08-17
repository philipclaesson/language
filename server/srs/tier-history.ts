// Mastery-over-time, reconstructed from the append-only review log (PLAN.md §5a;
// nothing is stored). Pure — the route reads the log and passes it in.
//
// The whole thing rests on one property: a card's `stability` — and therefore its
// mastery tier (srs/tiers.ts) — changes ONLY when the card is reviewed. Tiers key
// off stability, which FSRS updates at review time; they do NOT track the decaying
// `due`/retrievability. So replaying a card's graded reviews through the scheduler
// yields its complete tier timeline: between reviews the tier is flat. Windowing the
// *output* to the last N days doesn't let us read less of the log — a card mastered
// months ago still stands today — but the replay is cheap, so we replay everything
// and only emit the visible tail.

import type { Grade, TierHistoryPoint } from "../../shared/types";
import { scheduleNext, type StoredSrs } from "./scheduler";
import { tierFor } from "./tiers";
import { DAY_TZ } from "./day";
import { addDays, localDateString } from "./stats";

// One graded attempt from the log. `rating` is FSRS's 1/2/3 (fail/near/pass, as
// written by srs/scheduler.ts `ratingFor`); `reviewedAt` is the real instant, so the
// replay sees the same elapsed intervals the live scheduler did.
export type ReplayReview = { rating: number; reviewedAt: Date };

// Invert reviews.rating back to our Grade vocabulary to drive scheduleNext. Rows
// predating near misses are only 1 or 3; anything unexpected is treated as a pass
// (the lenient reading — it only ever nudges stability up).
const GRADE_BY_RATING: Record<number, Grade> = { 1: "fail", 2: "near", 3: "pass" };

// Replay one entity's (card or verb) graded reviews, returning its stability at the
// end of each local day it was reviewed, oldest first. At most one graded review per
// entity per day exists in practice (graded = first-of-day); if two ever share a
// local day, the later one's stability is what stands at day's end.
function stepsFor(reviews: ReplayReview[]): { day: string; stability: number }[] {
  const sorted = [...reviews].sort((a, b) => a.reviewedAt.getTime() - b.reviewedAt.getTime());
  let srs: StoredSrs | null = null;
  const byDay = new Map<string, number>();
  for (const r of sorted) {
    srs = scheduleNext(srs, GRADE_BY_RATING[r.rating] ?? "pass", r.reviewedAt);
    byDay.set(localDateString(r.reviewedAt, DAY_TZ), srs.stability);
  }
  return [...byDay.entries()]
    .map(([day, stability]) => ({ day, stability }))
    .sort((a, b) => (a.day < b.day ? -1 : 1));
}

// Standing stability at the end of `day`: the latest step on or before it, or null if
// the entity hadn't been reviewed yet (→ tier "new", which the chart omits).
function stabilityOnDay(steps: { day: string; stability: number }[], day: string): number | null {
  let stability: number | null = null;
  for (const s of steps) {
    if (s.day <= day) stability = s.stability;
    else break;
  }
  return stability;
}

/**
 * Per-day tier counts over the last `days` calendar days ending `today`, oldest
 * first. `entities` is one review array per card/verb (words + verbs merged — the
 * chart shows the whole library, like the mastery bar). The final point's counts
 * match the live mastery bar, since both derive from the same FSRS stabilities.
 */
export function tierHistory(
  entities: ReplayReview[][],
  today: string,
  days = 30,
): TierHistoryPoint[] {
  const allSteps = entities.map(stepsFor);
  const points: TierHistoryPoint[] = [];
  for (let i = days - 1; i >= 0; i--) {
    const date = addDays(today, -i);
    let learning = 0;
    let familiar = 0;
    let mastered = 0;
    for (const steps of allSteps) {
      const s = stabilityOnDay(steps, date);
      if (s === null) continue; // never studied by this day → "new", not charted
      const tier = tierFor(s);
      if (tier === "learning") learning++;
      else if (tier === "familiar") familiar++;
      else if (tier === "mastered") mastered++;
    }
    points.push({ date, learning, familiar, mastered });
  }
  return points;
}
