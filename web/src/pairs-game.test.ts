import { test } from "node:test";
import assert from "node:assert/strict";
import type { MatchPair } from "../../shared/types";
import { BOARD_PAIRS, REFILL_AT, boardDone, clearPair, createBoard, type Board } from "./pairs-game";

// Identity shuffler makes the board deterministic: tiles sit in input order and
// refills land in the lowest empty slots.
const identity = <T>(arr: T[]): T[] => [...arr];

function makePairs(n: number): MatchPair[] {
  return Array.from({ length: n }, (_, i) => ({
    id: `p${i}`,
    en: `en${i}`,
    de: `de${i}`,
  }));
}

// Clear the pair currently in en slot `enIdx` (finds its de slot by pairId).
function clearAt(board: Board, enIdx: number): Board {
  const pairId = board.en[enIdx]!.pairId;
  const deIdx = board.de.findIndex((t) => t?.pairId === pairId);
  return clearPair(board, enIdx, deIdx, identity);
}

test("createBoard shows the first BOARD_PAIRS pairs and queues the rest", () => {
  const b = createBoard(makePairs(10), identity);
  assert.equal(b.en.length, BOARD_PAIRS);
  assert.equal(b.de.length, BOARD_PAIRS);
  assert.equal(b.queue.length, 4);
  // Both sides show the same pairs.
  const ids = (tiles: Board["en"]) => tiles.map((t) => t!.pairId).sort();
  assert.deepEqual(ids(b.en), ids(b.de));
});

test("fewer pairs than a full board → smaller board, empty queue", () => {
  const b = createBoard(makePairs(4), identity);
  assert.equal(b.en.length, 4);
  assert.equal(b.queue.length, 0);
});

test("clearing a pair empties both slots and counts it", () => {
  let b = createBoard(makePairs(8), identity);
  b = clearAt(b, 2);
  assert.equal(b.en[2], null);
  assert.equal(b.de[2], null); // identity shuffle → same slot on both sides
  assert.equal(b.cleared, 1);
  assert.equal(b.sinceRefill, 1);
  assert.equal(b.queue.length, 2); // no refill yet
});

test("the REFILL_AT-th clear pulls the next pairs into the empty slots", () => {
  let b = createBoard(makePairs(12), identity);
  for (let i = 0; i < REFILL_AT; i++) b = clearAt(b, i);
  assert.equal(b.cleared, REFILL_AT);
  assert.equal(b.sinceRefill, 0);
  assert.equal(b.queue.length, 6 - REFILL_AT);
  // Board is full again, with the refilled pairs present on both sides.
  assert.ok(b.en.every((t) => t !== null));
  const ids = (tiles: Board["en"]) => tiles.map((t) => t!.pairId).sort();
  assert.deepEqual(ids(b.en), ids(b.de));
  assert.ok(b.en.some((t) => t!.pairId === "p6"));
});

test("a short queue refills with whatever is left", () => {
  let b = createBoard(makePairs(BOARD_PAIRS + 1), identity);
  for (let i = 0; i < REFILL_AT; i++) b = clearAt(b, i);
  assert.equal(b.queue.length, 0);
  // 6 on board, cleared 3, refilled 1 → 4 tiles remain.
  assert.equal(b.en.filter((t) => t !== null).length, 4);
});

test("no refill once the queue is empty; boardDone when everything is cleared", () => {
  let b = createBoard(makePairs(4), identity);
  for (let i = 0; i < 4; i++) {
    assert.equal(boardDone(b), false);
    b = clearAt(b, i);
  }
  assert.equal(b.cleared, 4);
  assert.equal(boardDone(b), true);
});

test("every pair is eventually shown and clearable", () => {
  let b = createBoard(makePairs(20), identity);
  let guard = 0;
  while (!boardDone(b) && guard++ < 100) {
    const enIdx = b.en.findIndex((t) => t !== null);
    b = clearAt(b, enIdx);
  }
  assert.equal(b.cleared, 20);
  assert.equal(boardDone(b), true);
});
