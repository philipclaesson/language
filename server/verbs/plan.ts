// The verb daily loop (VERBS.md). Same shape as srs/day.ts `planToday` — due
// reviews + introduced-today + fresh, a stable required total, drilled until
// correct — but new verbs are introduced with a fixed 3-irregular : 2-regular
// mix (leaning irregular; they matter more), in frequency order. The words
// planner is untouched; this reuses the day-boundary + progress helpers.

import {
  DAY_TZ,
  endOfDay,
  dayProgress,
  learningStackSize,
  type CardToday,
} from "../srs/day";
import type { VerbRegularity } from "../../shared/types";

export const NEW_VERBS_PER_DAY = 5;
export const IRREGULAR_PER_DAY = 3;
export const REGULAR_PER_DAY = 2;
// Past tense is a separate, independent stream (VERBS.md §7): its own daily quota,
// introduced in plain frequency order. No irregular/regular mix — the highest-
// frequency verbs (which take Präteritum) naturally come first.
export const NEW_PAST_PER_DAY = 5;

// The verb equivalent of `LEARNING_CAP` (srs/day.ts): how many verb *items* may be
// in flight (studied, still in the "learning" tier) before the daily intake of new
// verbs pauses. Counted across BOTH tense streams together — present and past are
// separate items but the same pile of work (VERBS.md §6a) — and gating both.
// "Pick 5 new verbs" still overrides it by hand.
export const VERB_LEARNING_CAP = 30;

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
  newPaused: boolean; // fresh verbs withheld — the learning stack is at the cap
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
  newPaused: boolean,
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
    newPaused,
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
  opts: { tz?: string; limit?: number; cap?: number; stack?: number } = {},
): VerbDayPlan {
  const tz = opts.tz ?? DAY_TZ;
  const limit = opts.limit ?? NEW_VERBS_PER_DAY;
  const { dueReq, introduced, fresh } = partitionDay(verbs, endOfDay(now, tz).getTime());

  const atCap = (opts.stack ?? learningStackSize(verbs)) >= (opts.cap ?? VERB_LEARNING_CAP);
  const slotsLeft = atCap ? 0 : Math.max(0, limit - introduced.length);
  const freshToPresent = pickFresh(
    fresh.filter((v) => v.regularity === "irregular"),
    fresh.filter((v) => v.regularity === "regular"),
    slotsLeft,
  );

  return finalize(verbs, dueReq, introduced, freshToPresent, atCap && fresh.length > 0);
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
  opts: { tz?: string; limit?: number; cap?: number; stack?: number } = {},
): VerbDayPlan {
  const tz = opts.tz ?? DAY_TZ;
  const limit = opts.limit ?? NEW_PAST_PER_DAY;
  const { dueReq, introduced, fresh } = partitionDay(verbs, endOfDay(now, tz).getTime());

  const atCap = (opts.stack ?? learningStackSize(verbs)) >= (opts.cap ?? VERB_LEARNING_CAP);
  const slotsLeft = atCap ? 0 : Math.max(0, limit - introduced.length);
  const freshToPresent = fresh.slice(0, slotsLeft);

  return finalize(verbs, dueReq, introduced, freshToPresent, atCap && fresh.length > 0);
}

/** Sum two stream plans into one (present + past). Complete only when both are. */
export function mergeVerbPlans(a: VerbDayPlan, b: VerbDayPlan): VerbDayPlan {
  return {
    pendingIds: [...a.pendingIds, ...b.pendingIds],
    dueTotal: a.dueTotal + b.dueTotal,
    newTotal: a.newTotal + b.newTotal,
    newPaused: a.newPaused || b.newPaused,
    done: a.done + b.done,
    pending: a.pending + b.pending,
    complete: a.complete && b.complete,
  };
}

/**
 * Today's whole verb day: both tense streams planned and merged. The learning
 * stack is sized ONCE over present + past together and handed to both planners, so
 * the cap throttles the two streams as one pile of work rather than 30 items each.
 */
export function planVerbsToday(
  present: VerbToday[],
  past: VerbToday[],
  now: Date,
  opts: { tz?: string; cap?: number } = {},
): VerbDayPlan {
  const stack = learningStackSize([...present, ...past]);
  const streamOpts = { ...opts, stack };
  return mergeVerbPlans(
    planVerbDay(present, now, streamOpts),
    planPastVerbDay(past, now, streamOpts),
  );
}
