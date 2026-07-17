// The single source of truth for how a typed German answer is normalized before
// it's compared to the expected answer. Shared by the client and the server so
// the *first* attempt (graded on the server) and the *re-type* after a miss
// (checked on the client in the drill) judge typing identically — for both words
// (server/srs/check.ts) and verbs (server/verbs/check.ts, web/src/verbs.tsx).
//
// Pure, no I/O — unit-tested in normalize.test.ts.

/**
 * Normalize a typed answer for comparison:
 *  - Unicode NFC, trim, case-fold, collapse internal whitespace.
 *  - Strip trailing `.` / `,` (and any whitespace around them): a stray comma or
 *    full stop should never turn a right answer into a wrong one.
 *  - When `tolerant` (the default), accept ae/oe/ue/ss for ä/ö/ü/ß.
 */
export function normalizeAnswer(s: string, tolerant = true): string {
  let t = s
    .normalize("NFC")
    .trim()
    .toLowerCase()
    // Drop trailing dots/commas plus any whitespace around them ("der Hund." →
    // "der hund", "gehen ," → "gehen"). Only trailing — internal punctuation is
    // left alone.
    .replace(/[\s.,]+$/, "")
    .replace(/\s+/g, " ");
  if (tolerant) {
    t = t
      .replace(/ä/g, "ae")
      .replace(/ö/g, "oe")
      .replace(/ü/g, "ue")
      .replace(/ß/g, "ss");
  }
  return t;
}
