import { test } from "node:test";
import assert from "node:assert/strict";
import { cleanHtml, parseRank, parsePos, extractAnswer, parseNote } from "./words-parse.ts";

test("cleanHtml drops tags, sound refs, entities and collapses whitespace", () => {
  assert.equal(cleanHtml("a <b>bold</b>  word"), "a bold word");
  assert.equal(cleanHtml("hallo [sound:x.mp3]"), "hallo");
  assert.equal(cleanHtml("R&amp;D  spread"), "R&D spread");
  assert.equal(cleanHtml("&#39;quote&#39;"), "'quote'");
});

test("parseRank takes the leading integer", () => {
  assert.equal(parseRank("53"), 53);
  assert.equal(parseRank(""), null);
});

test("noun POS field is the article → gender-tested noun", () => {
  assert.deepEqual(parsePos("das"), { article: "das", partOfSpeech: "noun" });
  assert.deepEqual(parsePos("der"), { article: "der", partOfSpeech: "noun" });
});

test("ambiguous / plural-only noun POS → noun but no gender test", () => {
  assert.deepEqual(parsePos("der, die"), { article: null, partOfSpeech: "noun" });
  assert.deepEqual(parsePos("die (pl)"), { article: null, partOfSpeech: "noun" });
  assert.deepEqual(parsePos("der, die, das"), { article: null, partOfSpeech: "noun" });
});

test("non-noun POS codes map to readable labels", () => {
  assert.equal(parsePos("verb").partOfSpeech, "verb");
  assert.equal(parsePos("adj").partOfSpeech, "adjective");
  assert.equal(parsePos("adv").partOfSpeech, "adverb");
  assert.equal(parsePos("prep").partOfSpeech, "preposition");
  assert.equal(parsePos("verb").article, null);
});

test("extractAnswer strips the article and plural marker from nouns", () => {
  assert.equal(extractAnswer("das Jahr, -e"), "Jahr");
  assert.equal(extractAnswer("der Mann, -̈er"), "Mann");
  assert.equal(extractAnswer("Mal"), "Mal");
});

test("extractAnswer reduces a verb to its infinitive", () => {
  assert.equal(extractAnswer("sein, ist, war, ist gewesen"), "sein");
  assert.equal(extractAnswer("haben, hat, hatte, hat gehabt"), "haben");
});

test("parseNote maps a full noun note (sense 1)", () => {
  const w = parseNote({
    rank: "53",
    word: "das Jahr, -e",
    pos1: "das",
    def1: "year",
    de1: "Das Jahr hat zwölf Monate.",
    en1: "The year has twelve months.",
  });
  assert.equal(w.prompt, "year");
  assert.equal(w.answer, "Jahr");
  assert.equal(w.article, "das");
  assert.equal(w.partOfSpeech, "noun");
  assert.equal(w.frequencyRank, 53);
  assert.deepEqual(w.answerAlts, []);
  assert.equal(w.exampleDe, "Das Jahr hat zwölf Monate.");
  assert.equal(w.exampleEn, "The year has twelve months.");
  assert.equal(w.notes, null);
});

test("parseNote maps a verb note to its infinitive", () => {
  const w = parseNote({
    rank: "4",
    word: "sein, ist, war, ist gewesen",
    pos1: "verb",
    def1: "to be",
    de1: "Ich bin müde.",
    en1: "I am tired.",
  });
  assert.equal(w.prompt, "to be");
  assert.equal(w.answer, "sein");
  assert.equal(w.article, null);
  assert.equal(w.partOfSpeech, "verb");
});
