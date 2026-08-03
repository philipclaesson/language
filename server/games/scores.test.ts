import { test } from "node:test";
import assert from "node:assert/strict";
import { orderScores, rankOf, topScores, TOP_N, type ScoreRow } from "./scores";

const at = (min: number) => new Date(2026, 0, 1, 12, min);

const row = (id: string, score: number, minute = 0): ScoreRow => ({
  id,
  score,
  createdAt: at(minute),
});

test("orders by score descending", () => {
  const rows = [row("a", 40), row("b", 90), row("c", 70)].map((r, i) => ({
    ...r,
    createdAt: at(i),
  }));
  assert.deepEqual(
    orderScores(rows).map((r) => r.id),
    ["b", "c", "a"],
  );
});

test("ties go to the earlier submission", () => {
  const rows = [row("late", 80, 30), row("early", 80, 10), row("mid", 80, 20)];
  assert.deepEqual(
    orderScores(rows).map((r) => r.id),
    ["early", "mid", "late"],
  );
});

test("does not mutate its input", () => {
  const rows = [row("a", 10, 0), row("b", 90, 1)];
  orderScores(rows);
  assert.equal(rows[0].id, "a");
});

test("topScores caps at TOP_N", () => {
  const rows = Array.from({ length: 9 }, (_, i) => row(`p${i}`, i * 10, i));
  const top = topScores(rows);
  assert.equal(top.length, TOP_N);
  assert.equal(top[0].id, "p8"); // highest score
});

test("topScores returns everything when fewer than TOP_N", () => {
  const rows = [row("a", 50, 0), row("b", 70, 1)];
  assert.deepEqual(
    topScores(rows).map((r) => r.id),
    ["b", "a"],
  );
});

test("rankOf is 1-based over the full list, not just the top", () => {
  const rows = Array.from({ length: 8 }, (_, i) => row(`p${i}`, 100 - i, i));
  assert.equal(rankOf(rows, "p0"), 1);
  assert.equal(rankOf(rows, "p7"), 8); // below the top-5 cutoff, still ranked
  assert.equal(rankOf(rows, "nope"), -1);
});
