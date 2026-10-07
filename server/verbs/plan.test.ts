import { test } from "node:test";
import assert from "node:assert/strict";
import {
  planVerbDay,
  planPastVerbDay,
  mergeVerbPlans,
  planVerbsToday,
  NEW_VERBS_PER_DAY,
  NEW_PAST_PER_DAY,
  VERB_DUE_CAP,
} from "./plan";
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

test("past stream: fresh cards taken in plain frequency order, no regularity mix", () => {
  // Regularity should NOT influence past selection — pure frequency order wins.
  const verbs = [
    v("r1", "regular", 1),
    v("i2", "irregular", 2),
    v("r3", "regular", 3),
    v("i4", "irregular", 4),
    v("r5", "regular", 5),
    v("i6", "irregular", 6),
    v("r7", "regular", 7),
  ];
  const plan = planPastVerbDay(verbs, NOW);
  assert.equal(plan.newTotal, NEW_PAST_PER_DAY);
  assert.deepEqual(plan.pendingIds.sort(), ["r1", "i2", "r3", "i4", "r5"].sort());
});

test("past stream: fewer verbs than the limit → take what exists", () => {
  const verbs = [v("a", "regular", 1), v("b", "irregular", 2)];
  const plan = planPastVerbDay(verbs, NOW);
  assert.equal(plan.newTotal, 2);
});

test("mergeVerbPlans sums totals and ANDs completeness", () => {
  const present = planVerbDay([v("p1", "irregular", 1), v("p2", "regular", 2)], NOW);
  const past = planPastVerbDay([v("q1", "regular", 1)], NOW);
  const merged = mergeVerbPlans(present, past);
  assert.equal(merged.newTotal, present.newTotal + past.newTotal);
  assert.equal(merged.pending, present.pending + past.pending);
  assert.deepEqual(merged.pendingIds.sort(), [...present.pendingIds, ...past.pendingIds].sort());
  assert.equal(merged.complete, present.complete && past.complete);
});

// --- the due-load cap (new-verb intake backpressure) ---

const dueItem = (id: string, rank: number): VerbToday =>
  v(id, "irregular", rank, { hasState: true, due: PAST, reviewedBeforeToday: true });

test("planVerbDay: more than `cap` due items pauses new verbs", () => {
  const verbs = [
    ...Array.from({ length: 4 }, (_, i) => dueItem(`d${i}`, i + 1)),
    v("f1", "irregular", 10),
    v("f2", "regular", 11),
  ];
  const p = planVerbDay(verbs, NOW, { cap: 3 });
  assert.equal(p.dueTotal, 4);
  assert.equal(p.newTotal, 0);
  assert.equal(p.newPaused, true);
  // Exactly at the cap is not "more than": the usual quota is back.
  const q = planVerbDay(verbs.slice(1), NOW, { cap: 3 });
  assert.equal(q.newTotal, 2);
  assert.equal(q.newPaused, false);
});

test("planPastVerbDay: the cap applies to the past stream too", () => {
  const verbs = [
    ...Array.from({ length: 4 }, (_, i) => dueItem(`d${i}`, i + 1)),
    v("f1", "irregular", 10),
  ];
  const p = planPastVerbDay(verbs, NOW, { cap: 3 });
  assert.equal(p.newTotal, 0);
  assert.equal(p.newPaused, true);
});

test("planVerbsToday: the due load is counted across both tense streams, not per stream", () => {
  // Two due in present + two due in past = 4 items today. Neither stream alone
  // exceeds a cap of 3; together they do, so both stop introducing.
  const present = [...Array.from({ length: 2 }, (_, i) => dueItem(`p${i}`, i + 1)), v("pf", "irregular", 20)];
  const past = [...Array.from({ length: 2 }, (_, i) => dueItem(`q${i}`, i + 1)), v("qf", "irregular", 21)];

  const merged = planVerbsToday(present, past, NOW, { cap: 3 });
  assert.equal(merged.dueTotal, 4);
  assert.equal(merged.newTotal, 0);
  assert.equal(merged.newPaused, true);

  // Per-stream counting would have let both through — the guard against regressing.
  const perStream = mergeVerbPlans(
    planVerbDay(present, NOW, { cap: 3 }),
    planPastVerbDay(past, NOW, { cap: 3 }),
  );
  assert.equal(perStream.newTotal, 2);
});

test("planVerbsToday: under the cap both streams introduce as before", () => {
  const present = Array.from({ length: 10 }, (_, i) => v(`p${i}`, i % 2 ? "regular" : "irregular", i + 1));
  const past = Array.from({ length: 10 }, (_, i) => v(`q${i}`, "irregular", i + 1));
  const p = planVerbsToday(present, past, NOW);
  assert.equal(p.newTotal, NEW_VERBS_PER_DAY + NEW_PAST_PER_DAY);
  assert.equal(p.newPaused, false);
});

test("planVerbsToday: the cap defaults to VERB_DUE_CAP", () => {
  const present = [
    ...Array.from({ length: VERB_DUE_CAP + 1 }, (_, i) => dueItem(`d${i}`, i + 1)),
    v("f1", "irregular", 100),
  ];
  assert.equal(planVerbsToday(present, [], NOW).newTotal, 0);
  assert.equal(planVerbsToday(present.slice(1), [], NOW).newTotal, 1);
});
