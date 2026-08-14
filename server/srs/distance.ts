// Damerau-Levenshtein edit distance, used by srs/check.ts to tell a single-letter
// slip ("laufeb" for "laufen") from a genuinely wrong answer. Pure, no I/O.
//
// This is the *optimal string alignment* variant: insertions, deletions,
// substitutions and swaps of ADJACENT characters each cost 1. The adjacent-swap
// rule is the reason we don't use plain Levenshtein — the most common German
// mistype is a transposition ("bezeihungsweise" for "beziehungsweise"), which
// Levenshtein scores as 2 edits and would therefore never forgive.
//
// Inputs are expected to be already normalized (shared/normalize.ts), so casing
// and umlaut spelling are settled before we count letters.

/** Edit distance between `a` and `b` (adjacent swaps cost 1). */
export function editDistance(a: string, b: string): number {
  if (a === b) return 0;
  if (a.length === 0) return b.length;
  if (b.length === 0) return a.length;

  // Two-row DP would do for plain Levenshtein, but transpositions need the row
  // before last, so we keep three.
  let prev2: number[] = [];
  let prev: number[] = Array.from({ length: b.length + 1 }, (_, j) => j);
  let cur: number[] = [];

  for (let i = 1; i <= a.length; i++) {
    cur = new Array(b.length + 1);
    cur[0] = i;
    for (let j = 1; j <= b.length; j++) {
      const cost = a[i - 1] === b[j - 1] ? 0 : 1;
      let d = Math.min(
        cur[j - 1] + 1, // insertion
        prev[j] + 1, // deletion
        prev[j - 1] + cost, // substitution
      );
      // Adjacent transposition ("ie" typed as "ei").
      if (i > 1 && j > 1 && a[i - 1] === b[j - 2] && a[i - 2] === b[j - 1]) {
        d = Math.min(d, prev2[j - 2] + 1);
      }
      cur[j] = d;
    }
    prev2 = prev;
    prev = cur;
  }

  return prev[b.length];
}

/**
 * Whether `a` and `b` are within `max` edits. Bails early on the length gap
 * (which is a lower bound on the distance) before running the DP.
 */
export function withinEdits(a: string, b: string, max: number): boolean {
  if (Math.abs(a.length - b.length) > max) return false;
  return editDistance(a, b) <= max;
}
