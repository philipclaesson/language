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

// Matching key for two tokens: lowercase and strip everything that isn't a letter
// or digit. Two tokens with the same key differ ONLY in capitalization and/or
// punctuation ("Hallo" ≈ "Hallo," , "handy" ≈ "Handy") — noise we don't want the
// diff to highlight, so they're treated as unchanged. Letters (umlauts included)
// are preserved, so a real spelling fix ("muede" → "müde") still shows as a change.
function matchKey(token: string): string {
  return token.toLowerCase().replace(/[^\p{L}\p{N}]/gu, "");
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
  // Compare on the punctuation/case-insensitive key, so a word whose only fix is
  // capitalization or punctuation counts as unchanged (see matchKey).
  const ka = a.map(matchKey);
  const kb = b.map(matchKey);
  const n = a.length;
  const m = b.length;

  // lcs[i][j] = length of the LCS of a[i:] and b[j:].
  const lcs: number[][] = Array.from({ length: n + 1 }, () => new Array(m + 1).fill(0));
  for (let i = n - 1; i >= 0; i--) {
    for (let j = m - 1; j >= 0; j--) {
      lcs[i][j] =
        ka[i] === kb[j]
          ? lcs[i + 1][j + 1] + 1
          : Math.max(lcs[i + 1][j], lcs[i][j + 1]);
    }
  }

  // Walk the table, emitting one (op, word) at a time. On a keep we emit the
  // CORRECTED token (b[j]), so a silent capitalization/punctuation fix still lands
  // in the rendered sentence — it just isn't marked up.
  const ops: { op: CorrectionOp; word: string }[] = [];
  let i = 0;
  let j = 0;
  while (i < n && j < m) {
    if (ka[i] === kb[j]) {
      ops.push({ op: "keep", word: b[j] });
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
