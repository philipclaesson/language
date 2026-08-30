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
// Past tense is a separate, independent stream (VERBS.md §7): its own daily quota,
// introduced in plain frequency order. No irregular/regular mix — the highest-
// frequency verbs (which take Präteritum) naturally come first.
export const NEW_PAST_PER_DAY = 5;

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

// Split today's candidates into the three buckets shared by both streams: due
// reviews, verbs introduced today, and never-studied "fresh" verbs (frequency-
// ordered). Identical to `planToday`'s bucketing.
function partitionDay(verbs: VerbToday[], end: number) {
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

  fresh.sort((a, b) => a.frequencyRank - b.frequencyRank);
  return { dueReq, introduced, fresh };
}

// Assemble the required set (due + introduced + freshly-pulled) into a VerbDayPlan.
function finalize(
  allVerbs: VerbToday[],
  dueReq: VerbToday[],
  introduced: VerbToday[],
  freshToPresent: VerbToday[],
): VerbDayPlan {
  const required = [...dueReq, ...introduced, ...freshToPresent];
  const correct = new Set(allVerbs.filter((v) => v.correctToday).map((v) => v.id));
  const { done, pending, complete } = dayProgress(
    required.map((v) => v.id),
    correct,
  );
  return {
    pendingIds: required.filter((v) => !correct.has(v.id)).map((v) => v.id),
    dueTotal: dueReq.length,
    newTotal: introduced.length + freshToPresent.length,
    done,
    pending,
    complete,
  };
}

/**
 * Build today's required PRESENT-tense verb set + progress. Pure: the route passes
 * `now` and per-verb facts. Mirrors `planToday`; only new-verb *selection* differs
 * (the 3-irregular : 2-regular mix). The required total (due + new) is stable
 * across the day.
 */
export function planVerbDay(
  verbs: VerbToday[],
  now: Date,
  opts: { tz?: string; limit?: number } = {},
): VerbDayPlan {
  const tz = opts.tz ?? DAY_TZ;
  const limit = opts.limit ?? NEW_VERBS_PER_DAY;
  const { dueReq, introduced, fresh } = partitionDay(verbs, endOfDay(now, tz).getTime());

  const slotsLeft = Math.max(0, limit - introduced.length);
  const freshToPresent = pickFresh(
    fresh.filter((v) => v.regularity === "irregular"),
    fresh.filter((v) => v.regularity === "regular"),
    slotsLeft,
  );

  return finalize(verbs, dueReq, introduced, freshToPresent);
}

/**
 * Build today's required PAST-tense set + progress. Same buckets as `planVerbDay`,
 * but fresh past cards are introduced in plain frequency order (no regularity mix)
 * up to `NEW_PAST_PER_DAY`. Present and past are independent streams (VERBS.md §7):
 * a verb's past card can appear before/after its present card.
 */
export function planPastVerbDay(
  verbs: VerbToday[],
  now: Date,
  opts: { tz?: string; limit?: number } = {},
): VerbDayPlan {
  const tz = opts.tz ?? DAY_TZ;
  const limit = opts.limit ?? NEW_PAST_PER_DAY;
  const { dueReq, introduced, fresh } = partitionDay(verbs, endOfDay(now, tz).getTime());

  const slotsLeft = Math.max(0, limit - introduced.length);
  const freshToPresent = fresh.slice(0, slotsLeft);

  return finalize(verbs, dueReq, introduced, freshToPresent);
}

/** Sum two stream plans into one (present + past). Complete only when both are. */
export function mergeVerbPlans(a: VerbDayPlan, b: VerbDayPlan): VerbDayPlan {
  return {
    pendingIds: [...a.pendingIds, ...b.pendingIds],
    dueTotal: a.dueTotal + b.dueTotal,
    newTotal: a.newTotal + b.newTotal,
    done: a.done + b.done,
    pending: a.pending + b.pending,
    complete: a.complete && b.complete,
  };
}
