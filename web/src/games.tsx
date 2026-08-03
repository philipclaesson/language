import { useEffect, useRef, useState } from "preact/hooks";
import type {
  ArticleNoun,
  GameId,
  GermanArticle,
  HighScoreEntry,
  SubmitScoreResponse,
} from "../../shared/types";
import { GERMAN_ARTICLES } from "../../shared/types";
import { getArticleRound, getHighScores, submitScore } from "./api";
import {
  KASUS_CATEGORY_LABELS,
  KASUS_LABELS,
  KASUS_OPTIONS,
  kasusRound,
  solveSentence,
  type Kasus,
  type KasusCategory,
  type KasusItem,
} from "./kasus-game";
import {
  PREP_CLASS_LABELS,
  PREP_CLASSES,
  PREP_GAME_SECONDS,
  prepDeck,
  type PrepClass,
  type PrepItem,
} from "./preps-game";

// The games corner — an easter egg behind the 🔥 on the Stats page. The menu
// lists every playable game plus the shared high-score table; the games render
// full-screen like the review loops.

// The games that persist to the shared high-score table (the match game is
// menu-only — its time+errors result isn't a comparable integer score).
const SCORED_GAMES: {
  id: GameId;
  emoji: string;
  title: string;
  subtitle: string;
  path: string;
}[] = [
  {
    id: "article-mania",
    emoji: "🎭",
    title: "Article Mania",
    subtitle: "der, die or das? 25 nouns, three buttons, no mercy.",
    path: "/games/article-mania",
  },
  {
    id: "kasus-krieg",
    emoji: "⚔️",
    title: "Kasus Krieg",
    subtitle: "Nominativ, Akkusativ or Dativ? 25 sentences — name the case.",
    path: "/games/kasus-krieg",
  },
  {
    id: "praeposition-power",
    emoji: "⚡",
    title: "Präposition Power",
    subtitle: "60 seconds to sort prepositions: Dativ, Akkusativ or Wechsel.",
    path: "/games/praeposition-power",
  },
];

export function GamesMenu({
  onBack,
  onOpen,
}: {
  onBack: () => void;
  onOpen: (path: string) => void;
}) {
  const [scores, setScores] = useState<Record<string, HighScoreEntry[]> | null>(null);

  useEffect(() => {
    Promise.all(
      SCORED_GAMES.map((g) =>
        getHighScores(g.id)
          .then((r) => [g.id, r.entries] as const)
          .catch(() => [g.id, []] as const),
      ),
    ).then((pairs) => setScores(Object.fromEntries(pairs)));
  }, []);

  const anyScores = scores !== null && SCORED_GAMES.some((g) => scores[g.id]?.length);

  return (
    <div class="mx-auto flex min-h-screen max-w-md flex-col px-5 pb-10 pt-10">
      <header class="flex items-center justify-between">
        <h1 class="text-2xl font-semibold tracking-tight text-slate-900">Games 🔥</h1>
        <button
          onClick={onBack}
          class="text-sm text-slate-500 underline-offset-2 hover:text-slate-900 hover:underline"
        >
          Back
        </button>
      </header>

      <main class="mt-8 space-y-3">
        {SCORED_GAMES.map((g) => (
          <GameCard
            key={g.id}
            emoji={g.emoji}
            title={g.title}
            subtitle={g.subtitle}
            onPlay={() => onOpen(g.path)}
          />
        ))}
        <GameCard
          emoji="🧩"
          title="Match today's misses"
          subtitle="Re-drill today's missed words against the clock."
          onPlay={() => onOpen("/games/pairs")}
        />

        <div class="space-y-5 pt-6">
          <h2 class="text-sm font-medium uppercase tracking-wide text-slate-400">
            High scores
          </h2>
          {scores === null ? (
            <p class="text-slate-400">…</p>
          ) : !anyScores ? (
            <p class="text-sm text-slate-500">No scores yet — be the first. 🏆</p>
          ) : (
            SCORED_GAMES.filter((g) => scores[g.id]?.length).map((g) => (
              <div key={g.id}>
                <h3 class="mb-2 text-xs font-medium text-slate-500">
                  {g.emoji} {g.title}
                </h3>
                <HighScoreTable entries={scores[g.id]} />
              </div>
            ))
          )}
        </div>
      </main>
    </div>
  );
}

function GameCard({
  emoji,
  title,
  subtitle,
  onPlay,
}: {
  emoji: string;
  title: string;
  subtitle: string;
  onPlay: () => void;
}) {
  return (
    <button
      onClick={onPlay}
      class="flex w-full items-center gap-4 rounded-2xl border border-slate-200 px-5 py-4 text-left transition hover:bg-slate-50"
    >
      <span class="text-3xl">{emoji}</span>
      <span class="min-w-0">
        <span class="block font-medium text-slate-900">{title}</span>
        <span class="mt-0.5 block text-sm text-slate-500">{subtitle}</span>
      </span>
    </button>
  );
}

// The classic top-5 table. `highlightId` marks the just-played entry; when it
// didn't make the top, `extra` renders it below a separator with its real rank.
function HighScoreTable({
  entries,
  highlightId,
  extra,
}: {
  entries: HighScoreEntry[];
  highlightId?: string;
  extra?: { entry: HighScoreEntry; rank: number } | null;
}) {
  return (
    <div class="overflow-hidden rounded-2xl border border-slate-200">
      {entries.map((e, i) => (
        <ScoreRow key={e.id} rank={i + 1} entry={e} highlight={e.id === highlightId} />
      ))}
      {extra && (
        <>
          <div class="px-5 py-1 text-center text-xs text-slate-300">⋯</div>
          <ScoreRow rank={extra.rank} entry={extra.entry} highlight />
        </>
      )}
    </div>
  );
}

function ScoreRow({
  rank,
  entry,
  highlight,
}: {
  rank: number;
  entry: HighScoreEntry;
  highlight: boolean;
}) {
  const medal = rank === 1 ? "🥇" : rank === 2 ? "🥈" : rank === 3 ? "🥉" : `${rank}.`;
  return (
    <div
      class={`flex items-center gap-3 px-5 py-2.5 text-sm ${
        highlight ? "bg-blue-50 font-medium text-blue-900" : "text-slate-700"
      }`}
    >
      <span class="w-7 shrink-0 text-center tabular-nums">{medal}</span>
      <span class="min-w-0 flex-1 truncate">{entry.player}</span>
      <span class="shrink-0 text-xs text-slate-400">
        {new Date(entry.createdAt).toLocaleDateString(undefined, {
          day: "numeric",
          month: "short",
        })}
      </span>
      <span class="w-12 shrink-0 text-right font-semibold tabular-nums">
        {formatScore(entry)}
      </span>
    </div>
  );
}

// Präposition Power's score is a raw count (sorts in 60s); the others are percent.
function formatScore(entry: HighScoreEntry): string {
  return entry.game === "praeposition-power" ? `${entry.score}` : `${entry.score}%`;
}

// ---- Article Mania ----

// Guess der/die/das for 50 random corpus nouns. Graded client-side (the round
// payload carries the articles — see shared/types.ts ArticleNoun); the final
// percent goes to the shared high-score table.

type Phase = "ready" | "playing" | "done";

// Post-tap feedback delay: long enough to read the wrong→right correction.
const NEXT_DELAY_RIGHT = 450;
const NEXT_DELAY_WRONG = 1200;

export function ArticleMania({ onExit }: { onExit: () => void }) {
  const [nouns, setNouns] = useState<ArticleNoun[] | null>(null);
  const [failed, setFailed] = useState(false);
  const [phase, setPhase] = useState<Phase>("ready");
  const [idx, setIdx] = useState(0);
  const [correct, setCorrect] = useState(0);
  const [picked, setPicked] = useState<GermanArticle | null>(null);
  const [result, setResult] = useState<SubmitScoreResponse | null>(null);
  const [saveFailed, setSaveFailed] = useState(false);

  useEffect(() => {
    load();
  }, []);

  function load() {
    setNouns(null);
    getArticleRound()
      .then((r) => setNouns(r.nouns))
      .catch(() => setFailed(true));
  }

  function start() {
    setIdx(0);
    setCorrect(0);
    setPicked(null);
    setResult(null);
    setSaveFailed(false);
    setPhase("playing");
  }

  function playAgain() {
    load(); // a fresh random round
    start();
  }

  function finish(finalCorrect: number, total: number) {
    setPhase("done");
    const score = Math.round((finalCorrect / total) * 100);
    submitScore("article-mania", score)
      .then(setResult)
      .catch(() => setSaveFailed(true));
  }

  function pick(article: GermanArticle) {
    if (!nouns || picked !== null) return; // locked during feedback
    const right = article === nouns[idx].article;
    const finalCorrect = correct + (right ? 1 : 0);
    setPicked(article);
    if (right) setCorrect(finalCorrect);
    setTimeout(() => {
      setPicked(null);
      if (idx + 1 >= nouns.length) finish(finalCorrect, nouns.length);
      else setIdx(idx + 1);
    }, right ? NEXT_DELAY_RIGHT : NEXT_DELAY_WRONG);
  }

  if (failed) {
    return (
      <Shell>
        <div class="text-center">
          <p class="text-2xl">😵</p>
          <p class="mt-2 text-slate-600">Couldn't load a round. Try again later.</p>
          <BackButton onClick={onExit} primary />
        </div>
      </Shell>
    );
  }

  if (phase === "ready") {
    return (
      <Shell>
        <div class="w-full max-w-sm text-center">
          <p class="text-3xl">🎭</p>
          <p class="mt-3 text-2xl font-semibold text-slate-900">Article Mania</p>
          <p class="mt-2 text-slate-600">
            {nouns ? nouns.length : ROUND_HINT} nouns, one at a time — tap the right
            article. Score goes to the eternal high-score table.
          </p>
          <button
            onClick={start}
            disabled={!nouns || nouns.length === 0}
            class="mt-6 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700 disabled:opacity-50"
          >
            {nouns ? "Start" : "…"}
          </button>
          <BackButton onClick={onExit} />
        </div>
      </Shell>
    );
  }

  if (phase === "done") {
    const total = nouns?.length ?? 0;
    const score = total > 0 ? Math.round((correct / total) * 100) : 0;
    const madeTop = result?.top.some((e) => e.id === result.entry.id) ?? false;
    return (
      <Shell>
        <div class="w-full max-w-sm text-center">
          <p class="text-3xl">{score === 100 ? "👑" : score >= 80 ? "🎉" : "🎭"}</p>
          <p class="mt-3 text-2xl font-semibold text-slate-900">{score}%</p>
          <p class="mt-1 text-slate-600">
            {correct} of {total} articles right
            {result && result.rank === 1 ? " — a new high score! 🏆" : "."}
          </p>

          <div class="mt-6 text-left">
            <h2 class="mb-2 text-center text-sm font-medium uppercase tracking-wide text-slate-400">
              High scores
            </h2>
            {saveFailed ? (
              <p class="text-center text-sm text-slate-500">
                Couldn't save your score — check your connection.
              </p>
            ) : result === null ? (
              <p class="text-center text-slate-400">…</p>
            ) : (
              <HighScoreTable
                entries={result.top}
                highlightId={result.entry.id}
                extra={madeTop ? null : { entry: result.entry, rank: result.rank }}
              />
            )}
          </div>

          <button
            onClick={playAgain}
            class="mt-6 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700"
          >
            Play again
          </button>
          <BackButton onClick={onExit} />
        </div>
      </Shell>
    );
  }

  // playing
  if (!nouns) return <Shell>…</Shell>;
  if (nouns.length === 0) {
    return (
      <Shell>
        <div class="text-center">
          <p class="text-2xl">🌙</p>
          <p class="mt-2 text-slate-600">No nouns to play with yet.</p>
          <BackButton onClick={onExit} primary />
        </div>
      </Shell>
    );
  }

  const current = nouns[idx];
  return (
    <Shell align="start">
      <div class="w-full max-w-sm">
        <div class="mb-10 flex items-center justify-between text-sm text-slate-400">
          <span class="tabular-nums">
            {idx + 1} / {nouns.length}
          </span>
          <span class="tabular-nums font-medium text-slate-700">✓ {correct}</span>
          <button onClick={onExit} class="hover:text-slate-700 hover:underline">
            End game
          </button>
        </div>

        <p class="text-center text-4xl font-semibold tracking-tight text-slate-900">
          {current.noun}
        </p>
        {/* English gloss for context — word mode in reverse (safe: it never hints
            at the gender, which is the thing being tested). */}
        <p class="mt-2 text-center text-slate-500">{current.en}</p>
        <p class="mt-3 h-6 text-center text-sm">
          {picked === null ? (
            <span class="text-slate-400">der, die or das?</span>
          ) : picked === current.article ? (
            <span class="font-medium text-green-600">Richtig! ✓</span>
          ) : (
            <span class="font-medium text-red-600">
              Nope — {current.article} {current.noun}
            </span>
          )}
        </p>

        <div class="mt-8 grid grid-cols-3 gap-2.5">
          {GERMAN_ARTICLES.map((a) => (
            <button
              key={a}
              onClick={() => pick(a)}
              class={`rounded-xl border px-3 py-4 text-lg font-medium transition-colors ${choiceClass(
                a,
                picked,
                current.article,
              )}`}
            >
              {a}
            </button>
          ))}
        </div>
      </div>
    </Shell>
  );
}

const ROUND_HINT = 25; // shown while the round is still loading

// Idle: neutral. During feedback: the correct choice flashes green; a wrong
// pick flashes red next to it. Shared by all the three-button games.
function choiceClass<T extends string>(choice: T, picked: T | null, correct: T): string {
  if (picked === null) return "border-slate-200 bg-white text-slate-800 hover:bg-slate-50";
  if (choice === correct) return "border-green-500 bg-green-50 text-green-900";
  if (choice === picked) return "border-red-400 bg-red-50 text-red-900";
  return "border-slate-200 bg-white text-slate-400";
}

// ---- Kasus Krieg ----

// Name the case of the blanked article in 25 curated sentences (bank + rules in
// kasus-game.ts — fully client-side, no round endpoint). Every answer flashes
// the ONE rule that decides the case; the results screen breaks your round down
// by rule family so you see which decision you're weak on.

const KASUS_RIGHT_DELAY = 900; // rule shows even on a hit — give it a beat
const KASUS_WRONG_DELAY = 2400; // rule + solved sentence need reading time

type KasusAnswer = { item: KasusItem; right: boolean };

export function KasusKrieg({ onExit }: { onExit: () => void }) {
  const [phase, setPhase] = useState<Phase>("ready");
  const [round, setRound] = useState<KasusItem[]>([]);
  const [idx, setIdx] = useState(0);
  const [answers, setAnswers] = useState<KasusAnswer[]>([]);
  const [picked, setPicked] = useState<Kasus | null>(null);
  const [result, setResult] = useState<SubmitScoreResponse | null>(null);
  const [saveFailed, setSaveFailed] = useState(false);

  function start() {
    setRound(kasusRound());
    setIdx(0);
    setAnswers([]);
    setPicked(null);
    setResult(null);
    setSaveFailed(false);
    setPhase("playing");
  }

  function finish(all: KasusAnswer[]) {
    setPhase("done");
    const right = all.filter((a) => a.right).length;
    const score = Math.round((right / all.length) * 100);
    submitScore("kasus-krieg", score)
      .then(setResult)
      .catch(() => setSaveFailed(true));
  }

  function pick(kasus: Kasus) {
    if (picked !== null || round.length === 0) return; // locked during feedback
    const item = round[idx];
    const right = kasus === item.kasus;
    const all = [...answers, { item, right }];
    setPicked(kasus);
    setAnswers(all);
    setTimeout(() => {
      setPicked(null);
      if (idx + 1 >= round.length) finish(all);
      else setIdx(idx + 1);
    }, right ? KASUS_RIGHT_DELAY : KASUS_WRONG_DELAY);
  }

  if (phase === "ready") {
    return (
      <Shell>
        <div class="w-full max-w-sm text-center">
          <p class="text-3xl">⚔️</p>
          <p class="mt-3 text-2xl font-semibold text-slate-900">Kasus Krieg</p>
          <p class="mt-2 text-slate-600">
            25 sentences with the article blanked out — name the case. Every answer
            shows the rule that decides it.
          </p>
          <button
            onClick={start}
            class="mt-6 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700"
          >
            Start
          </button>
          <BackButton onClick={onExit} />
        </div>
      </Shell>
    );
  }

  if (phase === "done") {
    const right = answers.filter((a) => a.right).length;
    const score = answers.length > 0 ? Math.round((right / answers.length) * 100) : 0;
    const madeTop = result?.top.some((e) => e.id === result.entry.id) ?? false;
    return (
      <Shell>
        <div class="w-full max-w-sm text-center">
          <p class="text-3xl">{score === 100 ? "👑" : score >= 80 ? "🎉" : "⚔️"}</p>
          <p class="mt-3 text-2xl font-semibold text-slate-900">{score}%</p>
          <p class="mt-1 text-slate-600">
            {right} of {answers.length} cases right
            {result && result.rank === 1 ? " — a new high score! 🏆" : "."}
          </p>

          <KasusBreakdown answers={answers} />

          <div class="mt-6 text-left">
            <h2 class="mb-2 text-center text-sm font-medium uppercase tracking-wide text-slate-400">
              High scores
            </h2>
            {saveFailed ? (
              <p class="text-center text-sm text-slate-500">
                Couldn't save your score — check your connection.
              </p>
            ) : result === null ? (
              <p class="text-center text-slate-400">…</p>
            ) : (
              <HighScoreTable
                entries={result.top}
                highlightId={result.entry.id}
                extra={madeTop ? null : { entry: result.entry, rank: result.rank }}
              />
            )}
          </div>

          <button
            onClick={start}
            class="mt-6 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700"
          >
            Play again
          </button>
          <BackButton onClick={onExit} />
        </div>
      </Shell>
    );
  }

  // playing
  const item = round[idx];
  const right = answers.filter((a) => a.right).length;
  const [before, after] = item.sentence.split("___");
  return (
    <Shell align="start">
      <div class="w-full max-w-sm">
        <div class="mb-10 flex items-center justify-between text-sm text-slate-400">
          <span class="tabular-nums">
            {idx + 1} / {round.length}
          </span>
          <span class="tabular-nums font-medium text-slate-700">✓ {right}</span>
          <button onClick={onExit} class="hover:text-slate-700 hover:underline">
            End game
          </button>
        </div>

        <p class="text-center text-2xl font-semibold leading-snug tracking-tight text-slate-900">
          {before}
          <span class="rounded-md bg-slate-100 px-1.5 text-slate-400">___</span>
          {after}
        </p>
        <div class="mt-4 min-h-12 text-center text-sm">
          {picked === null ? (
            <span class="text-slate-400">Which case is the blank?</span>
          ) : (
            <>
              <p
                class={`font-medium ${picked === item.kasus ? "text-green-600" : "text-red-600"}`}
              >
                {picked === item.kasus ? "Richtig! ✓ " : `${KASUS_LABELS[item.kasus]} — `}
                <span class="font-normal">{item.rule}</span>
              </p>
              <p class="mt-1 italic text-slate-500">{solveSentence(item)}</p>
            </>
          )}
        </div>

        <div class="mt-6 grid grid-cols-3 gap-2.5">
          {KASUS_OPTIONS.map((k) => (
            <button
              key={k}
              onClick={() => pick(k)}
              class={`rounded-xl border px-1 py-4 text-sm font-medium transition-colors ${choiceClass(
                k,
                picked,
                item.kasus,
              )}`}
            >
              {KASUS_LABELS[k]}
            </button>
          ))}
        </div>
      </div>
    </Shell>
  );
}

// "Fixed prepositions 9/10" rows — the whole point of the game: seeing WHICH
// deciding rule needs work.
function KasusBreakdown({ answers }: { answers: KasusAnswer[] }) {
  const byCat = new Map<KasusCategory, { right: number; total: number }>();
  for (const a of answers) {
    const cat = a.item.category;
    const c = byCat.get(cat) ?? { right: 0, total: 0 };
    c.total += 1;
    if (a.right) c.right += 1;
    byCat.set(cat, c);
  }
  const cats = (Object.keys(KASUS_CATEGORY_LABELS) as KasusCategory[]).filter((c) =>
    byCat.has(c),
  );
  if (cats.length === 0) return null;
  return (
    <div class="mt-5 rounded-2xl border border-slate-200 px-5 py-4 text-left">
      {cats.map((c) => {
        const { right, total } = byCat.get(c)!;
        return (
          <div key={c} class="flex items-center justify-between py-1 text-sm">
            <span class={right === total ? "text-slate-500" : "font-medium text-slate-800"}>
              {KASUS_CATEGORY_LABELS[c]}
            </span>
            <span
              class={`tabular-nums ${right === total ? "text-green-600" : "text-slate-700"}`}
            >
              {right}/{total}
            </span>
          </div>
        );
      })}
    </div>
  );
}

// ---- Präposition Power ----

// 60-second blitz: sort prepositions into Dativ / Akkusativ / Wechsel (catalog
// in preps-game.ts — fully client-side). A correct sort advances instantly; a
// wrong one shows the correction and the clock keeps eating your time. Score =
// correct sorts, straight onto the shared table.

const PREP_WRONG_DELAY = 1400;

export function PraepositionPower({ onExit }: { onExit: () => void }) {
  const [phase, setPhase] = useState<Phase>("ready");
  const [deck, setDeck] = useState<PrepItem[]>([]);
  const [i, setI] = useState(0);
  const [score, setScore] = useState(0);
  const [misses, setMisses] = useState(0);
  const [picked, setPicked] = useState<PrepClass | null>(null);
  const [timeLeft, setTimeLeft] = useState(PREP_GAME_SECONDS * 1000);
  const endAt = useRef(0);
  const [result, setResult] = useState<SubmitScoreResponse | null>(null);
  const [saveFailed, setSaveFailed] = useState(false);

  useEffect(() => {
    if (phase !== "playing") return;
    const t = setInterval(
      () => setTimeLeft(Math.max(0, endAt.current - Date.now())),
      100,
    );
    return () => clearInterval(t);
  }, [phase]);

  // The render where the clock hits zero has the final score in scope.
  useEffect(() => {
    if (phase !== "playing" || timeLeft > 0) return;
    setPhase("done");
    submitScore("praeposition-power", score)
      .then(setResult)
      .catch(() => setSaveFailed(true));
  }, [phase, timeLeft]);

  function start() {
    setDeck(prepDeck());
    setI(0);
    setScore(0);
    setMisses(0);
    setPicked(null);
    setResult(null);
    setSaveFailed(false);
    endAt.current = Date.now() + PREP_GAME_SECONDS * 1000;
    setTimeLeft(PREP_GAME_SECONDS * 1000);
    setPhase("playing");
  }

  function advance() {
    // Deal a fresh shuffled deck whenever the catalog runs out mid-blitz.
    if (i + 1 >= deck.length) {
      setDeck(prepDeck());
      setI(0);
    } else {
      setI(i + 1);
    }
  }

  function pick(cls: PrepClass) {
    if (picked !== null || deck.length === 0) return;
    if (cls === deck[i].klasse) {
      setScore((s) => s + 1);
      advance(); // instant — speed is the game
    } else {
      setMisses((m) => m + 1);
      setPicked(cls);
      setTimeout(() => {
        setPicked(null);
        advance();
      }, PREP_WRONG_DELAY);
    }
  }

  if (phase === "ready") {
    return (
      <Shell>
        <div class="w-full max-w-sm text-center">
          <p class="text-3xl">⚡</p>
          <p class="mt-3 text-2xl font-semibold text-slate-900">Präposition Power</p>
          <p class="mt-2 text-slate-600">
            Every preposition forces a case. Sort as many as you can in{" "}
            {PREP_GAME_SECONDS} seconds: <span class="font-medium">Dativ</span>,{" "}
            <span class="font-medium">Akkusativ</span> or{" "}
            <span class="font-medium">Wechsel</span> (two-way — Akkusativ for motion,
            Dativ for location).
          </p>
          <button
            onClick={start}
            class="mt-6 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700"
          >
            Start
          </button>
          <BackButton onClick={onExit} />
        </div>
      </Shell>
    );
  }

  if (phase === "done") {
    const madeTop = result?.top.some((e) => e.id === result.entry.id) ?? false;
    return (
      <Shell>
        <div class="w-full max-w-sm text-center">
          <p class="text-3xl">⚡</p>
          <p class="mt-3 text-2xl font-semibold text-slate-900">{score}</p>
          <p class="mt-1 text-slate-600">
            correct sorts in {PREP_GAME_SECONDS} seconds
            {misses > 0 ? ` (${misses} wrong)` : " — flawless!"}
            {result && result.rank === 1 ? " A new high score! 🏆" : ""}
          </p>

          <div class="mt-6 text-left">
            <h2 class="mb-2 text-center text-sm font-medium uppercase tracking-wide text-slate-400">
              High scores
            </h2>
            {saveFailed ? (
              <p class="text-center text-sm text-slate-500">
                Couldn't save your score — check your connection.
              </p>
            ) : result === null ? (
              <p class="text-center text-slate-400">…</p>
            ) : (
              <HighScoreTable
                entries={result.top}
                highlightId={result.entry.id}
                extra={madeTop ? null : { entry: result.entry, rank: result.rank }}
              />
            )}
          </div>

          <button
            onClick={start}
            class="mt-6 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700"
          >
            Play again
          </button>
          <BackButton onClick={onExit} />
        </div>
      </Shell>
    );
  }

  // playing
  const item = deck[i];
  const secondsLeft = Math.ceil(timeLeft / 1000);
  return (
    <Shell align="start">
      <div class="w-full max-w-sm">
        <div class="mb-10 flex items-center justify-between text-sm text-slate-400">
          <span
            class={`tabular-nums font-medium ${
              secondsLeft <= 10 ? "text-red-600" : "text-slate-700"
            }`}
          >
            {secondsLeft}s
          </span>
          <span class="tabular-nums font-medium text-slate-700">⚡ {score}</span>
          <button onClick={onExit} class="hover:text-slate-700 hover:underline">
            End game
          </button>
        </div>

        <p class="text-center text-4xl font-semibold tracking-tight text-slate-900">
          {item.prep}
        </p>
        <p class="mt-3 h-6 text-center text-sm">
          {picked === null ? (
            <span class="text-slate-400">Dativ, Akkusativ or Wechsel?</span>
          ) : (
            <span class="font-medium text-red-600">
              {PREP_CLASS_LABELS[item.klasse]} —{" "}
              <span class="font-normal">{item.example}</span>
            </span>
          )}
        </p>

        <div class="mt-8 grid grid-cols-3 gap-2.5">
          {PREP_CLASSES.map((cls) => (
            <button
              key={cls}
              onClick={() => pick(cls)}
              class={`rounded-xl border px-1 py-4 text-sm font-medium transition-colors ${choiceClass(
                cls,
                picked,
                item.klasse,
              )}`}
            >
              {PREP_CLASS_LABELS[cls]}
            </button>
          ))}
        </div>
      </div>
    </Shell>
  );
}

function BackButton({ onClick, primary }: { onClick: () => void; primary?: boolean }) {
  if (primary) {
    return (
      <button
        onClick={onClick}
        class="mt-6 rounded-xl bg-slate-900 px-5 py-2.5 font-medium text-white hover:bg-slate-700"
      >
        Back
      </button>
    );
  }
  return (
    <button
      onClick={onClick}
      class="mt-3 text-sm text-slate-500 underline-offset-2 hover:text-slate-900 hover:underline"
    >
      Back
    </button>
  );
}

function Shell({
  children,
  align = "center",
}: {
  children: preact.ComponentChildren;
  align?: "center" | "start";
}) {
  return (
    <div
      class={`flex min-h-screen justify-center bg-white px-5 py-10 text-slate-900 ${
        align === "start" ? "items-start pt-14" : "items-center"
      }`}
    >
      {children}
    </div>
  );
}
