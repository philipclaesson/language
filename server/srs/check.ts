// German answer matching. This is the highest-bug-risk piece of the app, so it
// lives in one pure, well-tested function.

import { normalizeAnswer } from "../../shared/normalize";
import { withinEdits } from "./distance";
import type { Grade, MissReason } from "../../shared/types";

export type CheckCard = {
  answer: string; // for nouns: the bare noun (e.g. "Hund"); otherwise the full word
  answerAlts?: string[]; // accepted synonyms, always stored bare (no article)
  partOfSpeech?: string | null;
  article?: string | null; // der/die/das for nouns
};

export type CheckOptions = {
  umlautTolerant?: boolean; // accept ae/oe/ue/ss for ä/ö/ü/ß. Default: true
  requireArticle?: boolean; // nouns must include the article. Default: true
};

export type CheckResult = {
  correct: boolean; // exact match — i.e. grade === "pass"
  // Three-step verdict for FSRS (see shared/types.ts). A "near" answer is still
  // not `correct`: it must be re-drilled and doesn't complete the day. It only
  // buys a gentler FSRS grade (Hard instead of Again).
  grade: Grade;
  reason?: MissReason;
  expected: string; // full canonical answer shown to the user afterwards
};

// The single normalization implementation lives in shared/normalize.ts, so the
// server (words + verbs) and the client-side drill re-type all judge typing
// identically. Aliased here for the local call sites below.
const normalize = normalizeAnswer;

// ---- Near-miss (typo) budget ----
//
// One edit, and only on answers of at least this many characters. The length floor
// is what keeps it strict: at 4 letters a single edit is usually a *different
// German word* (Hund/Hand, Bein/Wein, Tag/Tal), which we must not forgive. Measured
// on the answer CORE — the noun without its article — so a short noun can't borrow
// length from "der " to earn leniency.
export const TYPO_MAX_EDITS = 1;
export const TYPO_MIN_LENGTH = 5;

const ARTICLES = new Set(["der", "die", "das"]);

/** The full canonical answer, with article for nouns: "der Hund". */
export function fullAnswer(card: CheckCard): string {
  return card.article ? `${card.article} ${card.answer}` : card.answer;
}

/**
 * Split a leading der/die/das off an already-normalized string. `article` is null
 * when the string doesn't start with one (so "die Hund" → {die, "hund"}, but
 * "hund" → {null, "hund"}).
 */
function splitArticle(typedN: string): { article: string | null; rest: string } {
  const sp = typedN.indexOf(" ");
  if (sp === -1) return { article: null, rest: typedN };
  const head = typedN.slice(0, sp);
  if (!ARTICLES.has(head)) return { article: null, rest: typedN };
  return { article: head, rest: typedN.slice(sp + 1) };
}

/** A single-letter slip on a long-enough answer — not a different word. */
function isTypo(expectedCore: string, typedCore: string): boolean {
  if (typedCore.length === 0) return false;
  if (Math.max(expectedCore.length, typedCore.length) < TYPO_MIN_LENGTH) return false;
  return withinEdits(expectedCore, typedCore, TYPO_MAX_EDITS);
}

/**
 * Grade a typed answer. Beyond exact/wrong there are three **near misses**, each
 * worth a softer FSRS grade because they mean "knows the word, missed one thing":
 *
 *  - `missing_article` — the bare noun, no article ("Hund" for "der Hund");
 *  - `wrong_article`   — right noun, wrong gender ("die Hund");
 *  - `typo`            — a single-letter slip ("laufeb" for "laufen").
 *
 * There is **one error budget**: a near miss is one mistake and no more, so a
 * wrong article *plus* a typo ("die Hond") is a plain fail. Article errors and
 * typos are judged on the answer core (the noun without its article) so neither
 * can be paid for out of the other's budget.
 */
export function checkAnswer(
  card: CheckCard,
  typed: string,
  opts: CheckOptions = {},
): CheckResult {
  const tolerant = opts.umlautTolerant ?? true;
  const requireArticle = opts.requireArticle ?? true;
  const expected = fullAnswer(card);

  const typedN = normalize(typed, tolerant);
  const alts = card.answerAlts ?? [];

  const accepted = new Set<string>();
  accepted.add(normalize(expected, tolerant));
  for (const alt of alts) accepted.add(normalize(alt, tolerant));

  if (typedN.length > 0 && accepted.has(typedN)) {
    return { correct: true, grade: "pass", expected };
  }

  // The answer *core* — the word without its article — plus the (already bare) alts.
  // For a non-noun the core is simply the whole answer.
  const mainCore = normalize(card.answer, tolerant);
  const altCores = alts.map((a) => normalize(a, tolerant));
  const isNoun = card.partOfSpeech === "noun" && !!card.article;

  // Nouns: peel off the article first, so we can tell a gender error from a
  // spelling error and charge for exactly one of them.
  if (isNoun) {
    const { article, rest } = splitArticle(typedN);

    // An accepted synonym, written bare or with any article. We only know the
    // article of the card's *own* answer, so an alt's article isn't ours to judge.
    if (rest.length > 0 && altCores.includes(rest)) {
      return { correct: true, grade: "pass", expected };
    }

    if (rest === mainCore) {
      // Right noun; only the article is in question.
      if (!requireArticle) return { correct: true, grade: "pass", expected };
      return article === null
        ? { correct: false, grade: "near", reason: "missing_article", expected }
        : // An article that *matched* would have been an exact match above.
          { correct: false, grade: "near", reason: "wrong_article", expected };
    }

    // Not the right noun. A typo is forgivable only when the article was right
    // (or isn't required) — one mistake, not two.
    const articleOk = !requireArticle || article === normalize(card.article!, tolerant);
    if (articleOk && [mainCore, ...altCores].some((core) => isTypo(core, rest))) {
      return { correct: false, grade: "near", reason: "typo", expected };
    }
    return { correct: false, grade: "fail", reason: "wrong", expected };
  }

  if ([mainCore, ...altCores].some((core) => isTypo(core, typedN))) {
    return { correct: false, grade: "near", reason: "typo", expected };
  }

  return { correct: false, grade: "fail", reason: "wrong", expected };
}
