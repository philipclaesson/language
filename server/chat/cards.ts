// Turn a raw card object from the AI's tool call into clean, storable fields.
// This is the one piece of the chat module with real rules, so it's pure and
// unit-tested: it defends the deck against a model that ignores our card
// convention (bare noun in `answer`, gender in `article`) — getting that wrong
// would silently make cards ungradeable, since checkAnswer composes
// `article + answer` and compares against what the learner types.

const ARTICLES = new Set(["der", "die", "das"]);

// Tool inputs arrive as snake_case (the natural shape for a JSON tool schema).
export type RawCardInput = {
  prompt?: unknown;
  answer?: unknown;
  article?: unknown;
  part_of_speech?: unknown;
  answer_alts?: unknown;
  notes?: unknown;
  example_en?: unknown;
  example_de?: unknown;
};

export type NormalizedCard = {
  prompt: string;
  answer: string;
  answerAlts: string[];
  partOfSpeech: string | null;
  article: string | null;
  notes: string | null;
  exampleEn: string | null;
  exampleDe: string | null;
};

function str(v: unknown): string | undefined {
  if (typeof v !== "string") return undefined;
  const t = v.trim();
  return t.length ? t : undefined;
}

function stripArticle(s: string): string {
  return s.replace(/^(der|die|das)\s+/i, "");
}

export function normalizeCardInput(raw: RawCardInput): NormalizedCard {
  const prompt = str(raw.prompt);
  let answer = str(raw.answer);
  if (!prompt) throw new Error("card is missing an English prompt");
  if (!answer) throw new Error(`card "${prompt}" is missing a German answer`);

  let pos = str(raw.part_of_speech)?.toLowerCase() ?? null;
  let article = str(raw.article)?.toLowerCase() ?? null;
  if (article && !ARTICLES.has(article)) article = null; // ignore den/dem/ein/…

  // The model often embeds the article in the answer ("der Hund"). Split it out
  // so `answer` stays bare; otherwise the canonical answer becomes "der der Hund".
  const m = /^(der|die|das)\s+(.+)$/i.exec(answer);
  if (m) {
    answer = m[2].trim();
    article = article ?? m[1].toLowerCase();
    pos = pos ?? "noun";
  }

  // Articles only mean anything for nouns (checkAnswer ignores them otherwise).
  // An unlabelled card carrying an article is a noun; a non-noun carrying one is
  // contradictory, so trust the explicit part of speech and drop the article.
  if (article) {
    if (!pos) pos = "noun";
    else if (pos !== "noun") article = null;
  }

  const bare = answer;
  const altsRaw = Array.isArray(raw.answer_alts) ? raw.answer_alts : [];
  const answerAlts = [
    ...new Set(
      altsRaw
        .map((a) => str(a))
        .filter((a): a is string => !!a)
        .map((a) => stripArticle(a))
        .filter((a) => a.toLowerCase() !== bare.toLowerCase()),
    ),
  ];

  return {
    prompt,
    answer,
    answerAlts,
    partOfSpeech: pos,
    article,
    notes: str(raw.notes) ?? null,
    exampleEn: str(raw.example_en) ?? null,
    exampleDe: str(raw.example_de) ?? null,
  };
}
