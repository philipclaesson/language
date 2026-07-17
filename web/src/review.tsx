import { useEffect, useRef, useState } from "preact/hooks";
import type { ExtraType, MasteryTier, ReviewResult, SessionCard } from "../../shared/types";
import { EXTRA_NEW, EXTRA_PRACTICE } from "../../shared/types";
import { normalizeAnswer } from "../../shared/normalize";
import { getExtra, getToday, postReview } from "./api";
import { TIER_BY_KEY } from "./tiers";

// `daily`    = the required daily set (due + new), hammer-until-correct.
// `learn`    = bonus: extra fresh cards, hammer-until-correct (you're learning them).
// `practice` = bonus: known cards, weakest-first (a miss reveals + re-drills).
// `misses`   = bonus: cards missed today, re-drilled (FSRS untouched, stable all day).
// All modes hammer-until-correct; the mode only decides which cards get pulled.
export type ReviewMode = "daily" | "learn" | "practice" | "misses";

// The extra-work pull for a bonus mode. `learn` maps to the "new" pool; the others
// share their name. (Only called for bonus modes, never "daily".)
export function extraTypeOf(mode: ReviewMode): ExtraType {
  return mode === "learn" ? "new" : (mode as ExtraType);
}

// `input` = typing the answer from recall (graded on the server).
// `drill` = got it wrong; copy the revealed answer to continue. All modes hammer
//           until correct — a miss rotates the card to the back to come round again.
type Phase = "loading" | "input" | "drill" | "empty" | "done";

export function Review({
  mode = "daily",
  onDone,
  onStartExtra,
}: {
  mode?: ReviewMode;
  onDone: () => void;
  onStartExtra: (type: ExtraType) => void;
}) {
  // `queue` holds the cards still needing a correct typing. We always show queue[0];
  // a correct answer drops it, a wrong one (hammer modes) rotates it to the back so
  // it comes round again — "hammer until correct" (PLAN.md §5a).
  const [queue, setQueue] = useState<SessionCard[]>([]);
  const [phase, setPhase] = useState<Phase>("loading");
  const [typed, setTyped] = useState("");
  const [result, setResult] = useState<ReviewResult | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [flash, setFlash] = useState<"green" | "red" | null>(null);
  // Daily-only: today's required total and how many were done before this session.
  const [requiredTotal, setRequiredTotal] = useState(0);
  const [baseDone, setBaseDone] = useState(0);
  // Availability of the two on-ramps, for the "Done for today" buttons (daily mode).
  const [avail, setAvail] = useState({ new: 0, practice: 0, misses: 0 });
  const [completed, setCompleted] = useState(0); // cards finished this session
  const startedAt = useRef(0);
  const inputRef = useRef<HTMLInputElement>(null);

  const isBonus = mode !== "daily";

  // (Re)load the session for the current mode. Called on mount / mode change and by
  // "Go again" on the bonus done screen.
  function load() {
    setPhase("loading");
    setResult(null);
    setTyped("");
    setFlash(null);
    setCompleted(0);
    setSubmitting(false);
    const start = (cards: SessionCard[], hadRequired: boolean) => {
      if (cards.length === 0) {
        setPhase(hadRequired ? "done" : "empty");
      } else {
        setQueue(cards);
        setPhase("input");
        startedAt.current = Date.now();
      }
    };
    if (mode === "daily") {
      getToday()
        .then((t) => {
          setRequiredTotal(t.dueTotal + t.newTotal);
          setBaseDone(t.done);
          setAvail({
            new: t.newAvailable,
            practice: t.practiceAvailable,
            misses: t.missesAvailable,
          });
          start(t.cards, t.dueTotal + t.newTotal > 0);
        })
        .catch(() => setPhase("empty"));
    } else {
      getExtra(extraTypeOf(mode))
        .then((r) => start(r.cards, false))
        .catch(() => setPhase("empty"));
    }
  }

  useEffect(load, [mode]);

  const current = queue[0];
  const doneCount = baseDone + completed;

  // Keep the one input focused so the mobile keyboard never closes.
  useEffect(() => {
    if (phase === "input" || phase === "drill") inputRef.current?.focus();
  }, [phase, queue]);

  // Refresh the extra-work counts when the daily set is finished: misses (and the
  // other pools) are generated *during* the session, so the load-time snapshot is
  // stale by the time we show the "Done for today" buttons.
  useEffect(() => {
    if (phase === "done" && mode === "daily") {
      getToday()
        .then((t) =>
          setAvail({
            new: t.newAvailable,
            practice: t.practiceAvailable,
            misses: t.missesAvailable,
          }),
        )
        .catch(() => {});
    }
  }, [phase, mode]);

  // Move past the current card. `drop` removes it; otherwise it rotates to the back
  // to come round again. `counted` bumps the finished-cards tally.
  function next(drop: boolean, counted: boolean) {
    const [head, ...rest] = queue;
    const nextQueue = drop ? rest : [...rest, head];
    if (counted) setCompleted((c) => c + 1);

    setResult(null);
    setTyped("");
    setFlash(null);
    setSubmitting(false);
    if (nextQueue.length === 0) {
      setQueue(nextQueue);
      setPhase("done");
      return;
    }
    setQueue(nextQueue);
    setPhase("input");
    startedAt.current = Date.now();
  }

  async function grade() {
    if (!current || phase !== "input" || submitting) return;
    // Ignore a blank submission (e.g. hitting Enter on an empty field): it isn't a
    // recall attempt, so it shouldn't be graded as a miss.
    if (typed.trim() === "") return;
    setSubmitting(true);
    try {
      const r = await postReview({
        cardId: current.id,
        typedAnswer: typed,
        elapsedMs: Date.now() - startedAt.current,
        bonus: isBonus,
      });
      if (r.correct) {
        setFlash("green");
        setTimeout(() => next(true, true), 160);
      } else {
        // Wrong (all modes, incl. practice): reveal the answer and make them type
        // it to continue; the card rotates to the back to come round again. The
        // miss was already graded on this first-of-day attempt (FSRS Again).
        setResult(r);
        setFlash("red");
        setTyped("");
        setPhase("drill");
        setSubmitting(false);
        setTimeout(() => setFlash(null), 450);
      }
    } catch {
      setSubmitting(false);
    }
  }

  // The drill re-type is judged with the same shared normalizer the server uses
  // to grade the first attempt (case-fold, umlaut/ß tolerance, trailing-punct
  // strip), so "type it to continue" never rejects an answer the server accepted.
  function matchesExpected(value: string) {
    return !!result && normalizeAnswer(value) === normalizeAnswer(result.expected);
  }

  function onSubmit(e: Event) {
    e.preventDefault();
    if (phase === "input") void grade();
    else if (phase === "drill") {
      if (matchesExpected(typed)) next(false, false); // rotate to back, come again
      else {
        setFlash("red");
        setTimeout(() => setFlash(null), 450);
      }
    }
  }

  if (phase === "loading") return <Shell>…</Shell>;

  if (phase === "empty") {
    return (
      <Shell>
        <div class="text-center">
          <p class="text-2xl">🌙</p>
          <p class="mt-2 text-slate-600">
            {mode === "learn"
              ? "No new words to learn right now."
              : mode === "practice"
                ? "Nothing to practice right now."
                : mode === "misses"
                  ? "Nothing to fix — you aced today's words."
                  : "Nothing to do right now. Come back later!"}
          </p>
          <BackButton onDone={onDone} label="Back" />
        </div>
      </Shell>
    );
  }

  if (phase === "done") {
    return (
      <Shell>
        <div class="w-full max-w-sm text-center">
          <p class="text-3xl">🎉</p>
          {mode === "daily" ? (
            <>
              <p class="mt-3 text-2xl font-semibold text-slate-900">Done for today</p>
              <p class="mt-2 text-slate-600">
                {requiredTotal} {requiredTotal === 1 ? "word" : "words"} reviewed. See you tomorrow.
              </p>
              <div class="mt-6">
                <ExtraButtons
                  noun="cards"
                  newAvailable={avail.new}
                  practiceAvailable={avail.practice}
                  missesAvailable={avail.misses}
                  onNew={() => onStartExtra("new")}
                  onPractice={() => onStartExtra("practice")}
                  onMisses={() => onStartExtra("misses")}
                />
              </div>
              <button
                onClick={onDone}
                class="mt-3 text-sm text-slate-500 underline-offset-2 hover:text-slate-900 hover:underline"
              >
                Back to home
              </button>
            </>
          ) : (
            <>
              <p class="mt-3 text-2xl font-semibold text-slate-900">Nice work</p>
              <p class="mt-2 text-slate-600">
                {mode === "learn"
                  ? `${completed} new ${completed === 1 ? "word" : "words"} learned.`
                  : mode === "misses"
                    ? `${completed} ${completed === 1 ? "word" : "words"} fixed.`
                    : `${completed} ${completed === 1 ? "word" : "words"} practiced.`}
              </p>
              <button
                onClick={load}
                class="mt-6 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700"
              >
                {mode === "learn"
                  ? `Learn ${EXTRA_NEW} more`
                  : mode === "misses"
                    ? "Go again"
                    : `Practice ${EXTRA_PRACTICE} more`}
              </button>
              {(mode === "learn"
                ? [{ type: "practice" as const, label: `Practice ${EXTRA_PRACTICE} words 📝` }]
                : mode === "practice"
                  ? [{ type: "new" as const, label: `Pick ${EXTRA_NEW} new words ✋` }]
                  : [
                      { type: "new" as const, label: `Pick ${EXTRA_NEW} new words ✋` },
                      { type: "practice" as const, label: `Practice ${EXTRA_PRACTICE} words 📝` },
                    ]
              ).map((link) => (
                  <button
                    key={link.type}
                    onClick={() => onStartExtra(link.type)}
                    class="mt-3 w-full rounded-xl border border-slate-200 px-5 py-3 font-medium text-slate-700 transition hover:bg-slate-50"
                  >
                    {link.label}
                  </button>
                ))}
              <button
                onClick={onDone}
                class="mt-3 text-sm text-slate-500 underline-offset-2 hover:text-slate-900 hover:underline"
              >
                Back to home
              </button>
            </>
          )}
        </div>
      </Shell>
    );
  }

  const inputBorder =
    flash === "green"
      ? "border-green-500 ring-2 ring-green-200"
      : flash === "red"
        ? "border-red-400 ring-2 ring-red-200"
        : "border-slate-300 focus:border-slate-900";

  return (
    <Shell>
      <div class="w-full max-w-md">
        <div class="mb-2 flex items-center justify-between text-sm text-slate-400">
          {isBonus ? (
            <span>
              {mode === "learn" ? "Learning" : mode === "misses" ? "Repeating" : "Practice"} · +
              {completed}
            </span>
          ) : (
            <span>
              {doneCount} / {requiredTotal} today
            </span>
          )}
          <button onClick={onDone} class="hover:text-slate-700 hover:underline">
            End session
          </button>
        </div>
        {!isBonus && (
          <div class="mb-6 h-1.5 w-full overflow-hidden rounded-full bg-slate-100">
            <div
              class="h-full rounded-full bg-slate-900 transition-all"
              style={{ width: `${requiredTotal ? (doneCount / requiredTotal) * 100 : 0}%` }}
            />
          </div>
        )}
        {isBonus && <div class="mb-6" />}

        <div class="flex items-center justify-center gap-2">
          <span class="text-sm uppercase tracking-wide text-slate-400">
            {current?.partOfSpeech ?? "translate"}
          </span>
          {current && <TierChip tier={current.tier} />}
        </div>
        <h2 class="mt-2 text-center text-3xl font-semibold tracking-tight text-slate-900">
          {current?.prompt}
        </h2>
        {current?.exampleEn && (
          <p class="mt-2 text-center text-sm italic text-slate-400">“{current.exampleEn}”</p>
        )}

        <form onSubmit={onSubmit} class="mt-8">
          <input
            ref={inputRef}
            value={typed}
            onInput={(e) => setTyped((e.target as HTMLInputElement).value)}
            placeholder={phase === "drill" ? "Type it to continue…" : "Type the German…"}
            autocomplete="off"
            autocapitalize="off"
            autocorrect="off"
            spellcheck={false}
            enterkeyhint={phase === "drill" ? "next" : "go"}
            class={`w-full rounded-xl border px-4 py-3 text-lg outline-none transition-colors ${inputBorder}`}
          />

          {phase === "drill" && result && (
            <div class="mt-4 rounded-xl bg-amber-50 px-4 py-3 text-center text-amber-900 ring-1 ring-amber-200">
              <p class="font-medium">
                {result.reason === "missing_article"
                  ? "Almost — don't forget the article"
                  : "Not quite"}
              </p>
              <p class="mt-1 text-lg font-semibold">{result.expected}</p>
              {result.exampleDe && (
                <p class="mt-2 text-sm italic text-amber-800">“{result.exampleDe}”</p>
              )}
              <p class="mt-1 text-xs opacity-70">Type it to continue — you'll see it again later.</p>
            </div>
          )}

          {phase === "input" && (
            <button
              type="submit"
              disabled={submitting}
              class="mt-6 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700 disabled:opacity-50"
            >
              Check
            </button>
          )}
        </form>
      </div>
    </Shell>
  );
}

// The three extra-work on-ramps, shown on a "Done for today" screen (and reused on
// the dashboards). Each button hides when its pool is empty. See EXTRA_WORK.md.
// "Fix misses" re-drills today's wrong answers and reads the live miss count.
export function ExtraButtons({
  noun,
  newAvailable,
  practiceAvailable,
  missesAvailable,
  onNew,
  onPractice,
  onMisses,
}: {
  noun: "cards" | "verbs";
  newAvailable: number;
  practiceAvailable: number;
  missesAvailable: number;
  onNew: () => void;
  onPractice: () => void;
  onMisses: () => void;
}) {
  if (newAvailable === 0 && practiceAvailable === 0 && missesAvailable === 0) return null;
  return (
    <div class="space-y-2">
      {newAvailable > 0 && (
        <button
          onClick={onNew}
          class="w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700"
        >
          Pick {EXTRA_NEW} new {noun} ✋
        </button>
      )}
      {practiceAvailable > 0 && (
        <button
          onClick={onPractice}
          class="w-full rounded-xl border border-slate-200 px-5 py-3 font-medium text-slate-700 transition hover:bg-slate-50"
        >
          Practice {EXTRA_PRACTICE} {noun} 📝
        </button>
      )}
      {missesAvailable > 0 && (
        <button
          onClick={onMisses}
          class="w-full rounded-xl border border-slate-200 px-5 py-3 font-medium text-slate-700 transition hover:bg-slate-50"
        >
          Repeat today's {missesAvailable} {missesAvailable === 1 ? "miss" : "misses"} 🧠
        </button>
      )}
    </div>
  );
}

// A mastery-tier dot shown in the review header, so you know how well you know the
// current card at a glance. Just the colour (label is the hover tooltip) to keep the
// drilling view uncluttered. Colours match the dashboard (tiers.ts).
export function TierChip({ tier }: { tier: MasteryTier }) {
  const t = TIER_BY_KEY[tier];
  return <span class={`h-2.5 w-2.5 rounded-full ${t.dot}`} title={t.label} />;
}

function BackButton({ onDone, label }: { onDone: () => void; label: string }) {
  return (
    <button
      onClick={onDone}
      class="mt-6 rounded-xl bg-slate-900 px-5 py-2.5 font-medium text-white hover:bg-slate-700"
    >
      {label}
    </button>
  );
}

function Shell({ children }: { children: preact.ComponentChildren }) {
  return (
    <div class="flex min-h-screen items-center justify-center bg-white px-5 py-10 text-slate-900">
      {children}
    </div>
  );
}
