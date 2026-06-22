import { useEffect, useRef, useState } from "preact/hooks";
import type { ReviewResult, SessionCard } from "../../shared/types";
import { getToday, postReview } from "./api";

// `input` = typing the answer from recall (graded on the server).
// `drill`  = got it wrong, now copying the revealed answer to continue.
type Phase = "loading" | "input" | "drill" | "empty" | "done";

export function Review({ onDone }: { onDone: () => void }) {
  // `queue` holds the cards still needing a correct typing today. We always show
  // queue[0]; a correct answer drops it, a wrong one rotates it to the back so it
  // comes round again — "hammer until correct" (PLAN.md §5a).
  const [queue, setQueue] = useState<SessionCard[]>([]);
  const [phase, setPhase] = useState<Phase>("loading");
  const [typed, setTyped] = useState("");
  const [result, setResult] = useState<ReviewResult | null>(null);
  const [submitting, setSubmitting] = useState(false);
  // Transient border flash that gives correct/wrong feedback without a screen
  // change, so the keyboard never has to close. Cleared by a timer.
  const [flash, setFlash] = useState<"green" | "red" | null>(null);
  // Today's required total and how many were already done before this session.
  const [requiredTotal, setRequiredTotal] = useState(0);
  const [baseDone, setBaseDone] = useState(0);
  const [completed, setCompleted] = useState(0); // unique cards finished this session
  const startedAt = useRef(0);
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    getToday()
      .then((t) => {
        setRequiredTotal(t.dueTotal + t.newTotal);
        setBaseDone(t.done);
        if (t.cards.length === 0) {
          // No pending cards: either today's work is finished, or there was none.
          setPhase(t.dueTotal + t.newTotal > 0 ? "done" : "empty");
        } else {
          setQueue(t.cards);
          setPhase("input");
          startedAt.current = Date.now();
        }
      })
      .catch(() => setPhase("empty"));
  }, []);

  const current = queue[0];
  const doneCount = baseDone + completed;

  // Keep the one input focused so the mobile keyboard never closes. iOS won't
  // *reopen* a keyboard programmatically, so the whole loop is built to never
  // blur: a single persistent input, submit via the return key, auto-advance.
  useEffect(() => {
    if (phase === "input" || phase === "drill") inputRef.current?.focus();
  }, [phase, queue]);

  // Move past the current card. Correct → drop it (one more done). Wrong → send
  // it to the back so it comes round again for a real recall test (PLAN.md §5a).
  function advance(wasCorrect: boolean) {
    const [head, ...rest] = queue;
    const next = wasCorrect ? rest : [...rest, head];
    if (wasCorrect) setCompleted((c) => c + 1);

    setResult(null);
    setTyped("");
    setFlash(null);
    setSubmitting(false);
    if (next.length === 0) {
      setQueue(next);
      setPhase("done");
      return;
    }
    setQueue(next);
    setPhase("input");
    startedAt.current = Date.now();
  }

  async function grade() {
    if (!current || phase !== "input" || submitting) return;
    setSubmitting(true);
    try {
      const r = await postReview({
        cardId: current.id,
        typedAnswer: typed,
        elapsedMs: Date.now() - startedAt.current,
      });
      if (r.correct) {
        // Flash green, then move on — no separate "success" screen or tap.
        setFlash("green");
        setTimeout(() => advance(true), 160);
      } else {
        // Reveal the answer and make them type it to continue (the drill).
        setResult(r);
        setFlash("red");
        setTyped("");
        setPhase("drill");
        setSubmitting(false);
        setTimeout(() => setFlash(null), 450);
      }
    } catch {
      // leave in input phase so they can retry
      setSubmitting(false);
    }
  }

  // In the drill, the answer is on screen — they just have to reproduce it and
  // press enter (same gesture as the recall input). Typing the right answer but
  // not matching on enter just leaves them in the drill.
  function matchesExpected(value: string) {
    return !!result && value.trim() === result.expected.trim();
  }

  function onSubmit(e: Event) {
    e.preventDefault();
    if (phase === "input") void grade();
    else if (phase === "drill") {
      if (matchesExpected(typed)) advance(false);
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
          <p class="mt-2 text-slate-600">Nothing to do right now. Come back later!</p>
          <BackButton onDone={onDone} label="Back" />
        </div>
      </Shell>
    );
  }

  if (phase === "done") {
    return (
      <Shell>
        <div class="text-center">
          <p class="text-3xl">🎉</p>
          <p class="mt-3 text-2xl font-semibold text-slate-900">Done for today</p>
          <p class="mt-2 text-slate-600">
            {requiredTotal} {requiredTotal === 1 ? "word" : "words"} reviewed. See you tomorrow.
          </p>
          <BackButton onDone={onDone} label="Back to home" />
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
          <span>
            {doneCount} / {requiredTotal} today
          </span>
          <button onClick={onDone} class="hover:text-slate-700 hover:underline">
            End session
          </button>
        </div>
        <div class="mb-6 h-1.5 w-full overflow-hidden rounded-full bg-slate-100">
          <div
            class="h-full rounded-full bg-slate-900 transition-all"
            style={{ width: `${requiredTotal ? (doneCount / requiredTotal) * 100 : 0}%` }}
          />
        </div>

        <p class="text-center text-sm uppercase tracking-wide text-slate-400">
          {current?.partOfSpeech ?? "translate"}
        </p>
        <h2 class="mt-2 text-center text-3xl font-semibold tracking-tight text-slate-900">
          {current?.prompt}
        </h2>

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
