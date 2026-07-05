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

test("extractAnswer strips parenthetical declension endings", () => {
  // "(r, s)" is a comma-containing paren group — must be dropped before the comma
  // split, else it broke to "andere (r" (the reported bug).
  assert.equal(extractAnswer("andere (r, s)"), "andere");
  assert.equal(extractAnswer("jede (r, s)"), "jede");
  assert.equal(extractAnswer("final (er, e, es)"), "final");
});

test("extractAnswer strips an abbreviation's expansion in parens", () => {
  assert.equal(extractAnswer("USA (Vereinigte Staaten von Amerika)"), "USA");
  // The expansion itself contains a comma — previously broke to "DNA (DNS".
  assert.equal(extractAnswer("DNA (DNS, Desoxyribonukleinsäure)"), "DNA");
});

test("extractAnswer strips the reflexive marker and principal parts", () => {
  assert.equal(extractAnswer("befinden (sich), befindet, befand, hat befunden"), "befinden");
});

test("parseNote gives reflexive verbs a 'sich' citation form + bare alt", () => {
  const w = parseNote({
    rank: "464",
    word: "befinden (sich), befindet, befand, hat befunden",
    pos1: "verb",
    def1: "to be",
    de1: "Wo befindet sich der Bahnhof?",
    en1: "Where is the train station?",
  });
  assert.equal(w.answer, "sich befinden");
  assert.deepEqual(w.answerAlts, ["befinden"]);
  assert.equal(w.partOfSpeech, "verb");
});

test("parseNote cleans a declined pronoun/adjective headword", () => {
  const w = parseNote({
    rank: "59",
    word: "andere (r, s)",
    pos1: "pron",
    def1: "other",
    de1: "Das ist eine andere Frage.",
    en1: "That is another question.",
  });
  assert.equal(w.answer, "andere");
  assert.deepEqual(w.answerAlts, []);
  assert.equal(w.partOfSpeech, "pronoun");
});

test("parseNote cleans an abbreviation headword (comma inside the paren)", () => {
  const w = parseNote({
    rank: "1777",
    word: "DNA (DNS, Desoxyribonukleinsäure)",
    pos1: "die",
    def1: "DNA, deoxyribonucleic acid",
    de1: "Die DNA trägt die Erbinformation.",
    en1: "DNA carries the genetic information.",
  });
  assert.equal(w.answer, "DNA");
  assert.equal(w.article, "die");
  assert.equal(w.partOfSpeech, "noun");
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
