// Stats derivations, as pure functions (motivation only — nothing is stored; the
// route supplies day-bucketed activity counts and today's local date). Days are
// identified by their local calendar date string "YYYY-MM-DD" (bucketed in DAY_TZ
// by the SQL query). Calendar-date arithmetic is done in UTC so it's DST-proof:
// a date string carries no time, and UTC has no DST to skew day counting.

import type { HeatmapCell } from "../../shared/types";

/** The local calendar date ("YYYY-MM-DD") of an instant in `tz`. */
export function localDateString(now: Date, tz: string): string {
  // en-CA formats as YYYY-MM-DD.
  return new Intl.DateTimeFormat("en-CA", { timeZone: tz }).format(now);
}

/** Shift a "YYYY-MM-DD" date string by `n` calendar days (UTC math, DST-proof). */
export function addDays(date: string, n: number): string {
  const [y, m, d] = date.split("-").map(Number);
  return new Date(Date.UTC(y, m - 1, d + n)).toISOString().slice(0, 10);
}

/** ISO weekday of a date string: Monday = 0 … Sunday = 6. */
export function mondayIndex(date: string): number {
  const [y, m, d] = date.split("-").map(Number);
  return (new Date(Date.UTC(y, m - 1, d)).getUTCDay() + 6) % 7;
}

/**
 * Current + longest streak from the set of active days (days with >0 activity).
 * Current streak counts consecutive active days ending today; if today isn't
 * active yet it falls back to a run ending yesterday (so the streak doesn't read 0
 * just because you haven't practiced yet today). Longest is the best run ever.
 */
export function computeStreaks(
  active: Set<string>,
  today: string,
): { current: number; longest: number } {
  // Current: walk back from today (or yesterday if today is still empty).
  let cursor = active.has(today) ? today : addDays(today, -1);
  let current = 0;
  while (active.has(cursor)) {
    current++;
    cursor = addDays(cursor, -1);
  }

  // Longest: sort the active days and measure the longest consecutive run.
  const days = [...active].sort();
  let longest = 0;
  let run = 0;
  let prev: string | null = null;
  for (const day of days) {
    run = prev !== null && addDays(prev, 1) === day ? run + 1 : 1;
    if (run > longest) longest = run;
    prev = day;
  }

  return { current, longest };
}

/**
 * Intensity thresholds (three cut points → four non-empty levels) derived from the
 * user's own daily counts, so the ramp self-calibrates instead of pinning to the
 * darkest shade once volume routinely clears fixed thresholds. Quartiles of the
 * non-zero counts; degenerate inputs (no data, or one distinct value) collapse to a
 * mid-scale so a uniform history doesn't read as all-faint. See `levelFor`.
 */
export function computeLevelThresholds(counts: number[]): [number, number, number] {
  const nz = counts.filter((c) => c > 0).sort((a, b) => a - b);
  if (nz.length === 0) return [0, 0, 0];
  const min = nz[0];
  const max = nz[nz.length - 1];
  if (min === max) return [min - 1, min, max]; // one distinct value → level 2
  const q = (p: number) => nz[Math.min(nz.length - 1, Math.floor(p * nz.length))];
  let [t1, t2, t3] = [q(0.25), q(0.5), q(0.75)];
  // With few days the 75th-percentile point can be the max itself, which would trap
  // your biggest days at level 3. Keep the top cut below max so max always reaches 4,
  // then re-settle the lower cuts to stay monotonic.
  if (t3 >= max) t3 = max - 1;
  if (t2 > t3) t2 = t3;
  if (t1 > t2) t1 = t2;
  return [t1, t2, t3];
}

/** Bucket a day's count into 0 (empty) or 1–4 (light→dark) against `thresholds`. */
export function levelFor(count: number, [t1, t2, t3]: [number, number, number]): number {
  if (count <= 0) return 0;
  if (count <= t1) return 1;
  if (count <= t2) return 2;
  if (count <= t3) return 3;
  return 4;
}

/**
 * Build the heatmap grid: `weeks` whole Monday-first weeks ending in the week that
 * contains `today`. Returns weeks*7 cells, oldest first, so the client chunks by 7
 * into one row per week. Days after `today` are flagged `future` (rendered blank).
 * `level` is relative to the user's whole history (all of `counts`), not the visible
 * window, so scrolling the window wouldn't reshuffle shades. `perfect` days (all
 * words + all verbs + a Freund chat) are marked for the client's emerald ring; never
 * a future day.
 */
export function buildHeatmap(
  counts: Map<string, number>,
  today: string,
  weeks: number,
  perfect: Set<string> = new Set(),
): HeatmapCell[] {
  const thresholds = computeLevelThresholds([...counts.values()]);
  // Start on the Monday of the earliest week in the window.
  const start = addDays(today, -(mondayIndex(today) + (weeks - 1) * 7));
  const cells: HeatmapCell[] = [];
  for (let i = 0; i < weeks * 7; i++) {
    const date = addDays(start, i);
    const count = counts.get(date) ?? 0;
    const future = date > today;
    cells.push({
      date,
      count,
      level: levelFor(count, thresholds),
      perfect: !future && perfect.has(date),
      future,
    });
  }
  return cells;
}

/**
 * Percentage (0–100, rounded) of the last `days` calendar days ending today that were
 * perfect. A fixed denominator (not "days with any activity") so it honestly reflects
 * consistency: skipped days count against you. Days before you started simply aren't
 * perfect (daily_progress has no row), which is the intended, un-backfillable behavior.
 */
export function perfectPct(perfect: Set<string>, today: string, days = 30): number {
  let hits = 0;
  for (let i = 0; i < days; i++) if (perfect.has(addDays(today, -i))) hits++;
  return Math.round((hits / days) * 100);
}

/** Total activity over the last 7 days (today and the 6 days before it). */
export function sumLastWeek(counts: Map<string, number>, today: string): number {
  let total = 0;
  for (let i = 0; i < 7; i++) total += counts.get(addDays(today, -i)) ?? 0;
  return total;
}
