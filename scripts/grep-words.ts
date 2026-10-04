// Grep the committed frequency word corpus (server/db/words.data.json) and print
// each hit as a small card: English prompt, German answer (with article), Swedish
// gloss if any, example sentence. Read-only, no network — the lookup half of the
// Swedish-gloss workflow (the fix half is words-overrides.ts + apply-overrides.ts).
//
// Usage:
//   npm run words:grep -- <pattern> [<pattern> ...]   # case-insensitive substring,
//                                                     #   matched against en/de/sv
//   npm run words:grep -- "^to go" --regex           # patterns are regexes
//   npm run words:grep -- haus --all                 # also search the examples
//   npm run words:grep -- --rank=221,464             # look up specific cards
//   npm run words:grep -- zeit --missing-sv          # only cards with no Swedish yet
//   npm run words:grep -- zeit --max-rank=1000       # only the top-1000 band
// Several patterns OR together. With no pattern, every card passes the filters
// (useful with --missing-sv --max-rank=N to see what's left to gloss).

import { readFileSync } from "node:fs";
import { join } from "node:path";
import type { ParsedWord } from "../server/db/words-parse.ts";

const args = process.argv.slice(2);
const flag = (name: string) => args.includes(`--${name}`);
const value = (name: string) =>
  args.find((a) => a.startsWith(`--${name}=`))?.slice(name.length + 3);
const patterns = args.filter((a) => !a.startsWith("--"));

const useRegex = flag("regex");
const searchAll = flag("all");
const missingSv = flag("missing-sv");
const maxRank = value("max-rank") ? Number(value("max-rank")) : null;
const ranks = value("rank")
  ? new Set(value("rank")!.split(",").map((s) => Number(s.trim())))
  : null;

if (patterns.length === 0 && !ranks && !missingSv) {
  console.error("Give a pattern (or --rank=N / --missing-sv). See the header of scripts/grep-words.ts.");
  process.exit(1);
}

const escape = (s: string) => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
const res = patterns.map((p) => new RegExp(useRegex ? p : escape(p), "i"));

const dataPath = join(import.meta.dirname, "..", "server", "db", "words.data.json");
const words = JSON.parse(readFileSync(dataPath, "utf8")) as ParsedWord[];

function haystack(w: ParsedWord): string[] {
  const base = [w.prompt, w.answer, ...w.answerAlts, w.swedish ?? ""];
  return searchAll ? [...base, w.exampleEn ?? "", w.exampleDe ?? ""] : base;
}

const hits = words.filter((w) => {
  if (ranks && !ranks.has(w.frequencyRank)) return false;
  if (maxRank != null && w.frequencyRank > maxRank) return false;
  if (missingSv && w.swedish) return false;
  if (res.length === 0) return true;
  const fields = haystack(w);
  return res.some((re) => fields.some((f) => re.test(f)));
});

const de = (w: ParsedWord) => {
  const alts = w.answerAlts.length ? ` (also: ${w.answerAlts.join(", ")})` : "";
  return (w.article ? `${w.article} ` : "") + w.answer + alts;
};

for (const w of hits) {
  const tag = `#${w.frequencyRank}`.padEnd(6);
  const pad = " ".repeat(tag.length);
  console.log(`${tag}en: ${w.prompt}${w.partOfSpeech ? `  [${w.partOfSpeech}]` : ""}`);
  console.log(`${pad}de: ${de(w)}`);
  console.log(`${pad}sv: ${w.swedish ?? "—"}`);
  if (w.exampleDe) console.log(`${pad}ex: ${w.exampleDe}`);
  if (w.exampleEn) console.log(`${pad}    ${w.exampleEn}`);
  if (w.notes) console.log(`${pad}nb: ${w.notes}`);
  console.log();
}

const glossed = hits.filter((w) => w.swedish).length;
console.log(`${hits.length} hit(s) · ${glossed} with Swedish, ${hits.length - glossed} without`);
