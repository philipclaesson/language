import { test } from "node:test";
import assert from "node:assert/strict";
import {
  startOfDay,
  endOfDay,
  isSameLocalDay,
  isFirstAttemptOfDay,
  dayProgress,
  newRequiredCount,
  planToday,
  freshPool,
  practicePool,
  missesPool,
  type CardToday,
} from "./day.ts";

const TZ = "Europe/Berlin";
const iso = (d: Date) => d.toISOString();

test("summer day boundary (Berlin UTC+2)", () => {
  const now = new Date("2026-06-21T10:00:00Z");
  assert.equal(iso(startOfDay(now, TZ)), "2026-06-20T22:00:00.000Z");
  assert.equal(iso(endOfDay(now, TZ)), "2026-06-21T22:00:00.000Z");
});

test("winter day boundary (Berlin UTC+1)", () => {
  const now = new Date("2026-01-15T12:00:00Z");
  assert.equal(iso(startOfDay(now, TZ)), "2026-01-14T23:00:00.000Z");
  assert.equal(iso(endOfDay(now, TZ)), "2026-01-15T23:00:00.000Z");
});

test("late-evening local time is still the same local day", () => {
  // 21:30Z = 23:30 Berlin (summer) — same day as 10:00Z.
  const morning = new Date("2026-06-21T10:00:00Z");
  const lateEve = new Date("2026-06-21T21:30:00Z");
  assert.ok(isSameLocalDay(morning, lateEve, TZ));
  // 22:30Z = 00:30 Berlin next day — a different local day.
  const pastMidnight = new Date("2026-06-21T22:30:00Z");
  assert.ok(!isSameLocalDay(morning, pastMidnight, TZ));
});

test("DST spring-forward day is only 23h long, boundaries still correct", () => {
  // 2026-03-29: Berlin clocks jump 02:00 -> 03:00 (UTC+1 -> UTC+2).
  const now = new Date("2026-03-29T05:00:00Z");
  assert.equal(iso(startOfDay(now, TZ)), "2026-03-28T23:00:00.000Z"); // midnight at +1
  assert.equal(iso(endOfDay(now, TZ)), "2026-03-29T22:00:00.000Z"); // next midnight at +2
  assert.equal(endOfDay(now, TZ).getTime() - startOfDay(now, TZ).getTime(), 23 * 3_600_000);
});

test("DST fall-back day is 25h long, boundaries still correct", () => {
  // 2026-10-25: Berlin clocks fall 03:00 -> 02:00 (UTC+2 -> UTC+1).
  const now = new Date("2026-10-25T05:00:00Z");
  assert.equal(iso(startOfDay(now, TZ)), "2026-10-24T22:00:00.000Z");
  assert.equal(iso(endOfDay(now, TZ)), "2026-10-25T23:00:00.000Z");
  assert.equal(endOfDay(now, TZ).getTime() - startOfDay(now, TZ).getTime(), 25 * 3_600_000);
});

test("isFirstAttemptOfDay: never reviewed, earlier today, and earlier day", () => {
  const now = new Date("2026-06-21T10:00:00Z");
  assert.equal(isFirstAttemptOfDay(null, now, TZ), true, "never reviewed");
  assert.equal(
    isFirstAttemptOfDay(new Date("2026-06-21T08:00:00Z"), now, TZ),
    false,
    "already reviewed earlier today -> re-drill",
  );
  // 23:00Z on the 20th is 01:00 Berlin on the 21st — still "today", a re-drill.
  assert.equal(isFirstAttemptOfDay(new Date("2026-06-20T23:00:00Z"), now, TZ), false);
  // 21:00Z on the 20th is 23:00 Berlin on the 20th — genuinely yesterday.
  assert.equal(
    isFirstAttemptOfDay(new Date("2026-06-20T21:00:00Z"), now, TZ),
    true,
    "last review was yesterday (Berlin) -> first of day",
  );
});

test("dayProgress: done/pending/complete, re-drilled card counts once correct", () => {
  const required = ["a", "b", "c"];
  assert.deepEqual(dayProgress(required, new Set()), { done: 0, pending: 3, complete: false });
  assert.deepEqual(dayProgress(required, new Set(["a", "b"])), {
    done: 2,
    pending: 1,
    complete: false,
  });
  // 'c' was failed then finally typed correct -> now in the correct set -> done.
  assert.deepEqual(dayProgress(required, new Set(["a", "b", "c"])), {
    done: 3,
    pending: 0,
    complete: true,
  });
});

test("dayProgress ignores correct cards that aren't in today's required set", () => {
  // A bonus/practice card typed correctly shouldn't inflate required progress.
  assert.deepEqual(dayProgress(["a"], new Set(["a", "bonus"])), {
    done: 1,
    pending: 0,
    complete: true,
  });
});

test("newRequiredCount caps at the daily limit and at what's available", () => {
  assert.equal(newRequiredCount(0, 50, 10), 10); // fresh day, plenty available
  assert.equal(newRequiredCount(0, 3, 10), 3); // only 3 new cards exist
  assert.equal(newRequiredCount(4, 50, 10), 10); // 4 already done + 6 more slots
  assert.equal(newRequiredCount(4, 2, 10), 6); // 4 done + only 2 available
  assert.equal(newRequiredCount(10, 50, 10), 10); // limit reached
});

// --- planToday ---

const NOW = new Date("2026-06-21T10:00:00Z"); // Berlin summer; end of day = 22:00Z
const YESTERDAY = new Date("2026-06-20T08:00:00Z");
const TOMORROW = new Date("2026-06-22T08:00:00Z"); // after end-of-today

function card(id: string, o: Partial<CardToday> = {}): CardToday {
  return {
    id,
    hasState: o.hasState ?? false,
    due: o.due ?? null,
    reviewedToday: o.reviewedToday ?? false,
    correctToday: o.correctToday ?? false,
    reviewedBeforeToday: o.reviewedBeforeToday ?? false,
    stock: o.stock ?? false,
  };
}

test("planToday: fresh start — due reviews + fresh new cards, all pending", () => {
  const cards = [
    card("d1", { hasState: true, due: YESTERDAY, reviewedBeforeToday: true }),
    card("d2", { hasState: true, due: YESTERDAY, reviewedBeforeToday: true }),
    card("d3", { hasState: true, due: YESTERDAY, reviewedBeforeToday: true }),
    card("f1"),
    card("f2"),
    card("f3"),
    card("f4"),
    card("f5"),
  ];
  const p = planToday(cards, NOW, { limit: 10 });
  assert.equal(p.dueTotal, 3);
  assert.equal(p.newTotal, 5); // 5 fresh available, under the limit
  assert.equal(p.done, 0);
  assert.equal(p.pending, 8);
  assert.equal(p.complete, false);
  assert.deepEqual(p.pendingIds.sort(), ["d1", "d2", "d3", "f1", "f2", "f3", "f4", "f5"]);
});

test("planToday: mid-day — failed card stays required, denominator stays stable", () => {
  const cards = [
    // a due card already passed today (its due moved into the future)
    card("dA", { hasState: true, due: TOMORROW, reviewedToday: true, correctToday: true, reviewedBeforeToday: true }),
    // a due card failed today — due pushed to tomorrow, still pending
    card("dB", { hasState: true, due: TOMORROW, reviewedToday: true, correctToday: false, reviewedBeforeToday: true }),
    // a due card not yet touched
    card("dC", { hasState: true, due: YESTERDAY, reviewedBeforeToday: true }),
    // a new card introduced today, passed
    card("nX", { hasState: true, due: TOMORROW, reviewedToday: true, correctToday: true, reviewedBeforeToday: false }),
    card("f1"),
    card("f2"),
  ];
  const p = planToday(cards, NOW, { limit: 10 });
  assert.equal(p.dueTotal, 3, "dA, dB, dC are the due-review set");
  assert.equal(p.newTotal, 3, "nX introduced + 2 fresh");
  assert.equal(p.done, 2, "dA and nX");
  assert.equal(p.pending, 4);
  assert.deepEqual(p.pendingIds.sort(), ["dB", "dC", "f1", "f2"]);
  assert.equal(p.dueTotal + p.newTotal, p.done + p.pending, "denominator = done + pending");
});

test("planToday: new-card quota caps fresh intake at the limit", () => {
  const cards = [
    card("nA", { hasState: true, due: TOMORROW, reviewedToday: true, correctToday: true, reviewedBeforeToday: false }),
    card("nB", { hasState: true, due: TOMORROW, reviewedToday: true, correctToday: true, reviewedBeforeToday: false }),
    ...Array.from({ length: 50 }, (_, i) => card(`f${i}`)),
  ];
  const p = planToday(cards, NOW, { limit: 10 });
  assert.equal(p.dueTotal, 0);
  assert.equal(p.newTotal, 10, "2 introduced + 8 fresh = the limit");
  assert.equal(p.done, 2);
  assert.equal(p.pending, 8, "only 8 fresh pulled in despite 50 available");
});

test("planToday: a studied, not-due, untouched card is not part of today", () => {
  const cards = [
    card("known", { hasState: true, due: TOMORROW, reviewedBeforeToday: true }), // not due, untouched
    card("d1", { hasState: true, due: YESTERDAY, reviewedBeforeToday: true }),
  ];
  const p = planToday(cards, NOW, { limit: 10 });
  assert.equal(p.dueTotal, 1);
  assert.equal(p.newTotal, 0);
  assert.deepEqual(p.pendingIds, ["d1"]);
});

test("planToday: fresh new cards split 50/50 between own and stock", () => {
  const cards = [
    ...Array.from({ length: 20 }, (_, i) => card(`own${i}`, { stock: false })),
    ...Array.from({ length: 20 }, (_, i) => card(`stk${i}`, { stock: true })),
  ];
  const p = planToday(cards, NOW, { limit: 10 });
  assert.equal(p.newTotal, 10);
  const own = p.pendingIds.filter((id) => id.startsWith("own")).length;
  const stk = p.pendingIds.filter((id) => id.startsWith("stk")).length;
  assert.equal(own, 5, "5 of the user's own cards");
  assert.equal(stk, 5, "5 stock-corpus cards");
});

test("planToday: split spills into stock when own pool is short", () => {
  const cards = [
    card("own0", { stock: false }),
    card("own1", { stock: false }),
    ...Array.from({ length: 20 }, (_, i) => card(`stk${i}`, { stock: true })),
  ];
  const p = planToday(cards, NOW, { limit: 10 });
  assert.equal(p.newTotal, 10, "quota still filled");
  const own = p.pendingIds.filter((id) => id.startsWith("own")).length;
  const stk = p.pendingIds.filter((id) => id.startsWith("stk")).length;
  assert.equal(own, 2, "both of the user's cards");
  assert.equal(stk, 8, "stock fills the rest");
});

test("planToday: odd remaining slots favour the user's own cards", () => {
  // 1 introduced today leaves 9 slots → ceil(9/2)=5 own, 4 stock.
  const cards = [
    card("nX", { hasState: true, due: TOMORROW, reviewedToday: true, correctToday: true, reviewedBeforeToday: false }),
    ...Array.from({ length: 20 }, (_, i) => card(`own${i}`, { stock: false })),
    ...Array.from({ length: 20 }, (_, i) => card(`stk${i}`, { stock: true })),
  ];
  const p = planToday(cards, NOW, { limit: 10 });
  assert.equal(p.newTotal, 10, "1 introduced + 9 fresh");
  const own = p.pendingIds.filter((id) => id.startsWith("own")).length;
  const stk = p.pendingIds.filter((id) => id.startsWith("stk")).length;
  assert.equal(own, 5);
  assert.equal(stk, 4);
});

test("planToday: everything done — complete", () => {
  const cards = [
    card("d1", { hasState: true, due: TOMORROW, reviewedToday: true, correctToday: true, reviewedBeforeToday: true }),
    card("nX", { hasState: true, due: TOMORROW, reviewedToday: true, correctToday: true, reviewedBeforeToday: false }),
  ];
  const p = planToday(cards, NOW, { limit: 10 });
  assert.equal(p.done, 2);
  assert.equal(p.pending, 0);
  assert.equal(p.complete, true);
  assert.deepEqual(p.pendingIds, []);
});

// ---- Extra/bonus pools (EXTRA_WORK.md) ----

test("freshPool: unstudied, untouched-today cards in order, capped by limit", () => {
  const cands = [
    { id: "a", hasState: true, reviewedToday: false }, // studied → excluded
    { id: "b", hasState: false, reviewedToday: true }, // touched today → excluded
    { id: "c", hasState: false, reviewedToday: false },
    { id: "d", hasState: false, reviewedToday: false },
    { id: "e", hasState: false, reviewedToday: false },
  ];
  assert.deepEqual(freshPool(cands, 2), ["c", "d"]);
  assert.deepEqual(freshPool(cands, Infinity), ["c", "d", "e"]);
});

test("practicePool: studied, not-due, not-reviewed-today, weakest-first", () => {
  const cands = [
    { id: "due", due: NOW, stability: 5, reviewedToday: false }, // due today → excluded
    { id: "today", due: TOMORROW, stability: 1, reviewedToday: true }, // touched today → excluded
    { id: "strong", due: TOMORROW, stability: 30, reviewedToday: false },
    { id: "weak", due: TOMORROW, stability: 8, reviewedToday: false },
    { id: "weakest", due: TOMORROW, stability: 2, reviewedToday: false },
  ];
  // Weakest-first, and the due / already-reviewed cards are gone.
  assert.deepEqual(practicePool(cands, NOW, { limit: 10 }), ["weakest", "weak", "strong"]);
  assert.deepEqual(practicePool(cands, NOW, { limit: 2 }), ["weakest", "weak"]);
});

test("practicePool: a card due exactly at end-of-day is still practice-eligible", () => {
  const end = endOfDay(NOW, TZ); // due >= end counts as not-due-today
  const cands = [{ id: "edge", due: end, stability: 3, reviewedToday: false }];
  assert.deepEqual(practicePool(cands, NOW, { limit: 10 }), ["edge"]);
});

test("missesPool: only cards missed today, in order, capped by limit", () => {
  const cands = [
    { id: "hit", missedToday: false }, // got it right today → excluded
    { id: "m1", missedToday: true },
    { id: "m2", missedToday: true },
    { id: "m3", missedToday: true },
  ];
  assert.deepEqual(missesPool(cands), ["m1", "m2", "m3"]); // all, in order
  assert.deepEqual(missesPool(cands, 2), ["m1", "m2"]);
  assert.deepEqual(missesPool([{ id: "hit", missedToday: false }]), []); // nothing missed
});
