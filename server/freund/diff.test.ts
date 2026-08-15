import { test } from "node:test";
import assert from "node:assert/strict";
import { diffWords } from "./diff";

test("identical sentences are all kept", () => {
  assert.deepEqual(diffWords("Ich bin müde", "Ich bin müde"), [
    { op: "keep", text: "Ich bin müde" },
  ]);
});

test("a substituted word becomes del then ins, flanked by keeps", () => {
  assert.deepEqual(diffWords("Ich ist müde", "Ich bin müde"), [
    { op: "keep", text: "Ich" },
    { op: "del", text: "ist" },
    { op: "ins", text: "bin" },
    { op: "keep", text: "müde" },
  ]);
});

test("a missing word is a pure insertion", () => {
  assert.deepEqual(diffWords("Ich müde", "Ich bin müde"), [
    { op: "keep", text: "Ich" },
    { op: "ins", text: "bin" },
    { op: "keep", text: "müde" },
  ]);
});

test("an extra word is a pure deletion", () => {
  assert.deepEqual(diffWords("Ich bin sehr müde", "Ich bin müde"), [
    { op: "keep", text: "Ich bin" },
    { op: "del", text: "sehr" },
    { op: "keep", text: "müde" },
  ]);
});

test("consecutive changes merge into runs", () => {
  assert.deepEqual(diffWords("Ich gehe zur Schule", "Wir fahren zur Schule"), [
    { op: "del", text: "Ich gehe" },
    { op: "ins", text: "Wir fahren" },
    { op: "keep", text: "zur Schule" },
  ]);
});

test("whitespace is normalized before diffing", () => {
  assert.deepEqual(diffWords("  Ich   bin  müde ", "Ich bin müde"), [
    { op: "keep", text: "Ich bin müde" },
  ]);
});

test("empty original yields a single insertion", () => {
  assert.deepEqual(diffWords("", "Guten Tag"), [{ op: "ins", text: "Guten Tag" }]);
});

test("a completely different correction is del then ins", () => {
  assert.deepEqual(diffWords("Hallo", "Guten Tag"), [
    { op: "del", text: "Hallo" },
    { op: "ins", text: "Guten Tag" },
  ]);
});

test("a capitalization-only fix is kept silently, showing the corrected form", () => {
  assert.deepEqual(diffWords("ein handy", "ein Handy"), [
    { op: "keep", text: "ein Handy" },
  ]);
});

test("an added-punctuation fix is kept silently, showing the corrected form", () => {
  assert.deepEqual(diffWords("Hallo ich bin da", "Hallo, ich bin da"), [
    { op: "keep", text: "Hallo, ich bin da" },
  ]);
});

test("punctuation/case noise is hidden while the real grammar fix still shows", () => {
  // The screenshot case: only "eine" → "ein" should be marked up.
  assert.deepEqual(
    diffWords("Hallo ich brauche eine neues handy", "Hallo, ich brauche ein neues Handy"),
    [
      { op: "keep", text: "Hallo, ich brauche" },
      { op: "del", text: "eine" },
      { op: "ins", text: "ein" },
      { op: "keep", text: "neues Handy" },
    ],
  );
});

test("a real spelling fix (umlaut) still shows as a change", () => {
  assert.deepEqual(diffWords("Ich bin muede", "Ich bin müde"), [
    { op: "keep", text: "Ich bin" },
    { op: "del", text: "muede" },
    { op: "ins", text: "müde" },
  ]);
});
