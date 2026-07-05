// Pure parsing rules for the frequency word corpus. The corpus is imported once
// from an Anki deck ("English-Deutsch (Sorted by Frequency)", ~5,000 notes) via the
// generator (scripts/gen-words.ts). Each note carries a German headword, its English
// meaning, part-of-speech, and a natural example sentence with translation. These
// functions turn one raw note into a clean `cards`-shaped row; they run offline in
// the generator, never at request time, but hold all the edge-case rules so they
// live here, tested, rather than buried in a script.

// The note fields we keep (the model has three senses + IPA/frequency we ignore).
// We use only sense 1 — the primary, most-frequent meaning — as one card per note.
export type RawNote = {
  rank: string; // "53" — 1-based frequency order; the new-card introduction order
  word: string; // German headword: "das Jahr, -e" | "sein, ist, war, ist gewesen" | "gut"
  pos1: string; // sense-1 part of speech; for NOUNS this is the article: "der"/"die"/"das"
  def1: string; // sense-1 English meaning — the prompt
  de1: string; // sense-1 German example sentence
  en1: string; // sense-1 English translation of the sentence
};

// A parsed word, shaped for a `cards` insert (deckId/source added by the caller).
export type ParsedWord = {
  prompt: string; // English
  answer: string; // bare German (noun without article; verb infinitive)
  answerAlts: string[]; // alternative surface forms (unused by this deck — always [])
  article: string | null; // der/die/das when unambiguous, else null
  partOfSpeech: string | null; // "noun" | "verb" | "adjective" | … for display; drives noun checking
  notes: string | null; // free-form note / mnemonic (unused by the corpus — always null here)
  exampleEn: string | null; // English gloss of the sample sentence (context, safe pre-answer)
  exampleDe: string | null; // German sample sentence (embeds the answer; shown on a miss)
  frequencyRank: number | null; // lower = more frequent; new-card order
};

const ARTICLES = new Set(["der", "die", "das"]);

// Map the deck's terse POS codes to readable labels (shown above the prompt). Nouns
// are handled separately (their POS field holds the article). Unknown codes pass
// through as-is.
const POS_LABELS: Record<string, string> = {
  verb: "verb",
  adj: "adjective",
  adv: "adverb",
  conj: "conjunction",
  prep: "preposition",
  pron: "pronoun",
  art: "article",
  num: "numeral",
  part: "particle",
  interj: "interjection",
};

const ENTITIES: Record<string, string> = {
  "&nbsp;": " ",
  "&amp;": "&",
  "&lt;": "<",
  "&gt;": ">",
  "&quot;": '"',
  "&#39;": "'",
  "&shy;": "",
};

/**
 * Strip any light HTML/entities the deck might carry and collapse whitespace. This
 * deck is essentially plain text, but we clean defensively (and to normalise stray
 * tags/entities) exactly as the old importer did.
 */
export function cleanHtml(s: string): string {
  let t = s ?? "";
  t = t.replace(/<sup\b[^>]*>[\s\S]*?<\/sup>/gi, ""); // footnote markers, content and all
  t = t.replace(/<img\b[^>]*>/gi, ""); // any image
  t = t.replace(/\[sound:[^\]]*\]/gi, ""); // Anki audio refs
  t = t.replace(/<\/?(?:div|p|br)\b[^>]*>/gi, " "); // block tags → space (avoid word-merges)
  t = t.replace(/<[^>]+>/g, ""); // inline tags (b, i, span, …) → nothing
  t = t.replace(/&#(\d+);/g, (_, n) => String.fromCodePoint(Number(n)));
  for (const [ent, ch] of Object.entries(ENTITIES)) t = t.split(ent).join(ch);
  return t.replace(/\s+/g, " ").trim();
}

/** First integer in the Rank string ("53" → 53, "" → null). */
export function parseRank(s: string): number | null {
  const m = (s ?? "").match(/\d+/);
  return m ? Number(m[0]) : null;
}

/**
 * Interpret the sense-1 POS field. For nouns it IS the article ("der"/"die"/"das",
 * or a comma list like "der, die" / "die (pl)" for ambiguous / plural-only nouns):
 * a single distinct article is gender-tested; anything ambiguous keeps the noun POS
 * but drops the article. Everything else maps to a readable label.
 */
export function parsePos(pos: string): {
  article: string | null;
  partOfSpeech: string | null;
} {
  const cleaned = pos.trim().toLowerCase();
  const tokens = cleaned.split(/\s*,\s*/).map((t) => t.trim()).filter(Boolean);
  // A token carrying "(pl)" is a PLURAL article marker, not a singular gender, so it
  // never contributes a gender to test — only tokens without it do.
  const genders = tokens.filter((t) => ARTICLES.has(t));
  const isNoun = genders.length > 0 || /\(pl\)/.test(cleaned);

  if (isNoun) {
    const distinct = [...new Set(genders)];
    return { article: distinct.length === 1 ? distinct[0] : null, partOfSpeech: "noun" };
  }
  return { article: null, partOfSpeech: POS_LABELS[cleaned] ?? cleaned ?? null };
}

// Matches the reflexive marker some verb headwords carry, e.g. "befinden (sich)".
const REFLEXIVE = /\(\s*sich\s*\)/i;

/**
 * Reduce a German headword to the bare answer the learner types.
 *
 * Parenthetical groups in the headword are always *supplementary* — declension
 * endings ("andere (r, s)"), abbreviation expansions ("USA (Vereinigte Staaten …)",
 * "DNA (DNS, Desoxyribonukleinsäure)"), or a reflexive marker ("befinden (sich), …").
 * They are never part of the word being typed, and they may themselves contain commas,
 * so we strip them FIRST — before the comma-split, which would otherwise break mid-paren
 * (the "andere (r" / "DNA (DNS" bug).
 *
 * Then we strip a leading article ("das Jahr, -e" → "Jahr, -e") and take the first
 * comma-separated form, which drops the plural marker on nouns ("Jahr, -e" → "Jahr")
 * and the principal parts on verbs ("sein, ist, war, ist gewesen" → "sein").
 */
export function extractAnswer(word: string): string {
  const noParen = word.replace(/\s*\([^)]*\)/g, "");
  const bare = noParen.replace(/^(der|die|das)\s+/i, "");
  return bare.split(",")[0].replace(/\s+/g, " ").trim();
}

/** Turn one raw Anki note into a clean, `cards`-shaped word (sense 1 only). */
export function parseNote(raw: RawNote): ParsedWord {
  const word = cleanHtml(raw.word);
  const { article, partOfSpeech } = parsePos(cleanHtml(raw.pos1));
  const bare = extractAnswer(word);
  // Reflexive verbs get their canonical "sich <verb>" citation form as the answer,
  // with the bare infinitive kept as an accepted alternative so either passes.
  const reflexive = partOfSpeech === "verb" && REFLEXIVE.test(word);
  return {
    prompt: cleanHtml(raw.def1),
    answer: reflexive ? `sich ${bare}` : bare,
    answerAlts: reflexive ? [bare] : [],
    article,
    partOfSpeech,
    notes: null,
    exampleEn: cleanHtml(raw.en1) || null,
    exampleDe: cleanHtml(raw.de1) || null,
    frequencyRank: parseRank(raw.rank),
  };
}
