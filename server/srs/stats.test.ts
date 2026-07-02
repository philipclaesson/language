import { test } from "node:test";
import assert from "node:assert/strict";
import {
  addDays,
  mondayIndex,
  localDateString,
  computeStreaks,
  buildHeatmap,
  sumLastWeek,
} from "./stats.ts";

test("addDays does DST-proof calendar arithmetic", () => {
  assert.equal(addDays("2026-07-02", 1), "2026-07-03");
  assert.equal(addDays("2026-07-01", -1), "2026-06-30");
  assert.equal(addDays("2026-12-31", 1), "2027-01-01");
  // Across Berlin spring-forward (2026-03-29) — pure calendar, no skipped day.
  assert.equal(addDays("2026-03-28", 1), "2026-03-29");
  assert.equal(addDays("2026-03-29", 1), "2026-03-30");
});

test("mondayIndex: Monday=0 … Sunday=6", () => {
  assert.equal(mondayIndex("2026-06-29"), 0); // Monday
  assert.equal(mondayIndex("2026-07-02"), 3); // Thursday
  assert.equal(mondayIndex("2026-07-05"), 6); // Sunday
});

test("localDateString buckets by timezone", () => {
  // 22:30Z on 2026-06-21 = 00:30 Berlin on the 22nd (summer, UTC+2).
  assert.equal(localDateString(new Date("2026-06-21T22:30:00Z"), "Europe/Berlin"), "2026-06-22");
  // 21:00Z same day = 23:00 Berlin, still the 21st.
  assert.equal(localDateString(new Date("2026-06-21T21:00:00Z"), "Europe/Berlin"), "2026-06-21");
});

test("computeStreaks: current streak counts consecutive days up to today", () => {
  const active = new Set(["2026-06-29", "2026-06-30", "2026-07-01", "2026-07-02"]);
  const { current, longest } = computeStreaks(active, "2026-07-02");
  assert.equal(current, 4);
  assert.equal(longest, 4);
});

test("computeStreaks: today not done yet, but yesterday keeps the streak alive", () => {
  const active = new Set(["2026-06-30", "2026-07-01"]);
  const { current } = computeStreaks(active, "2026-07-02");
  assert.equal(current, 2, "run ending yesterday still counts");
});

test("computeStreaks: a two-day gap breaks the current streak to zero", () => {
  const active = new Set(["2026-06-28", "2026-06-29"]);
  const { current } = computeStreaks(active, "2026-07-02");
  assert.equal(current, 0);
});

test("computeStreaks: longest run is found among older days", () => {
  const active = new Set([
    "2026-06-01", "2026-06-02", "2026-06-03", "2026-06-04", "2026-06-05", // run of 5
    "2026-06-20", "2026-06-21", // run of 2
    "2026-07-02", // today, alone
  ]);
  const { current, longest } = computeStreaks(active, "2026-07-02");
  assert.equal(longest, 5);
  assert.equal(current, 1);
});

test("computeStreaks: no activity → zeros", () => {
  assert.deepEqual(computeStreaks(new Set(), "2026-07-02"), { current: 0, longest: 0 });
});

test("buildHeatmap: whole Monday-first weeks, today's week last, future blanked", () => {
  const counts = new Map([
    ["2026-07-02", 12], // Thursday, today
    ["2026-06-29", 3], // Monday of today's week
  ]);
  const cells = buildHeatmap(counts, "2026-07-02", 6);
  assert.equal(cells.length, 42, "6 weeks * 7 days");
  assert.equal(cells[0].date, "2026-05-25", "starts on a Monday 5 weeks back");
  assert.equal(mondayIndex(cells[0].date), 0);
  // Last row is the current week: Mon 06-29 … Sun 07-05.
  assert.equal(cells[35].date, "2026-06-29");
  assert.equal(cells[35].count, 3);
  const today = cells.find((c) => c.date === "2026-07-02")!;
  assert.equal(today.count, 12);
  assert.equal(today.future, false);
  // Fri–Sun of the current week are after today → future/blank.
  assert.equal(cells.find((c) => c.date === "2026-07-03")!.future, true);
  assert.equal(cells[41].date, "2026-07-05");
  assert.equal(cells[41].future, true);
});

test("sumLastWeek totals today + the previous six days only", () => {
  const counts = new Map([
    ["2026-07-02", 5],
    ["2026-06-30", 4],
    ["2026-06-26", 3], // exactly 6 days back — included
    ["2026-06-25", 99], // 7 days back — excluded
  ]);
  assert.equal(sumLastWeek(counts, "2026-07-02"), 12);
});
