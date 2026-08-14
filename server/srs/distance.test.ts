import { test } from "node:test";
import assert from "node:assert/strict";
import { editDistance, withinEdits } from "./distance.ts";

test("identical strings are distance 0", () => {
  assert.equal(editDistance("laufen", "laufen"), 0);
  assert.equal(editDistance("", ""), 0);
});

test("empty string costs the other's length", () => {
  assert.equal(editDistance("", "hund"), 4);
  assert.equal(editDistance("hund", ""), 4);
});

test("one substitution, insertion or deletion is distance 1", () => {
  assert.equal(editDistance("laufen", "laufeb"), 1); // b for n
  assert.equal(editDistance("katze", "kaetze"), 1); // inserted e
  assert.equal(editDistance("gehen", "gehn"), 1); // dropped e
});

test("an adjacent transposition is distance 1, not 2", () => {
  // The whole reason we use Damerau-Levenshtein: plain Levenshtein scores this 2.
  assert.equal(editDistance("beziehungsweise", "bezeihungsweise"), 1);
  assert.equal(editDistance("die", "dei"), 1);
});

test("non-adjacent swaps and two separate slips are distance 2", () => {
  assert.equal(editDistance("laufen", "luafne"), 2);
  assert.equal(editDistance("laufen", "laifeb"), 2);
});

test("unrelated words are far apart", () => {
  assert.equal(editDistance("hund", "katze"), 5);
});

test("withinEdits bails on the length gap without a false positive", () => {
  assert.equal(withinEdits("laufen", "laufeb", 1), true);
  assert.equal(withinEdits("laufen", "lauf", 1), false); // 2 chars short
  assert.equal(withinEdits("hund", "", 1), false);
});
