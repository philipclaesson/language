import { test } from "node:test";
import assert from "node:assert/strict";
import { planVerbDay, NEW_VERBS_PER_DAY } from "./plan";
import type { VerbToday } from "./plan";
import type { VerbRegularity } from "../../shared/types";

const NOW = new Date("2026-07-01T12:00:00Z");
const PAST = new Date("2026-06-30T00:00:00Z");

function v(
  id: string,
  regularity: VerbRegularity,
  frequencyRank: number,
  extra: Partial<VerbToday> = {},
): VerbToday {
  return {
    id,
    regularity,
    frequencyRank,
    hasState: false,
    due: null,
    reviewedToday: false,
    correctToday: false,
    reviewedBeforeToday: false,
    ...extra,
  };
}

test("fresh day: 3 irregular + 2 regular, in frequency order", () => {
  const verbs = [
    v("i1", "irregular", 1),
    v("r2", "regular", 2),
    v("i3", "irregular", 3),
    v("r4", "regular", 4),
    v("i5", "irregular", 5),
    v("r6", "regular", 6),
    v("i7", "irregular", 7),
    v("r8", "regular", 8),
  ];
  const plan = planVerbDay(verbs, NOW);
  assert.equal(plan.newTotal, 5);
  assert.equal(plan.dueTotal, 0);
  assert.equal(plan.pending, 5);
  assert.deepEqual(plan.pendingIds.sort(), ["i1", "i3", "i5", "r2", "r4"].sort());
});

test("spill-over: too few irregular → fill from regular to reach 5", () => {
  const verbs = [
    v("i1", "irregular", 1),
    v("r2", "regular", 2),
    v("r3", "regular", 3),
    v("r4", "regular", 4),
    v("r5", "regular", 5),
    v("r6", "regular", 6),
  ];
  const plan = planVerbDay(verbs, NOW);
  assert.equal(plan.newTotal, 5);
  assert.deepEqual(plan.pendingIds.sort(), ["i1", "r2", "r3", "r4", "r5"].sort());
});

test("only regulars available → all-regular day", () => {
  const verbs = [v("r1", "regular", 1), v("r2", "regular", 2), v("r3", "regular", 3)];
  const plan = planVerbDay(verbs, NOW);
  assert.equal(plan.newTotal, 3); // fewer than the limit → take all
});

test("fewer verbs than the daily limit → take what exists", () => {
  const verbs = [v("i1", "irregular", 1), v("r2", "regular", 2)];
  const plan = planVerbDay(verbs, NOW);
  assert.equal(plan.newTotal, 2);
  assert.ok(plan.newTotal <= NEW_VERBS_PER_DAY);
});

test("introduced-today verbs stay required; correct ones count as done", () => {
  const verbs = [
    // two introduced earlier today (first-ever attempt today)
    v("done1", "irregular", 1, {
      hasState: true,
      due: PAST,
      reviewedToday: true,
      correctToday: true,
    }),
    v("pending1", "irregular", 2, { hasState: true, due: PAST, reviewedToday: true }),
    // fresh pool to top up to the daily limit (5 - 2 introduced = 3 more)
    v("f3", "irregular", 3),
    v("f4", "regular", 4),
    v("f5", "irregular", 5),
    v("f6", "regular", 6),
  ];
  const plan = planVerbDay(verbs, NOW);
  assert.equal(plan.newTotal, 5); // 2 introduced + 3 fresh
  assert.equal(plan.done, 1); // done1
  assert.equal(plan.pending, 4);
  assert.ok(!plan.pendingIds.includes("done1"));
  assert.ok(plan.pendingIds.includes("pending1"));
});

test("due studied verbs are required regardless of regularity", () => {
  const verbs = [
    v("due1", "regular", 10, { hasState: true, due: PAST }),
    v("i1", "irregular", 1), // fresh
  ];
  const plan = planVerbDay(verbs, NOW);
  assert.equal(plan.dueTotal, 1);
  assert.ok(plan.pendingIds.includes("due1"));
});

test("a studied verb not due and untouched today is excluded", () => {
  const future = new Date("2026-07-10T00:00:00Z");
  const verbs = [v("later", "regular", 1, { hasState: true, due: future })];
  const plan = planVerbDay(verbs, NOW);
  assert.equal(plan.dueTotal, 0);
  assert.equal(plan.newTotal, 0);
  assert.equal(plan.pending, 0);
  assert.equal(plan.complete, true);
});
