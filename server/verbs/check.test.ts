import { test } from "node:test";
import assert from "node:assert/strict";
import { checkConjugation } from "./check";
import type { Conjugation } from "../../shared/types";

const gehen: Conjugation = {
  ich: "gehe",
  du: "gehst",
  er: "geht",
  wir: "gehen",
  ihr: "geht",
  sie: "gehen",
};

test("all six correct → pass", () => {
  const r = checkConjugation(gehen, { ...gehen });
  assert.equal(r.correct, true);
  assert.deepEqual(r.perForm, { ich: true, du: true, er: true, wir: true, ihr: true, sie: true });
});

test("one wrong form fails the whole card (all-or-nothing)", () => {
  const r = checkConjugation(gehen, { ...gehen, du: "geht" });
  assert.equal(r.correct, false);
  assert.equal(r.perForm.du, false);
  assert.equal(r.perForm.ich, true); // the rest still marked right, for highlighting
});

test("empty forms fail", () => {
  const r = checkConjugation(gehen, { ich: "gehe" });
  assert.equal(r.correct, false);
  assert.equal(r.perForm.du, false);
});

test("umlaut/ß tolerant by default", () => {
  const fahren: Conjugation = {
    ich: "fahre",
    du: "faehrst", // ä typed as ae
    er: "faehrt",
    wir: "fahren",
    ihr: "fahrt",
    sie: "fahren",
  };
  const expected: Conjugation = { ...fahren, du: "fährst", er: "fährt" };
  assert.equal(checkConjugation(expected, fahren).correct, true);
});

test("case and surrounding whitespace ignored", () => {
  const typed = { ich: " Gehe ", du: "GEHST", er: "geht", wir: "gehen", ihr: "geht", sie: "gehen" };
  assert.equal(checkConjugation(gehen, typed).correct, true);
});

test("strict mode rejects ae for ä", () => {
  const expected: Conjugation = { ...gehen, du: "gähst" };
  const typed = { ...gehen, du: "gaehst" };
  assert.equal(checkConjugation(expected, typed, { umlautTolerant: false }).correct, false);
});
