// Opt-in eval for Freund's per-message behavior. Runs fixture messages through the
// REAL chat model and checks the ONE property that really matters: the correction
// must reproduce the learner's whole message and change only what's wrong — it must
// never shorten it or drop the parts that were already correct.
//
// This is NOT a unit test: it hits the network and is non-deterministic, so it is
// deliberately excluded from `npm test` / `npm run check` (which stay offline and
// gate deploys). Run it by hand while tuning the prompt:  npm run eval:freund
//
// The key metric is COVERAGE: the fraction of the learner's original words that the
// correction keeps. The fixtures are mostly-correct messages, so a low coverage can
// only mean the model dropped correct content — exactly the truncation bug we guard
// against. We also check that corrections appear (or are omitted) when they should.
import "dotenv/config";
import Anthropic from "@anthropic-ai/sdk";
import { CHAT_MODEL, chatSystemPrompt, respondTool } from "./agent";
import { diffWords } from "./diff";
import type { CorrectionSegment } from "../../shared/types";

const client = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY! });

type Presence = "required" | "omitted";
type Case = {
  name: string;
  message: string;
  correction: Presence;
  minCoverage?: number; // when a correction is present, min fraction of original words kept
};

const CASES: Case[] = [
  {
    // The real message that surfaced the truncation bug — several errors scattered
    // across sentences, but most of it is fine and must survive intact.
    name: "multi-sentence with scattered errors — keeps the correct sentences",
    message:
      "Ja, es ist sehr schön! Ich bin drinnen auf der Couch. Ich habe heute ein Freund getreffet, so ich will nich so viel mehr machen. Vielleicht will ich ein bisschen Wimbledon Tennis oder Weltmeisterschaft sehen auf den fehrnseher.",
    correction: "required",
    minCoverage: 0.7,
  },
  {
    // Long, almost entirely correct — one gender/adjective-ending error mid-sentence.
    name: "long, mostly correct — one mid-sentence error",
    message:
      "Gestern bin ich mit meinem Bruder ins Kino gegangen und wir haben ein sehr guter Film gesehen.",
    correction: "required",
    minCoverage: 0.8,
  },
  {
    // First sentence perfect, second has a plural error — the first must be untouched.
    name: "two sentences, first perfect — must not be dropped",
    message: "Ich wohne in Berlin. Ich habe zwei Katze.",
    correction: "required",
    minCoverage: 0.6,
  },
  {
    // Word order + gender: a heavier fix, but still no content should be dropped.
    name: "word order + gender",
    message: "Ich habe gestern gesehen ein Film.",
    correction: "required",
    minCoverage: 0.4,
  },
  {
    name: "already correct — no correction",
    message: "Ich gehe morgen zur Arbeit.",
    correction: "omitted",
  },
  {
    name: "written in English — no German to correct",
    message: "I had a really nice day today.",
    correction: "omitted",
  },
];

function str(v: unknown): string | null {
  if (typeof v !== "string") return null;
  const t = v.trim();
  return t.length ? t : null;
}

// Fraction of the original message's words retained in the correction. Dropping a
// correct sentence shows up as `del` runs, so coverage falls.
function coverage(segments: CorrectionSegment[]): number {
  const count = (op: CorrectionSegment["op"]) =>
    segments.filter((s) => s.op === op).reduce((n, s) => n + s.text.split(/\s+/).length, 0);
  const kept = count("keep");
  const original = kept + count("del");
  return original === 0 ? 1 : kept / original;
}

function render(segments: CorrectionSegment[]): string {
  return segments
    .map((s) => (s.op === "del" ? `[-${s.text}-]` : s.op === "ins" ? `[+${s.text}+]` : s.text))
    .join(" ");
}

async function run(): Promise<boolean> {
  let allPass = true;

  for (const tc of CASES) {
    const res = await client.messages.create({
      model: CHAT_MODEL,
      max_tokens: 1024,
      system: chatSystemPrompt({ words: [], verbs: [] }),
      tools: [respondTool],
      tool_choice: { type: "tool", name: "respond" },
      messages: [{ role: "user", content: tc.message }],
    });
    const input = res.content.find((b) => b.type === "tool_use")?.input as
      | Record<string, unknown>
      | undefined;
    const reply = str(input?.reply);
    const explanation = str(input?.explanation);
    const correctionText = str(input?.correction);
    const segments = correctionText ? diffWords(tc.message, correctionText) : null;

    const checks: { ok: boolean; label: string }[] = [{ ok: !!reply, label: "reply present" }];
    if (tc.correction === "required") checks.push({ ok: !!segments, label: "correction present" });
    if (tc.correction === "omitted") checks.push({ ok: !segments, label: "correction omitted" });
    if (segments && tc.minCoverage !== undefined) {
      const cov = coverage(segments);
      checks.push({
        ok: cov >= tc.minCoverage,
        label: `coverage ${cov.toFixed(2)} ≥ ${tc.minCoverage} (no dropped content)`,
      });
    }

    const passed = checks.every((c) => c.ok);
    allPass &&= passed;

    console.log(`\n${passed ? "✅" : "❌"} ${tc.name}`);
    console.log(`   in : ${tc.message}`);
    if (segments) console.log(`   fix: ${render(segments)}`);
    if (explanation) console.log(`   exp: ${explanation}`);
    for (const c of checks) if (!c.ok) console.log(`     ✗ ${c.label}`);
  }

  console.log(`\n${allPass ? "All cases passed." : "Some cases FAILED."}`);
  return allPass;
}

run()
  .then((ok) => process.exit(ok ? 0 : 1))
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
