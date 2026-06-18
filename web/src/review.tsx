import { useEffect, useRef, useState } from "preact/hooks";
import type { ReviewResult, SessionCard } from "../../shared/types";
import { getSession, postReview } from "./api";

type Phase = "loading" | "input" | "feedback" | "empty" | "done";

export function Review({ onDone }: { onDone: () => void }) {
  const [queue, setQueue] = useState<SessionCard[]>([]);
  const [index, setIndex] = useState(0);
  const [phase, setPhase] = useState<Phase>("loading");
  const [typed, setTyped] = useState("");
  const [result, setResult] = useState<ReviewResult | null>(null);
  const [stats, setStats] = useState({ correct: 0, total: 0 });
  const [submitting, setSubmitting] = useState(false);
  const startedAt = useRef(0);
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    getSession()
      .then((s) => {
        if (s.cards.length === 0) {
          setPhase("empty");
        } else {
          setQueue(s.cards);
          setPhase("input");
          startedAt.current = Date.now();
        }
      })
      .catch(() => setPhase("empty"));
  }, []);

  const current = queue[index];

  useEffect(() => {
    if (phase === "input" || phase === "feedback") inputRef.current?.focus();
  }, [phase, index]);

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
      setStats((s) => ({ correct: s.correct + (r.correct ? 1 : 0), total: s.total + 1 }));
      setPhase("feedback");
    } catch {
      // leave in input phase so they can retry
    } finally {
      setSubmitting(false);
    }
  }

  function advance() {
    setResult(null);
    setTyped("");
    if (index + 1 >= queue.length) {
      setPhase("done");
      return;
    }
    setIndex(index + 1);
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
          <p class="text-2xl">🎉</p>
          <p class="mt-2 text-slate-600">Nothing due right now. Well done!</p>
          <BackButton onDone={onDone} label="Back" />
        </div>
      </Shell>
    );
  }

  if (phase === "done") {
    return (
      <Shell>
        <div class="text-center">
          <p class="text-2xl font-semibold text-slate-900">Session complete</p>
          <p class="mt-2 text-slate-600">
            {stats.correct} / {stats.total} correct
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
        <div class="mb-6 flex items-center justify-between text-sm text-slate-400">
          <span>
            {index + 1} / {queue.length}
          </span>
          <button onClick={onDone} class="hover:text-slate-700 hover:underline">
            End session
          </button>
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
                <p class="mt-1 text-lg font-semibold">{result.expected}</p>
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
