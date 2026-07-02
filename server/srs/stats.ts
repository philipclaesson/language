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
 * Build the heatmap grid: `weeks` whole Monday-first weeks ending in the week that
 * contains `today`. Returns weeks*7 cells, oldest first, so the client chunks by 7
 * into one row per week. Days after `today` are flagged `future` (rendered blank).
 */
export function buildHeatmap(
  counts: Map<string, number>,
  today: string,
  weeks: number,
): HeatmapCell[] {
  // Start on the Monday of the earliest week in the window.
  const start = addDays(today, -(mondayIndex(today) + (weeks - 1) * 7));
  const cells: HeatmapCell[] = [];
  for (let i = 0; i < weeks * 7; i++) {
    const date = addDays(start, i);
    cells.push({ date, count: counts.get(date) ?? 0, future: date > today });
  }
  return cells;
}

/** Total activity over the last 7 days (today and the 6 days before it). */
export function sumLastWeek(counts: Map<string, number>, today: string): number {
  let total = 0;
  for (let i = 0; i < 7; i++) total += counts.get(addDays(today, -i)) ?? 0;
  return total;
}
