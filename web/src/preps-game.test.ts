import { test } from "node:test";
import assert from "node:assert/strict";
import { PREPS, prepDeck } from "./preps-game";

test("preps are unique", () => {
  const names = PREPS.map((p) => p.prep);
  assert.equal(new Set(names).size, names.length);
});

test("the canonical lists are complete", () => {
  const of = (klasse: string) =>
    PREPS.filter((p) => p.klasse === klasse)
      .map((p) => p.prep)
      .sort();
  assert.deepEqual(of("dativ"), ["aus", "bei", "gegenüber", "mit", "nach", "seit", "von", "zu"]);
  assert.deepEqual(of("akkusativ"), ["bis", "durch", "für", "gegen", "ohne", "um"]);
  assert.deepEqual(
    of("wechsel"),
    ["an", "auf", "hinter", "in", "neben", "unter", "vor", "zwischen", "über"],
  );
});

test("every prep has an example for the correction line", () => {
  for (const p of PREPS) {
    assert.ok(p.example.includes(p.prep), `${p.prep}: example should use the prep`);
  }
});

test("prepDeck deals the whole catalog", () => {
  const deck = prepDeck();
  assert.equal(deck.length, PREPS.length);
  assert.equal(new Set(deck.map((p) => p.prep)).size, PREPS.length);
});
