// Finds clusters of corpus cards that COLLIDE in English — several distinct German
// words sharing one English sense (e.g. geschehen / vorkommen / erfolgen /
// stattfinden / auftreten all glossed "…occur…"). These are the cards where a
// Swedish gloss (words-overrides.ts `swedish`) earns its place: the English prompt
// can't tell the words apart, but Swedish usually maps them to distinct words.
//
// This is the cheap, deterministic HALF of the job — it surfaces *candidates* off
// the committed corpus with no network. Deciding the actual Swedish word (and
// whether Swedish genuinely disambiguates a cluster, or just collides again like
// verwenden/benutzen → both "använda") stays a human/LLM judgement, done per card
// through the normal override flow. Consumed by scripts/find-gloss-clusters.ts.

import type { ParsedWord } from "./words-parse";

// Normalize one English sense phrase into a comparison key: lowercase, drop the
// infinitive "to " marker so "to occur" and "occur" match, strip punctuation, and
// collapse whitespace. Deliberately light — over-normalizing (stemming, dropping
// articles) risks merging senses that aren't the same.
export function normalizeSense(s: string): string {
  return s
    .toLowerCase()
    .replace(/["'().!?;:]/g, " ")
    .replace(/^\s*to\s+/, "")
    .replace(/\s+/g, " ")
    .trim();
}

// Split an English prompt into its distinct sense tokens. Prompts list senses
// comma/slash/semicolon-separated ("to take place, occur" → ["take place", "occur"]).
export function senseTokens(prompt: string): string[] {
  const seen = new Set<string>();
  for (const part of prompt.split(/[,;/]/)) {
    const t = normalizeSense(part);
    if (t.length > 0) seen.add(t);
  }
  return [...seen];
}

export type ClusterCard = {
  rank: number | null;
  answer: string;
  prompt: string;
  partOfSpeech: string | null;
  swedish: string | null;
};

export type GlossCluster = {
  sense: string; // the shared normalized English sense the cluster is anchored on
  cards: ClusterCard[]; // distinct German words sharing that sense, by rank asc
  size: number; // cards.length
  minRank: number; // lowest (most frequent) rank in the cluster
  medianRank: number; // median rank — the ranking key (lower = more useful)
  glossedCount: number; // how many cards already carry a swedish gloss
};

export type FindOptions = {
  minSize?: number; // min distinct German words to count as a cluster (default 2)
  maxRank?: number | null; // consider only cards with rank <= this (null = no cap)
  includeGlossed?: boolean; // keep clusters already fully glossed (default false)
  pos?: Set<string> | null; // restrict to cards of these parts of speech (null = all)
};

const rankOr = (r: number | null): number => (r == null ? Number.MAX_SAFE_INTEGER : r);

function median(sorted: number[]): number {
  const n = sorted.length;
  if (n === 0) return Number.MAX_SAFE_INTEGER;
  const mid = n >> 1;
  return n % 2 ? sorted[mid] : (sorted[mid - 1] + sorted[mid]) / 2;
}

// Group the corpus into per-sense collision clusters. A card contributes to every
// sense it lists, so a genuinely two-sense word (auftreten = "appear, occur") shows
// up under both "appear" and "occur" — that's correct, not a bug.
export function findClusters(words: ParsedWord[], opts: FindOptions = {}): GlossCluster[] {
  const minSize = opts.minSize ?? 2;
  const maxRank = opts.maxRank ?? null;
  const includeGlossed = opts.includeGlossed ?? false;
  const pos = opts.pos ?? null;

  // sense -> (answer -> card), deduping by German word within a sense.
  const bySense = new Map<string, Map<string, ClusterCard>>();
  for (const w of words) {
    if (maxRank != null && rankOr(w.frequencyRank) > maxRank) continue;
    if (pos && !pos.has(w.partOfSpeech ?? "")) continue;
    const card: ClusterCard = {
      rank: w.frequencyRank,
      answer: w.answer,
      prompt: w.prompt,
      partOfSpeech: w.partOfSpeech,
      swedish: w.swedish ?? null,
    };
    for (const sense of senseTokens(w.prompt)) {
      let m = bySense.get(sense);
      if (!m) bySense.set(sense, (m = new Map()));
      if (!m.has(w.answer)) m.set(w.answer, card);
    }
  }

  const clusters: GlossCluster[] = [];
  for (const [sense, m] of bySense) {
    if (m.size < minSize) continue;
    const cards = [...m.values()].sort((a, b) => rankOr(a.rank) - rankOr(b.rank));
    const glossedCount = cards.filter((c) => c.swedish).length;
    if (!includeGlossed && glossedCount === cards.length) continue;
    const ranks = cards.map((c) => rankOr(c.rank)).sort((a, b) => a - b);
    clusters.push({
      sense,
      cards,
      size: cards.length,
      minRank: ranks[0],
      medianRank: median(ranks),
      glossedCount,
    });
  }

  // Most useful first: bigger collisions, then more frequent (lower median rank),
  // then sense alphabetically for a stable order.
  clusters.sort(
    (a, b) =>
      b.size - a.size ||
      a.medianRank - b.medianRank ||
      (a.sense < b.sense ? -1 : a.sense > b.sense ? 1 : 0),
  );
  return clusters;
}
