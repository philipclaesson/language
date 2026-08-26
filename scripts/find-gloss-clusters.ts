// Lists corpus cards that collide in English — several German words sharing one
// English sense — so you can eyeball which clusters deserve a Swedish gloss
// (words-overrides.ts `swedish`). The cheap, deterministic first pass: it reads the
// committed words.data.json, no network, changes nothing. Deciding the actual
// Swedish word per card is still a human call (does Swedish disambiguate, any false
// friends?) done through `scripts/apply-overrides.ts` afterwards.
//
// Usage:
//   npm run find:clusters                       # top 40 not-yet-glossed clusters
//   npm run find:clusters -- --max-rank=1000    # only cards in the top-1000 band
//   npm run find:clusters -- --pos=verb         # restrict to one part of speech
//   npm run find:clusters -- --min-size=3       # only 3+-way collisions
//   npm run find:clusters -- --include-glossed  # show already-finished clusters too
//   npm run find:clusters -- --limit=0          # no limit (print them all)
//
// The clustering logic + its rules live in server/db/gloss-clusters.ts (tested).

import { readFileSync } from "node:fs";
import { join } from "node:path";
import type { ParsedWord } from "../server/db/words-parse.ts";
import { findClusters, type FindOptions } from "../server/db/gloss-clusters.ts";

function numFlag(name: string): number | undefined {
  const raw = process.argv.find((a) => a.startsWith(`--${name}=`))?.split("=")[1];
  if (raw == null) return undefined;
  const n = Number(raw);
  if (!Number.isFinite(n)) {
    console.error(`--${name} must be a number (got "${raw}")`);
    process.exit(1);
  }
  return n;
}
const hasFlag = (name: string) => process.argv.includes(`--${name}`);

const posRaw = process.argv.find((a) => a.startsWith("--pos="))?.split("=")[1];
const opts: FindOptions = {
  minSize: numFlag("min-size"),
  maxRank: numFlag("max-rank") ?? null,
  includeGlossed: hasFlag("include-glossed"),
  pos: posRaw ? new Set(posRaw.split(",").map((s) => s.trim())) : null,
};
const limit = numFlag("limit") ?? 40; // 0 = no limit

const dataPath = join(import.meta.dirname, "..", "server", "db", "words.data.json");
const words = JSON.parse(readFileSync(dataPath, "utf8")) as ParsedWord[];

const all = findClusters(words, opts);
const shown = limit > 0 ? all.slice(0, limit) : all;

const pad = (s: string, n: number) => (s.length >= n ? s : s + " ".repeat(n - s.length));

console.log(
  `Scanned ${words.length} cards · ${all.length} collision cluster(s)` +
    (opts.maxRank != null ? ` in the top ${opts.maxRank}` : "") +
    (opts.pos ? ` (${[...opts.pos].join("/")})` : "") +
    ` · min-size ${opts.minSize ?? 2}` +
    (opts.includeGlossed ? " · incl. glossed" : " · unglossed/partial only") +
    (limit > 0 && all.length > shown.length ? ` · showing top ${shown.length}` : ""),
);
console.log();

shown.forEach((c, i) => {
  const rankSpan = c.minRank === c.medianRank ? `rank ${c.minRank}` : `ranks from ${c.minRank}`;
  const done = c.glossedCount > 0 ? `  ·  ${c.glossedCount}/${c.size} glossed` : "";
  console.log(
    `[${i + 1}] "${c.sense}"  ·  ${c.size} words  ·  ${rankSpan} (median ${c.medianRank})${done}`,
  );
  for (const card of c.cards) {
    const rank = pad(String(card.rank ?? "?"), 5);
    const answer = pad(card.answer, 16);
    const sv = card.swedish ? `  🇸🇪 ${card.swedish}` : "";
    console.log(`    ${rank} ${answer} ${card.prompt}${sv}`);
  }
  console.log();
});
