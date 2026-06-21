import { useEffect, useRef, useState } from "preact/hooks";
import type { ReviewResult, SessionCard } from "../../shared/types";
import { getToday, postReview } from "./api";

type Phase = "loading" | "input" | "feedback" | "empty" | "done";

export function Review({ onDone }: { onDone: () => void }) {
  // `queue` holds the cards still needing a correct typing today. We always show
  // queue[0]; a correct answer drops it, a wrong one rotates it to the back so it
  // comes round again — "hammer until correct" (PLAN.md §5a).
  const [queue, setQueue] = useState<SessionCard[]>([]);
  const [phase, setPhase] = useState<Phase>("loading");
  const [typed, setTyped] = useState("");
  const [result, setResult] = useState<ReviewResult | null>(null);
  const [submitting, setSubmitting] = useState(false);
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

  useEffect(() => {
    if (phase === "input" || phase === "feedback") inputRef.current?.focus();
  }, [phase, queue]);

  async function grade() {
    if (!current || phase !== "input" || submitting) return;
    setSubmitting(true);
    try {
      const r = await postReview({
        cardId: current.id,
        typedAnswer: typed,
        elapsedMs: Date.now() - startedAt.current,
      });
      setResult(r);
      setPhase("feedback");
    } catch {
      // leave in input phase so they can retry
    } finally {
      setSubmitting(false);
    }
  }

  function advance() {
    const wasCorrect = result?.correct ?? false;
    const [head, ...rest] = queue;
    // Correct → drop it (one more done). Wrong → send it to the back to re-drill.
    const next = wasCorrect ? rest : [...rest, head];
    if (wasCorrect) setCompleted((c) => c + 1);

    setResult(null);
    setTyped("");
    if (next.length === 0) {
      setQueue(next);
      setPhase("done");
      return;
    }
    setQueue(next);
    setPhase("input");
    startedAt.current = Date.now();
  }

  function onSubmit(e: Event) {
    e.preventDefault();
    if (phase === "input") void grade();
    else if (phase === "feedback") advance();
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

  const banner =
    result &&
    (result.correct
      ? "bg-green-50 text-green-800 ring-green-200"
      : result.reason === "missing_article"
        ? "bg-amber-50 text-amber-900 ring-amber-200"
        : "bg-red-50 text-red-800 ring-red-200");

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
            readOnly={phase === "feedback"}
            onInput={(e) => setTyped((e.target as HTMLInputElement).value)}
            placeholder="Type the German…"
            autocomplete="off"
            autocapitalize="off"
            spellcheck={false}
            class="w-full rounded-xl border border-slate-300 px-4 py-3 text-lg outline-none focus:border-slate-900"
          />

          {phase === "feedback" && result && (
            <div class={`mt-4 rounded-xl px-4 py-3 text-center ring-1 ${banner}`}>
              <p class="font-medium">
                {result.correct
                  ? "Correct"
                  : result.reason === "missing_article"
                    ? "Almost — don't forget the article"
                    : "Not quite"}
              </p>
              {!result.correct && (
                <>
                  <p class="mt-1 text-lg font-semibold">{result.expected}</p>
                  <p class="mt-1 text-xs opacity-70">You'll see this again before you're done.</p>
                </>
              )}
            </div>
          )}

          <button
            type="submit"
            disabled={submitting}
            class="mt-6 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700 disabled:opacity-50"
          >
            {phase === "feedback" ? "Continue" : "Check"}
          </button>
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
