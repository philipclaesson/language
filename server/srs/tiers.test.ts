import { test } from "node:test";
import assert from "node:assert/strict";
import { tierFor, summarizeProgress } from "./tiers.ts";

test("null stability (no review state) is 'new'", () => {
  assert.equal(tierFor(null), "new");
});

test("tier boundaries are inclusive at the low end", () => {
  assert.equal(tierFor(0.5), "learning"); // studied but weak
  assert.equal(tierFor(6.99), "learning");
  assert.equal(tierFor(7), "familiar"); // 7d exactly -> familiar
  assert.equal(tierFor(20.99), "familiar");
  assert.equal(tierFor(21), "mastered"); // 21d exactly -> mastered
  assert.equal(tierFor(365), "mastered");
});

test("summarizeProgress counts each tier and surfaces the headline", () => {
  const stabilities = [null, null, 3, 10, 25, 25, 25];
  const p = summarizeProgress(stabilities, 4);
  assert.deepEqual(p.tiers, { new: 2, learning: 1, familiar: 1, mastered: 3 });
  assert.equal(p.mastered, 3);
  assert.equal(p.total, 7);
  assert.equal(p.reviewsToday, 4);
});

test("an empty library is all zeros, not a crash", () => {
  const p = summarizeProgress([], 0);
  assert.deepEqual(p.tiers, { new: 0, learning: 0, familiar: 0, mastered: 0 });
  assert.equal(p.total, 0);
});
