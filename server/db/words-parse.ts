// Pure parsing rules for the frequency word corpus. The corpus is imported once
// from an Anki deck ("5000 German words sorted by frequency") whose notes carry
// light HTML and a handful of messy German-entry conventions (dual articles,
// alternative surface forms, abbreviations, footnote markers). These functions
// turn one raw note into a clean `cards`-shaped row; they run offline in the
// generator (scripts/gen-words.ts), never at request time, but they hold all the
// edge-case rules so they live here, tested, rather than buried in a script.

// One Anki note's fields (the six we keep from the deck's note model).
export type RawNote = {
  german: string; // GermanEntry, e.g. "der Teil", "die Universität, Uni"
  english: string; // EnglishMeaning, the prompt
  rank: string; // Rank, e.g. "129", "2500-1", "#3001"
  notThisWord: string; // NotThisWord, a disambiguation hint (usually empty)
  germanSentence: string; // GermanSampleSentence
  englishSentence: string; // RoughEnglishSentence
};

// A parsed word, shaped for a `cards` insert (deckId/source added by the caller).
export type ParsedWord = {
  prompt: string; // English
  answer: string; // bare German (noun without article)
  answerAlts: string[]; // alternative surface forms / abbreviations
  article: string | null; // der/die/das when unambiguous, else null
  partOfSpeech: string | null; // "noun" for article-led entries, else null
  notes: string | null; // free-form note / mnemonic (unused by the corpus — always null here)
  exampleEn: string | null; // English gloss of the sample sentence (context, safe pre-answer)
  exampleDe: string | null; // German sample sentence (embeds the answer; shown on a miss)
  frequencyRank: number | null; // lower = more frequent; new-card order
};

const ARTICLES = new Set(["der", "die", "das"]);

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
 * Strip the light HTML the deck carries: `<sup>…</sup>` footnote/homonym markers
 * and `<img>` are dropped whole; other tags are removed but their text kept;
 * entities are decoded and whitespace collapsed.
 */
export function cleanHtml(s: string): string {
  let t = s ?? "";
  t = t.replace(/<sup\b[^>]*>[\s\S]*?<\/sup>/gi, ""); // footnote markers, content and all
  t = t.replace(/<img\b[^>]*>/gi, ""); // the lone screenshot image
  t = t.replace(/<\/?(?:div|p|br)\b[^>]*>/gi, " "); // block tags → space (avoid word-merges)
  t = t.replace(/<[^>]+>/g, ""); // inline tags (b, i, span, …) → nothing
  t = t.replace(/&#(\d+);/g, (_, n) => String.fromCodePoint(Number(n)));
  for (const [ent, ch] of Object.entries(ENTITIES)) t = t.split(ent).join(ch);
  return t.replace(/\s+/g, " ").trim();
}

/** First integer in the Rank string ("2500-1" → 2500, "#3001" → 3001). */
export function parseRank(s: string): number | null {
  const m = (s ?? "").match(/\d+/);
  return m ? Number(m[0]) : null;
}

// Remove per-form noise: parentheticals, plural/grammar markers, a leading "+",
// and anything after a stray unmatched bracket. Leaves the plain surface form.
function stripFormNoise(form: string): string {
  let f = form.replace(/\([^)]*\)/g, " "); // balanced parentheticals
  f = f.split(/[{([]/)[0]; // cut at any leftover unmatched bracket
  f = f.replace(/^\s*\+\s*/, ""); // leading "+"
  f = f.replace(/(^|\s)(pl|sg|Pl|Sg)\.?(?=\s|$)/g, " "); // grammar markers as whole words
  return f.replace(/\s+/g, " ").trim();
}

/**
 * Split a cleaned German entry into article + surface forms.
 *
 * Leading article tokens are peeled first so a comma/slash between *articles*
 * ("der, die Jugendliche") isn't mistaken for a separator between *forms*
 * ("die Universität, Uni"). A single leading article is kept (gender-tested);
 * a dual/ambiguous one collapses to `article=null` but still marks the entry a
 * noun. The remainder is split into forms; the first is the answer, the rest
 * become alternatives.
 */
export function parseGermanEntry(cleaned: string): {
  answer: string;
  answerAlts: string[];
  article: string | null;
  partOfSpeech: string | null;
} {
  let s = cleaned.trim();
  let article: string | null = null;
  let partOfSpeech: string | null = null;

  const lead = s.match(/^((?:der|die|das)(?:\s*[,/]\s*(?:der|die|das))*)\b\s*/i);
  if (lead) {
    const arts = lead[1].split(/\s*[,/]\s*/).map((a) => a.toLowerCase());
    const distinct = [...new Set(arts)].filter((a) => ARTICLES.has(a));
    partOfSpeech = "noun";
    article = distinct.length === 1 ? distinct[0] : null;
    s = s.slice(lead[0].length).trim();
  }

  const forms = s
    .split(/\s*[,/]\s*/)
    .map(stripFormNoise)
    .filter((f) => f.length > 0);

  // Fallback: if noise-stripping emptied everything, keep the raw remainder.
  const answer = forms[0] ?? s;
  return { answer, answerAlts: forms.slice(1), article, partOfSpeech };
}

/** Turn one raw Anki note into a clean, `cards`-shaped word. */
export function parseNote(raw: RawNote): ParsedWord {
  let prompt = cleanHtml(raw.english);
  const notThis = cleanHtml(raw.notThisWord);
  if (notThis) prompt = `${prompt} (not: ${notThis})`;

  const { answer, answerAlts, article, partOfSpeech } = parseGermanEntry(
    cleanHtml(raw.german),
  );

  // The two sample sentences live in dedicated fields: the English gloss is shown
  // up front for context; the German sentence (which contains the answer word) is
  // revealed only after a wrong answer. `notes` is left free for tutor mnemonics.
  return {
    prompt,
    answer,
    answerAlts,
    article,
    partOfSpeech,
    notes: null,
    exampleEn: cleanHtml(raw.englishSentence) || null,
    exampleDe: cleanHtml(raw.germanSentence) || null,
    frequencyRank: parseRank(raw.rank),
  };
}
