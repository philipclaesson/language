// Day-boundary + daily-loop logic, as pure functions (PLAN.md §5a). No I/O — the
// route passes in `now` and the data it read; these decide grading and progress.
//
// "Today" is bounded by a single configured timezone for now (no per-user setting
// yet — see §5a "Constants for now"). When a settings screen arrives these become
// `users.timezone` / `users.daily_new_limit`.

export const DAY_TZ = "Europe/Berlin";
export const NEW_PER_DAY = 10;

/**
 * Offset (ms) of `tz` at the instant `date`, such that local = utc + offset.
 * E.g. Berlin in summer (UTC+2) → +7_200_000. Derived from the Intl wall-clock
 * parts so it's correct across DST without a date library.
 */
export function tzOffsetMs(date: Date, tz: string): number {
  const dtf = new Intl.DateTimeFormat("en-US", {
    timeZone: tz,
    hourCycle: "h23",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
  });
  const m: Record<string, string> = {};
  for (const p of dtf.formatToParts(date)) m[p.type] = p.value;
  const asUTC = Date.UTC(
    +m.year,
    +m.month - 1,
    +m.day,
    +m.hour,
    +m.minute,
    +m.second,
  );
  return asUTC - date.getTime();
}

// The instant of local midnight for a given local calendar date in `tz`.
// Iterates once to settle the offset (it can differ between the naive guess and
// the real instant on a DST-transition day).
function localMidnightInstant(y: number, mo: number, d: number, tz: string): Date {
  const guess = Date.UTC(y, mo, d);
  const off1 = tzOffsetMs(new Date(guess), tz);
  let instant = guess - off1;
  const off2 = tzOffsetMs(new Date(instant), tz);
  if (off2 !== off1) instant = guess - off2;
  return new Date(instant);
}

/** Start of the local day (most recent local midnight at/before `now`). */
export function startOfDay(now: Date, tz: string = DAY_TZ): Date {
  const local = new Date(now.getTime() + tzOffsetMs(now, tz));
  return localMidnightInstant(
    local.getUTCFullYear(),
    local.getUTCMonth(),
    local.getUTCDate(),
    tz,
  );
}

/**
 * End of the local day = start of the next local day (exclusive upper bound).
 * Used both as the "due <= end of today" cutoff and the upper end of the
 * "reviewed today" range. The +36h hop lands safely inside the next day across
 * both 23h and 25h DST days before snapping back to its midnight.
 */
export function endOfDay(now: Date, tz: string = DAY_TZ): Date {
  const start = startOfDay(now, tz);
  const next = new Date(start.getTime() + 36 * 3_600_000);
  const local = new Date(next.getTime() + tzOffsetMs(next, tz));
  return localMidnightInstant(
    local.getUTCFullYear(),
    local.getUTCMonth(),
    local.getUTCDate(),
    tz,
  );
}

/** Whether two instants fall on the same local calendar day in `tz`. */
export function isSameLocalDay(a: Date, b: Date, tz: string = DAY_TZ): boolean {
  return startOfDay(a, tz).getTime() === startOfDay(b, tz).getTime();
}

/**
 * Is this the first attempt today on a card? The first attempt of the day drives
 * the FSRS schedule; later same-day attempts are training-only re-drills.
 * `lastReviewedAt` is the most recent prior review for the card (null if never).
 */
export function isFirstAttemptOfDay(
  lastReviewedAt: Date | null,
  now: Date,
  tz: string = DAY_TZ,
): boolean {
  return lastReviewedAt === null || !isSameLocalDay(lastReviewedAt, now, tz);
}

export type TodayProgress = { done: number; pending: number; complete: boolean };

/**
 * Progress over today's required set: how many of the required cards have already
 * been typed correctly today, and whether the day is finished. A required card
 * stays counted as pending until it has a correct typing today — including a card
 * you failed (whose FSRS due has moved to tomorrow) but haven't re-drilled yet.
 */
export function dayProgress(
  requiredCardIds: string[],
  correctTodayCardIds: Set<string>,
): TodayProgress {
  let done = 0;
  for (const id of requiredCardIds) if (correctTodayCardIds.has(id)) done++;
  const pending = requiredCardIds.length - done;
  return { done, pending, complete: pending === 0 };
}

/**
 * How many cards the "new" portion of today's required set should contain:
 * the ones already introduced today, plus enough fresh ones to reach the daily
 * limit (bounded by how many unstudied cards actually remain).
 */
export function newRequiredCount(
  introducedToday: number,
  available: number,
  limit: number = NEW_PER_DAY,
): number {
  const slotsLeft = Math.max(0, limit - introducedToday);
  return introducedToday + Math.min(slotsLeft, available);
}

// One card's daily-relevant facts, gathered by the route from review_state + the
// reviews log. `reviewedToday` / `correctToday` / `reviewedBeforeToday` count ALL
// attempts (a re-drill that finally lands counts as correct). Fresh cards must be
// passed in the order you'd introduce them (e.g. createdAt) — planToday takes the
// first N to fill the new-card quota.
export type CardToday = {
  id: string;
  hasState: boolean; // has a review_state row (has been studied at least once)
  due: Date | null; // review_state.due, or null if never studied
  reviewedToday: boolean;
  correctToday: boolean;
  reviewedBeforeToday: boolean;
};

export type TodayPlan = {
  pendingIds: string[]; // required cards not yet typed correctly today (to present)
  dueTotal: number; // required due-reviews in today's set
  newTotal: number; // required new cards in today's set (<= limit)
  done: number; // required cards already typed correctly today
  pending: number; // = pendingIds.length
  complete: boolean;
};

/**
 * Build today's required set + progress (PLAN.md §5a). Pure: no I/O, no clock —
 * the route passes `now` and the per-card facts. Three buckets make a card
 * "required today":
 *   - **due reviews** — studied cards due by end of today, or any due-review you
 *     already touched today (so a card you failed stays required even though its
 *     FSRS due moved to tomorrow);
 *   - **introduced today** — brand-new cards whose first-ever attempt was today;
 *   - **fresh** — unstudied cards pulled in to fill the daily new-card quota.
 * The total (due + new) is stable across the day: completing a card moves it from
 * pending to done without changing the denominator.
 */
export function planToday(
  cards: CardToday[],
  now: Date,
  opts: { tz?: string; limit?: number } = {},
): TodayPlan {
  const tz = opts.tz ?? DAY_TZ;
  const limit = opts.limit ?? NEW_PER_DAY;
  const end = endOfDay(now, tz).getTime();

  const dueReq: CardToday[] = [];
  const introduced: CardToday[] = [];
  const fresh: CardToday[] = [];

  for (const c of cards) {
    if (!c.hasState && !c.reviewedToday) {
      fresh.push(c); // never studied, untouched today — quota candidate
      continue;
    }
    if (c.reviewedToday && !c.reviewedBeforeToday) {
      introduced.push(c); // first-ever attempt was today
      continue;
    }
    const isDue = c.due !== null && c.due.getTime() < end;
    if (isDue || c.reviewedToday) dueReq.push(c);
    // else: a studied card not due and untouched today — not part of today.
  }

  const newTotal = newRequiredCount(introduced.length, fresh.length, limit);
  const freshToPresent = fresh.slice(0, Math.max(0, newTotal - introduced.length));

  const required = [...dueReq, ...introduced, ...freshToPresent];
  const correct = new Set(cards.filter((c) => c.correctToday).map((c) => c.id));
  const { done, pending, complete } = dayProgress(
    required.map((c) => c.id),
    correct,
  );

  return {
    pendingIds: required.filter((c) => !correct.has(c.id)).map((c) => c.id),
    dueTotal: dueReq.length,
    newTotal,
    done,
    pending,
    complete,
  };
}
