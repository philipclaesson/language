// German answer matching. This is the highest-bug-risk piece of the app, so it
// lives in one pure, well-tested function.

import { normalizeAnswer } from "../../shared/normalize";

export type CheckCard = {
  answer: string; // for nouns: the bare noun (e.g. "Hund"); otherwise the full word
  answerAlts?: string[];
  partOfSpeech?: string | null;
  article?: string | null; // der/die/das for nouns
};

export type CheckOptions = {
  umlautTolerant?: boolean; // accept ae/oe/ue/ss for ä/ö/ü/ß. Default: true
  requireArticle?: boolean; // nouns must include the article. Default: true
};

export type CheckResult = {
  correct: boolean;
  reason?: "missing_article" | "wrong";
  expected: string; // full canonical answer shown to the user afterwards
};

// The single normalization implementation lives in shared/normalize.ts, so the
// server (words + verbs) and the client-side drill re-type all judge typing
// identically. Aliased here for the local call sites below.
const normalize = normalizeAnswer;

/** The full canonical answer, with article for nouns: "der Hund". */
export function fullAnswer(card: CheckCard): string {
  return card.article ? `${card.article} ${card.answer}` : card.answer;
}

export function checkAnswer(
  card: CheckCard,
  typed: string,
  opts: CheckOptions = {},
): CheckResult {
  const tolerant = opts.umlautTolerant ?? true;
  const requireArticle = opts.requireArticle ?? true;
  const expected = fullAnswer(card);

  const typedN = normalize(typed, tolerant);

  const accepted = new Set<string>();
  accepted.add(normalize(expected, tolerant));
  for (const alt of card.answerAlts ?? []) accepted.add(normalize(alt, tolerant));

  if (typedN.length > 0 && accepted.has(typedN)) {
    return { correct: true, expected };
  }

  // Noun typed without its article: a near-miss we treat specially.
  const isNoun = card.partOfSpeech === "noun" && !!card.article;
  if (isNoun) {
    const bare = normalize(card.answer, tolerant);
    if (typedN.length > 0 && typedN === bare) {
      return requireArticle
        ? { correct: false, reason: "missing_article", expected }
        : { correct: true, expected };
    }
  }

  return { correct: false, reason: "wrong", expected };
}
