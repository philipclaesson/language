import { test } from "node:test";
import assert from "node:assert/strict";
import { normalizeAnswer } from "./normalize.ts";

test("trims, case-folds, and collapses whitespace", () => {
  assert.equal(normalizeAnswer("  Der   Hund "), "der hund");
});

test("umlaut/ß tolerant by default", () => {
  assert.equal(normalizeAnswer("Tür"), normalizeAnswer("Tuer"));
  assert.equal(normalizeAnswer("Straße"), normalizeAnswer("Strasse"));
});

test("tolerance can be turned off", () => {
  assert.notEqual(normalizeAnswer("Tür", false), normalizeAnswer("Tuer", false));
});

test("strips a trailing period", () => {
  assert.equal(normalizeAnswer("der Hund."), normalizeAnswer("der Hund"));
});

test("strips a trailing comma", () => {
  assert.equal(normalizeAnswer("gehen,"), normalizeAnswer("gehen"));
});

test("strips trailing punctuation with surrounding whitespace", () => {
  assert.equal(normalizeAnswer("der Hund . "), "der hund");
  assert.equal(normalizeAnswer("gehen ,"), "gehen");
  assert.equal(normalizeAnswer("das Haus.,"), "das haus");
});

test("leaves internal punctuation alone", () => {
  assert.equal(normalizeAnswer("z.B."), "z.b");
});
