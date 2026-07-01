// The verb daily loop (VERBS.md). Same shape as srs/day.ts `planToday` — due
// reviews + introduced-today + fresh, a stable required total, drilled until
// correct — but new verbs are introduced with a fixed 3-irregular : 2-regular
// mix (leaning irregular; they matter more), in frequency order. The words
// planner is untouched; this reuses the day-boundary + progress helpers.

import { DAY_TZ, endOfDay, dayProgress, type CardToday } from "../srs/day";
import type { VerbRegularity } from "../../shared/types";

export const NEW_VERBS_PER_DAY = 5;
export const IRREGULAR_PER_DAY = 3;
export const REGULAR_PER_DAY = 2;

// One verb's daily-relevant facts (as `CardToday`) plus what drives new-verb
// selection. `frequencyRank` orders introduction; fresh verbs must be passable in
// any order — planVerbDay sorts them.
export type VerbToday = CardToday & {
  regularity: VerbRegularity;
  frequencyRank: number;
};

export type VerbDayPlan = {
  pendingIds: string[]; // required verbs not yet conjugated correctly today
  dueTotal: number;
  newTotal: number; // required new verbs today (introduced + freshly pulled)
  done: number;
  pending: number;
  complete: boolean;
};

/**
 * Choose which fresh verbs to introduce, up to `slots`, preferring
 * IRREGULAR_PER_DAY irregular then REGULAR_PER_DAY regular (both by frequency),
 * then spilling into whichever bucket still has verbs so we reach the daily quota
 * while any unstudied verbs remain. Pools must already be frequency-ordered.
 */
function pickFresh(irrPool: VerbToday[], regPool: VerbToday[], slots: number): VerbToday[] {
  if (slots <= 0) return [];
  const picked: VerbToday[] = [];
  let i = 0;
  let r = 0;

  const takeIrr = Math.min(IRREGULAR_PER_DAY, irrPool.length, slots);
  for (; i < takeIrr; i++) picked.push(irrPool[i]);

  const takeReg = Math.min(REGULAR_PER_DAY, regPool.length, slots - picked.length);
  for (; r < takeReg; r++) picked.push(regPool[r]);

  // Spill-over: fill any remaining slots, irregular first (keeps the lean).
  while (picked.length < slots && i < irrPool.length) picked.push(irrPool[i++]);
  while (picked.length < slots && r < regPool.length) picked.push(regPool[r++]);

  return picked;
}

/**
 * Build today's required verb set + progress. Pure: the route passes `now` and
 * per-verb facts. Mirrors `planToday`; only new-verb *selection* differs (the
 * 3:2 mix). The required total (due + new) is stable across the day.
 */
export function planVerbDay(
  verbs: VerbToday[],
  now: Date,
  opts: { tz?: string; limit?: number } = {},
): VerbDayPlan {
  const tz = opts.tz ?? DAY_TZ;
  const limit = opts.limit ?? NEW_VERBS_PER_DAY;
  const end = endOfDay(now, tz).getTime();

  const dueReq: VerbToday[] = [];
  const introduced: VerbToday[] = [];
  const fresh: VerbToday[] = [];

  for (const v of verbs) {
    if (!v.hasState && !v.reviewedToday) {
      fresh.push(v); // never studied, untouched today — quota candidate
      continue;
    }
    if (v.reviewedToday && !v.reviewedBeforeToday) {
      introduced.push(v); // first-ever attempt was today
      continue;
    }
    const isDue = v.due !== null && v.due.getTime() < end;
    if (isDue || v.reviewedToday) dueReq.push(v);
    // else: a studied verb not due and untouched today — not part of today.
  }

  const slotsLeft = Math.max(0, limit - introduced.length);
  fresh.sort((a, b) => a.frequencyRank - b.frequencyRank);
  const freshToPresent = pickFresh(
    fresh.filter((v) => v.regularity === "irregular"),
    fresh.filter((v) => v.regularity === "regular"),
    slotsLeft,
  );
  const newTotal = introduced.length + freshToPresent.length;

  const required = [...dueReq, ...introduced, ...freshToPresent];
  const correct = new Set(verbs.filter((v) => v.correctToday).map((v) => v.id));
  const { done, pending, complete } = dayProgress(
    required.map((v) => v.id),
    correct,
  );

  return {
    pendingIds: required.filter((v) => !correct.has(v.id)).map((v) => v.id),
    dueTotal: dueReq.length,
    newTotal,
    done,
    pending,
    complete,
  };
}
