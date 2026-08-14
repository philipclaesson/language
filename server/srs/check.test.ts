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

test("wrong article on the right noun is a near miss", () => {
  const r = checkAnswer(hund, "die Hund");
  assert.equal(r.correct, false);
  assert.equal(r.grade, "near");
  assert.equal(r.reason, "wrong_article");
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

test("trailing period/comma is ignored", () => {
  assert.equal(checkAnswer(hund, "der Hund.").correct, true);
  assert.equal(checkAnswer(hund, "der Hund, ").correct, true);
  assert.equal(checkAnswer(gehen, "gehen.").correct, true);
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

// ---- Near misses (grade "near": right word, one thing off) ----

test("an exact answer grades pass", () => {
  const r = checkAnswer(hund, "der Hund");
  assert.equal(r.grade, "pass");
  assert.equal(r.reason, undefined);
});

test("missing article grades near, not fail", () => {
  assert.equal(checkAnswer(hund, "Hund").grade, "near");
});

test("a single-letter slip on a long enough word is a typo near miss", () => {
  const bzw = { answer: "beziehungsweise", partOfSpeech: "adverb" };
  const laufen = { answer: "laufen", partOfSpeech: "verb" };
  const katze = { answer: "Katze", article: "die", partOfSpeech: "noun" };

  // Adjacent transposition ("ie" typed as "ei").
  const t = checkAnswer(bzw, "bezeihungsweise");
  assert.equal(t.grade, "near");
  assert.equal(t.reason, "typo");
  // Neighbouring key (b for n).
  assert.equal(checkAnswer(laufen, "laufeb").reason, "typo");
  // A spurious umlaut: normalization expands ä to "ae", so this is one extra letter.
  assert.equal(checkAnswer(katze, "die Kätze").reason, "typo");
  // ...and a missing one, the same way.
  const klinke = { answer: "Türklinke", article: "die", partOfSpeech: "noun" };
  assert.equal(checkAnswer(klinke, "die Turklinke").reason, "typo");
});

test("short words get no typo leniency — one edit there is another word", () => {
  // Hund/Hand, Bein/Wein, Tag/Tal: below TYPO_MIN_LENGTH a single edit is far more
  // likely to be a different German word than a slip of the finger.
  assert.equal(checkAnswer(hund, "der Hand").grade, "fail");
  const bein = { answer: "Bein", article: "das", partOfSpeech: "noun" };
  assert.equal(checkAnswer(bein, "das Wein").grade, "fail");
});

test("one error budget: a wrong article AND a typo is a fail", () => {
  const katze = { answer: "Katze", article: "die", partOfSpeech: "noun" };
  assert.equal(checkAnswer(katze, "die Kätze").grade, "near"); // typo only
  assert.equal(checkAnswer(katze, "der Katze").grade, "near"); // article only
  assert.equal(checkAnswer(katze, "der Kätze").grade, "fail"); // both
  assert.equal(checkAnswer(katze, "Kätze").grade, "fail"); // no article + typo
});

test("two slips is a fail, not a near miss", () => {
  const laufen = { answer: "laufen", partOfSpeech: "verb" };
  const r = checkAnswer(laufen, "laifeb");
  assert.equal(r.grade, "fail");
  assert.equal(r.reason, "wrong");
});

test("a near miss is never counted as correct", () => {
  // The whole design rests on this: "near" softens the FSRS grade but still owes a
  // correct typing today (rating 2 < 3 — see review-routes todayReviewSets).
  for (const typed of ["Hund", "die Hund"]) {
    assert.equal(checkAnswer(hund, typed).correct, false);
  }
});

test("known trade-off: real minimal pairs at 5+ letters get leniency", () => {
  // "legen" (to lay) vs "liegen" (to lie) are different verbs, but they're one edit
  // apart, so the rule forgives them. Documented deliberately: a near miss still
  // reveals the answer, still has to be re-typed, and still lands in today's misses
  // pool — the only thing it softens is the multi-day schedule. Revisit by querying
  // `reviews` for rating = 2 if this turns out to flatter us too often.
  const liegen = { answer: "liegen", partOfSpeech: "verb" };
  assert.equal(checkAnswer(liegen, "legen").grade, "near");
});

test("garbage and blanks stay plain fails", () => {
  assert.equal(checkAnswer(hund, "xyz").grade, "fail");
  assert.equal(checkAnswer(hund, "").grade, "fail");
  assert.equal(checkAnswer(gehen, "   ").grade, "fail");
  assert.equal(checkAnswer(hund, "der").grade, "fail"); // article alone
});

test("requireArticle off still passes a bare noun and forgives its article", () => {
  assert.equal(checkAnswer(hund, "Hund", { requireArticle: false }).grade, "pass");
  assert.equal(checkAnswer(hund, "die Hund", { requireArticle: false }).grade, "pass");
});

test("an alt's article is not ours to judge, but its spelling is", () => {
  const auto = {
    answer: "Auto",
    article: "das",
    partOfSpeech: "noun",
    answerAlts: ["Wagen"],
  };
  // Alts are stored bare, so we don't know their gender ("Wagen" is der, not das).
  // Any article — or none — is accepted on an alt; only the card's own answer gets
  // its article checked.
  assert.equal(checkAnswer(auto, "Wagen").grade, "pass");
  assert.equal(checkAnswer(auto, "das Wagen").grade, "pass");
  assert.equal(checkAnswer(auto, "der Wagen").grade, "pass");
  // Spelling is still judged, against the card's own article.
  assert.equal(checkAnswer(auto, "das Wagon").reason, "typo");
});

test("fullAnswer composes article for nouns", () => {
  assert.equal(fullAnswer(hund), "der Hund");
  assert.equal(fullAnswer(gehen), "gehen");
});
