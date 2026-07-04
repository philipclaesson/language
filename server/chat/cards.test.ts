import { test } from "node:test";
import assert from "node:assert/strict";
import { normalizeCardInput } from "./cards.ts";

test("noun with explicit article field stays bare", () => {
  const c = normalizeCardInput({
    prompt: "the dog",
    answer: "Hund",
    article: "der",
    part_of_speech: "noun",
  });
  assert.equal(c.answer, "Hund");
  assert.equal(c.article, "der");
  assert.equal(c.partOfSpeech, "noun");
});

test("article embedded in the answer is split out", () => {
  const c = normalizeCardInput({ prompt: "the dog", answer: "der Hund", part_of_speech: "noun" });
  assert.equal(c.answer, "Hund");
  assert.equal(c.article, "der");
});

test("embedded article infers noun when part of speech is missing", () => {
  const c = normalizeCardInput({ prompt: "the cat", answer: "die Katze" });
  assert.equal(c.answer, "Katze");
  assert.equal(c.article, "die");
  assert.equal(c.partOfSpeech, "noun");
});

test("verbs carry no article", () => {
  const c = normalizeCardInput({ prompt: "to go", answer: "gehen", part_of_speech: "verb" });
  assert.equal(c.answer, "gehen");
  assert.equal(c.article, null);
  assert.equal(c.partOfSpeech, "verb");
});

test("case-marked articles like 'den' are rejected", () => {
  const c = normalizeCardInput({ prompt: "x", answer: "Tisch", article: "den", part_of_speech: "noun" });
  assert.equal(c.article, null);
});

test("an article on an explicit non-noun is dropped, not coerced", () => {
  const c = normalizeCardInput({ prompt: "good", answer: "gut", article: "der", part_of_speech: "adjective" });
  assert.equal(c.article, null);
  assert.equal(c.partOfSpeech, "adjective");
});

test("answer_alts are de-articled, de-duped, and never echo the bare answer", () => {
  const c = normalizeCardInput({
    prompt: "the car",
    answer: "das Auto",
    answer_alts: ["Auto", "der Wagen", "Wagen", "  "],
  });
  assert.equal(c.answer, "Auto");
  assert.deepEqual(c.answerAlts, ["Wagen"]);
});

test("whitespace is trimmed", () => {
  const c = normalizeCardInput({ prompt: "  the house ", answer: "  Haus ", article: " das " });
  assert.equal(c.prompt, "the house");
  assert.equal(c.answer, "Haus");
  assert.equal(c.article, "das");
});

test("missing prompt or answer throws", () => {
  assert.throws(() => normalizeCardInput({ answer: "Hund" }));
  assert.throws(() => normalizeCardInput({ prompt: "the dog" }));
});

test("notes and example fields default to null", () => {
  const c = normalizeCardInput({ prompt: "today", answer: "heute" });
  assert.equal(c.notes, null);
  assert.equal(c.exampleEn, null);
  assert.equal(c.exampleDe, null);
});

test("example sentences are trimmed and kept", () => {
  const c = normalizeCardInput({
    prompt: "well",
    answer: "wohl",
    example_de: "  Ich fühle mich nicht wohl.  ",
    example_en: "I am not feeling well.",
  });
  assert.equal(c.exampleDe, "Ich fühle mich nicht wohl.");
  assert.equal(c.exampleEn, "I am not feeling well.");
});
