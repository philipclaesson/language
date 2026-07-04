import { test } from "node:test";
import assert from "node:assert/strict";
import { cleanHtml, parseRank, parseGermanEntry, parseNote } from "./words-parse.ts";

test("cleanHtml drops sup footnotes and img, keeps other tag text", () => {
  assert.equal(cleanHtml("das Prinzip <sup>[aus prinzip]</sup>"), "das Prinzip");
  assert.equal(cleanHtml('a <img src="x.png" /> b'), "a b");
  assert.equal(cleanHtml("I study <b>thereby</b> get"), "I study thereby get");
});

test("cleanHtml decodes entities and collapses whitespace", () => {
  assert.equal(cleanHtml("[over]&nbsp;there"), "[over] there");
  assert.equal(cleanHtml("R&amp;D  spread"), "R&D spread");
  assert.equal(cleanHtml("&#39;quote&#39;"), "'quote'");
});

test("parseRank takes the leading integer of messy ranks", () => {
  assert.equal(parseRank("129"), 129);
  assert.equal(parseRank("2500-1"), 2500);
  assert.equal(parseRank("#3001"), 3001);
  assert.equal(parseRank("3000.1"), 3000);
  assert.equal(parseRank(""), null);
});

test("single leading article → gender-tested bare noun", () => {
  const r = parseGermanEntry("der Teil");
  assert.equal(r.article, "der");
  assert.equal(r.answer, "Teil");
  assert.equal(r.partOfSpeech, "noun");
  assert.deepEqual(r.answerAlts, []);
});

test("dual article → noun but no gender test", () => {
  const r = parseGermanEntry("der, die Jugendliche");
  assert.equal(r.article, null);
  assert.equal(r.partOfSpeech, "noun");
  assert.equal(r.answer, "Jugendliche");
});

test("slash article variant collapses to null article", () => {
  const r = parseGermanEntry("der/die Angehörige");
  assert.equal(r.article, null);
  assert.equal(r.partOfSpeech, "noun");
  assert.equal(r.answer, "Angehörige");
});

test("comma alternatives become answerAlts", () => {
  const r = parseGermanEntry("die Universität, Uni");
  assert.equal(r.article, "die");
  assert.equal(r.answer, "Universität");
  assert.deepEqual(r.answerAlts, ["Uni"]);
});

test("non-noun entry: no article, no part of speech, alternatives kept", () => {
  const r = parseGermanEntry("darin, drin, drinnen");
  assert.equal(r.article, null);
  assert.equal(r.partOfSpeech, null);
  assert.equal(r.answer, "darin");
  assert.deepEqual(r.answerAlts, ["drin", "drinnen"]);
});

test("form noise (+ pl, parentheticals, stray braces) is stripped", () => {
  assert.equal(parseGermanEntry("der + pl Versager, die Versagen").answer, "Versager");
  assert.equal(parseGermanEntry("das BGB (Bürgerliches Gesetzbuch)").answer, "BGB");
  assert.equal(parseGermanEntry("der PKW { Personenkraftwagen)").answer, "PKW");
});

test("parseNote maps a full noun note", () => {
  const w = parseNote({
    german: "die Seite",
    english: "side, page",
    rank: "50",
    notThisWord: "",
    germanSentence: "Die andere <b>Seite</b>.",
    englishSentence: "The other side.",
  });
  assert.equal(w.prompt, "side, page");
  assert.equal(w.answer, "Seite");
  assert.equal(w.article, "die");
  assert.equal(w.partOfSpeech, "noun");
  assert.equal(w.frequencyRank, 50);
  assert.equal(w.exampleDe, "Die andere Seite.");
  assert.equal(w.exampleEn, "The other side.");
  assert.equal(w.notes, null);
});

test("parseNote appends the NotThisWord disambiguation hint to the prompt", () => {
  const w = parseNote({
    german: "gerade",
    english: "just, right now",
    rank: "80",
    notThisWord: "straight",
    germanSentence: "",
    englishSentence: "",
  });
  assert.equal(w.prompt, "just, right now (not: straight)");
  assert.equal(w.exampleDe, null);
  assert.equal(w.exampleEn, null);
  assert.equal(w.notes, null);
});
