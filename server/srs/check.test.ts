import { test } from "node:test";
import assert from "node:assert/strict";
import { checkAnswer, fullAnswer } from "./check.ts";

const hund = { answer: "Hund", article: "der", partOfSpeech: "noun" };
const gehen = { answer: "gehen", partOfSpeech: "verb" };

test("exact noun with article is correct", () => {
  assert.equal(checkAnswer(hund, "der Hund").correct, true);
});

test("case and whitespace are ignored", () => {
  assert.equal(checkAnswer(hund, "  DER   hund ").correct, true);
});

test("noun without article is a missing_article miss (default)", () => {
  const r = checkAnswer(hund, "Hund");
  assert.equal(r.correct, false);
  assert.equal(r.reason, "missing_article");
});

test("noun without article accepted when requireArticle is off", () => {
  assert.equal(checkAnswer(hund, "Hund", { requireArticle: false }).correct, true);
});

test("wrong article is just wrong", () => {
  const r = checkAnswer(hund, "die Hund");
  assert.equal(r.correct, false);
  assert.equal(r.reason, "wrong");
});

test("umlaut tolerance: ue accepted for ü", () => {
  const tuer = { answer: "Tür", article: "die", partOfSpeech: "noun" };
  assert.equal(checkAnswer(tuer, "die Tuer").correct, true);
  assert.equal(checkAnswer(tuer, "die Tür").correct, true);
});

test("umlaut tolerance: ss accepted for ß", () => {
  const strasse = { answer: "Straße", article: "die", partOfSpeech: "noun" };
  assert.equal(checkAnswer(strasse, "die Strasse").correct, true);
});

test("strict mode rejects ue for ü", () => {
  const tuer = { answer: "Tür", article: "die", partOfSpeech: "noun" };
  assert.equal(checkAnswer(tuer, "die Tuer", { umlautTolerant: false }).correct, false);
});

test("answerAlts are accepted", () => {
  const card = { answer: "Auto", article: "das", partOfSpeech: "noun", answerAlts: ["der Wagen"] };
  assert.equal(checkAnswer(card, "der Wagen").correct, true);
});

test("non-noun word matches exactly", () => {
  assert.equal(checkAnswer(gehen, "gehen").correct, true);
  assert.equal(checkAnswer(gehen, "laufen").correct, false);
});

test("empty input is wrong, not a crash", () => {
  assert.equal(checkAnswer(hund, "").correct, false);
  assert.equal(checkAnswer(gehen, "   ").correct, false);
});

test("fullAnswer composes article for nouns", () => {
  assert.equal(fullAnswer(hund), "der Hund");
  assert.equal(fullAnswer(gehen), "gehen");
});
