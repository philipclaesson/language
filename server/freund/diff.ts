// Word-level diff of a learner's sentence against its corrected form. Freund's
// model returns only the corrected sentence; we compute the diff here so the model
// never has to emit (and never mangles) the strike/emphasis markup. Pure + tested:
// the rendering downstream trusts these segments verbatim.
import type { CorrectionOp, CorrectionSegment } from "../../shared/types";

// Split on whitespace into word tokens. Punctuation rides along with its word
// ("müde." is one token) — word-level granularity reads well for short sentences
// and keeps the diff simple. Empty input → no tokens.
function tokenize(s: string): string[] {
  const t = s.trim();
  return t ? t.split(/\s+/) : [];
}

/**
 * A longest-common-subsequence word diff. Returns segments in reading order:
 * `keep` for words common to both, `del` for words only in the original (the
 * learner's mistakes), `ins` for words only in the corrected sentence. Consecutive
 * words with the same op are merged into one segment (joined by single spaces), so
 * the client can render the whole correction by joining segments with spaces.
 *
 * Sentences are short, so the O(n·m) DP table is fine.
 */
export function diffWords(original: string, corrected: string): CorrectionSegment[] {
  const a = tokenize(original);
  const b = tokenize(corrected);
  const n = a.length;
  const m = b.length;

  // lcs[i][j] = length of the LCS of a[i:] and b[j:].
  const lcs: number[][] = Array.from({ length: n + 1 }, () => new Array(m + 1).fill(0));
  for (let i = n - 1; i >= 0; i--) {
    for (let j = m - 1; j >= 0; j--) {
      lcs[i][j] =
        a[i] === b[j]
          ? lcs[i + 1][j + 1] + 1
          : Math.max(lcs[i + 1][j], lcs[i][j + 1]);
    }
  }

  // Walk the table, emitting one (op, word) at a time.
  const ops: { op: CorrectionOp; word: string }[] = [];
  let i = 0;
  let j = 0;
  while (i < n && j < m) {
    if (a[i] === b[j]) {
      ops.push({ op: "keep", word: a[i] });
      i++;
      j++;
    } else if (lcs[i + 1][j] >= lcs[i][j + 1]) {
      ops.push({ op: "del", word: a[i] });
      i++;
    } else {
      ops.push({ op: "ins", word: b[j] });
      j++;
    }
  }
  while (i < n) ops.push({ op: "del", word: a[i++] });
  while (j < m) ops.push({ op: "ins", word: b[j++] });

  // Merge consecutive same-op words into runs.
  const segments: CorrectionSegment[] = [];
  for (const { op, word } of ops) {
    const last = segments[segments.length - 1];
    if (last && last.op === op) last.text += ` ${word}`;
    else segments.push({ op, text: word });
  }
  return segments;
}
