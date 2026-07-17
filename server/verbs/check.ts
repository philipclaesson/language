// Verb conjugation matching (VERBS.md). All-or-nothing: a card passes only if all
// six present-tense forms match. Reuses the shared normalization
// (shared/normalize.ts: trim, collapse whitespace, case-fold, strip trailing
// punctuation, umlaut/ß tolerance) so verbs and words judge typing identically.

import { normalizeAnswer } from "../../shared/normalize";
import { VERB_FORMS, type Conjugation, type VerbForm } from "../../shared/types";

export type ConjugationCheckOptions = {
  umlautTolerant?: boolean; // accept ae/oe/ue/ss for ä/ö/ü/ß. Default: true
};

export type ConjugationCheckResult = {
  correct: boolean; // every form matched
  perForm: Record<VerbForm, boolean>; // per-row correctness (for highlighting)
  expected: Conjugation; // echoed back so the route can reveal it on a miss
};

export function checkConjugation(
  expected: Conjugation,
  typed: Partial<Conjugation>,
  opts: ConjugationCheckOptions = {},
): ConjugationCheckResult {
  const tolerant = opts.umlautTolerant ?? true;

  const perForm = {} as Record<VerbForm, boolean>;
  let correct = true;
  for (const form of VERB_FORMS) {
    const want = normalizeAnswer(expected[form] ?? "", tolerant);
    const got = normalizeAnswer(typed[form] ?? "", tolerant);
    // A non-empty match is required; an empty expected form (shouldn't happen for
    // a seeded verb) never counts as correct.
    const ok = got.length > 0 && got === want;
    perForm[form] = ok;
    if (!ok) correct = false;
  }

  return { correct, perForm, expected };
}
