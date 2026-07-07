import { useEffect, useRef, useState } from "preact/hooks";
import type {
  Conjugation,
  ExtraType,
  SessionVerb,
  VerbForm,
  VerbListItem,
  VerbProgressResponse,
  VerbReviewResult,
  VerbTodayResponse,
} from "../../shared/types";
import { EXTRA_NEW, EXTRA_PRACTICE, VERB_FORMS, VERB_FORM_LABELS } from "../../shared/types";
import { getVerbExtra, getVerbList, getVerbProgress, getVerbToday, postVerbReview } from "./api";
import { ExtraButtons, extraTypeOf, TierChip, type ReviewMode } from "./review";
import { TIERS, TIER_BY_KEY } from "./tiers";

const emptyConj = (): Conjugation => ({ ich: "", du: "", er: "", wir: "", ihr: "", sie: "" });

// Client-side normalization mirroring the server's (srs/check.ts) umlaut/ß
// tolerance, used only to decide when the drill's re-typed forms are correct.
function norm(s: string): string {
  return s
    .normalize("NFC")
    .trim()
    .toLowerCase()
    .replace(/\s+/g, " ")
    .replace(/ä/g, "ae")
    .replace(/ö/g, "oe")
    .replace(/ü/g, "ue")
    .replace(/ß/g, "ss");
}

function RegularityTag({ regularity }: { regularity: string }) {
  const irregular = regularity === "irregular";
  return (
    <span
      class={`rounded-full px-2 py-0.5 text-xs font-medium ${
        irregular ? "bg-rose-100 text-rose-700" : "bg-emerald-100 text-emerald-700"
      }`}
    >
      {irregular ? "irregular" : "regular"}
    </span>
  );
}

// ---- Verbs dashboard (tab root) ----

export function VerbsHome({
  onStart,
  onOpenList,
  onStartExtra,
}: {
  onStart: () => void;
  onOpenList: () => void;
  onStartExtra: (type: ExtraType) => void;
}) {
  const [today, setToday] = useState<VerbTodayResponse | null>(null);
  const [progress, setProgress] = useState<VerbProgressResponse | null>(null);

  useEffect(() => {
    getVerbToday().then(setToday).catch(() => setToday(null));
    getVerbProgress().then(setProgress).catch(() => setProgress(null));
  }, []);

  const requiredTotal = today ? today.dueTotal + today.newTotal : 0;
  const pending = today?.pending ?? 0;
  const started = (today?.done ?? 0) > 0;
  const canReview = pending > 0; // else offer extra work (done today, or nothing due)

  return (
    <div class="mx-auto flex min-h-screen max-w-md flex-col px-5 pb-24 pt-10">
      <header>
        <h1 class="text-2xl font-semibold tracking-tight text-slate-900">Verbs</h1>
        <p class="mt-1 text-slate-500">Drill the six present-tense forms.</p>
      </header>

      <main class="mt-8">
        <div class="rounded-2xl bg-slate-50 p-5 text-center">
          <div class="text-slate-900">
            {today === null ? (
              <p class="text-slate-400">…</p>
            ) : requiredTotal === 0 ? (
              <p class="text-slate-600">Nothing due right now. 🌙</p>
            ) : pending === 0 ? (
              <p class="text-lg text-slate-600">
                Done for today 🎉 <span class="text-slate-400">({requiredTotal})</span>
              </p>
            ) : (
              <p class="text-lg">
                <span class="font-semibold">{pending}</span> to conjugate today
                <span class="block text-sm text-slate-400">
                  {today.done} / {requiredTotal} done
                </span>
              </p>
            )}
          </div>
          {today && today.bonusToday > 0 && (
            <p class="mt-2 text-sm text-slate-400">
              +{today.bonusToday} extra {today.bonusToday === 1 ? "verb" : "verbs"} today ✨
            </p>
          )}
          {canReview && (
            <button
              onClick={onStart}
              class="mt-4 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700"
            >
              {started ? "Continue" : "Start verbs"}
            </button>
          )}
          {!canReview && today && (
            <div class="mt-4">
              <ExtraButtons
                noun="verbs"
                newAvailable={today.newAvailable}
                practiceAvailable={today.practiceAvailable}
                missesAvailable={today.missesAvailable}
                onNew={() => onStartExtra("new")}
                onPractice={() => onStartExtra("practice")}
                onMisses={() => onStartExtra("misses")}
              />
            </div>
          )}
        </div>

        <VerbMasteryCard progress={progress} onClick={onOpenList} />
      </main>
    </div>
  );
}

function VerbMasteryCard({
  progress,
  onClick,
}: {
  progress: VerbProgressResponse | null;
  onClick: () => void;
}) {
  if (!progress) return null;
  const { tiers, mastered, total } = progress;

  return (
    <button
      onClick={onClick}
      class="mt-4 block w-full rounded-2xl border border-slate-200 p-5 text-left transition-colors hover:border-slate-300 hover:bg-slate-50"
    >
      <div class="flex items-baseline justify-between">
        <div>
          <span class="text-3xl font-semibold tracking-tight text-slate-900">{mastered}</span>
          <span class="ml-2 text-slate-500">verbs mastered</span>
        </div>
        <span class="text-sm text-slate-400">{total} total →</span>
      </div>

      {total > 0 && (
        <>
          <div class="mt-4 flex h-2.5 w-full overflow-hidden rounded-full bg-slate-100">
            {TIERS.map((t) =>
              tiers[t.key] > 0 ? (
                <div
                  key={t.key}
                  class={t.bar}
                  style={{ width: `${(tiers[t.key] / total) * 100}%` }}
                  title={`${t.label}: ${tiers[t.key]}`}
                />
              ) : null,
            )}
          </div>
          <div class="mt-3 flex flex-wrap gap-x-4 gap-y-1 text-xs text-slate-500">
            {TIERS.map((t) => (
              <span key={t.key} class="inline-flex items-center gap-1.5">
                <span class={`h-2 w-2 rounded-full ${t.dot}`} />
                {t.label} <span class="font-medium text-slate-700">{tiers[t.key]}</span>
              </span>
            ))}
          </div>
        </>
      )}
    </button>
  );
}

// ---- Browse all verbs (reference view, like a deck detail) ----

export function VerbAllView({ onBack }: { onBack: () => void }) {
  const [verbs, setVerbs] = useState<VerbListItem[] | null>(null);
  const [err, setErr] = useState(false);

  useEffect(() => {
    getVerbList().then(setVerbs).catch(() => setErr(true));
  }, []);

  return (
    <div class="mx-auto min-h-screen max-w-md px-5 py-10">
      <button onClick={onBack} class="text-sm text-slate-500 hover:text-slate-900 hover:underline">
        ← Back
      </button>

      {err ? (
        <p class="mt-8 text-slate-500">Couldn't load verbs.</p>
      ) : verbs === null ? (
        <p class="mt-8 text-slate-400">…</p>
      ) : (
        <>
          <h1 class="mt-4 text-2xl font-semibold tracking-tight text-slate-900">All verbs</h1>
          <div class="mt-3 flex flex-wrap gap-x-4 gap-y-1 text-xs text-slate-400">
            <span>{verbs.length} verbs</span>
            {TIERS.map((t) => (
              <span key={t.key} class="flex items-center gap-1">
                <span class={`h-2 w-2 rounded-full ${t.dot}`} /> {t.label.toLowerCase()}
              </span>
            ))}
          </div>

          <ul class="mt-6 divide-y divide-slate-100">
            {verbs.map((v) => (
              <li key={v.id} class="flex items-center gap-3 py-3">
                <span
                  class={`h-2 w-2 shrink-0 rounded-full ${TIER_BY_KEY[v.tier].dot}`}
                  title={TIER_BY_KEY[v.tier].label}
                />
                <div class="min-w-0 flex-1">
                  <p class="truncate font-medium text-slate-900">{v.infinitive}</p>
                  <p class="truncate text-xs text-slate-400">{v.english}</p>
                </div>
                <RegularityTag regularity={v.regularity} />
              </li>
            ))}
          </ul>
        </>
      )}
    </div>
  );
}

// ---- Verb review loop ----

// `input` = filling in the six forms from recall (graded on the server).
// `drill` = got it wrong; correct forms revealed, re-type the wrong rows to continue
//           (correct rows stay locked). All modes hammer until correct — a miss
//           rotates the verb to the back to come round again.
type Phase = "loading" | "input" | "drill" | "empty" | "done";

export function VerbReview({
  mode = "daily",
  onDone,
  onStartExtra,
}: {
  mode?: ReviewMode;
  onDone: () => void;
  onStartExtra: (type: ExtraType) => void;
}) {
  const [queue, setQueue] = useState<SessionVerb[]>([]);
  const [phase, setPhase] = useState<Phase>("loading");
  const [typed, setTyped] = useState<Conjugation>(emptyConj());
  const [result, setResult] = useState<VerbReviewResult | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [flash, setFlash] = useState<"green" | "red" | null>(null);
  const [requiredTotal, setRequiredTotal] = useState(0);
  const [baseDone, setBaseDone] = useState(0);
  const [avail, setAvail] = useState({ new: 0, practice: 0, misses: 0 });
  const [completed, setCompleted] = useState(0);
  const startedAt = useRef(0);
  const inputRefs = useRef<Partial<Record<VerbForm, HTMLInputElement | null>>>({});

  const isBonus = mode !== "daily";

  function load() {
    setPhase("loading");
    setResult(null);
    setTyped(emptyConj());
    setFlash(null);
    setCompleted(0);
    setSubmitting(false);
    const start = (verbs: SessionVerb[], hadRequired: boolean) => {
      if (verbs.length === 0) {
        setPhase(hadRequired ? "done" : "empty");
      } else {
        setQueue(verbs);
        setPhase("input");
        startedAt.current = Date.now();
      }
    };
    if (mode === "daily") {
      getVerbToday()
        .then((t) => {
          setRequiredTotal(t.dueTotal + t.newTotal);
          setBaseDone(t.done);
          setAvail({
            new: t.newAvailable,
            practice: t.practiceAvailable,
            misses: t.missesAvailable,
          });
          start(t.verbs, t.dueTotal + t.newTotal > 0);
        })
        .catch(() => setPhase("empty"));
    } else {
      getVerbExtra(extraTypeOf(mode))
        .then((r) => start(r.verbs, false))
        .catch(() => setPhase("empty"));
    }
  }

  useEffect(load, [mode]);

  const current = queue[0];
  const doneCount = baseDone + completed;

  // In the drill only the previously-wrong rows are editable; in input, all six;
  // in reveal, none.
  const editableForms = (): VerbForm[] =>
    phase === "drill" && result
      ? VERB_FORMS.filter((f) => !result.perForm[f])
      : [...VERB_FORMS];

  useEffect(() => {
    if (phase !== "input" && phase !== "drill") return;
    const first = editableForms()[0];
    if (first) inputRefs.current[first]?.focus();
  }, [phase, queue]);

  // Refresh the extra-work counts when the daily set is finished: misses (and the
  // other pools) are generated *during* the session, so the load-time snapshot is
  // stale by the time we show the "Done for today" buttons.
  useEffect(() => {
    if (phase === "done" && mode === "daily") {
      getVerbToday()
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

  function next(drop: boolean, counted: boolean) {
    const [head, ...rest] = queue;
    const nextQueue = drop ? rest : [...rest, head];
    if (counted) setCompleted((c) => c + 1);

    setResult(null);
    setTyped(emptyConj());
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
    // Ignore a fully-blank submission (e.g. hitting Enter with no forms filled): it
    // isn't a recall attempt, so it shouldn't be graded as a miss.
    if (VERB_FORMS.every((f) => typed[f].trim() === "")) return;
    setSubmitting(true);
    try {
      const r = await postVerbReview({
        verbId: current.id,
        typed,
        elapsedMs: Date.now() - startedAt.current,
        bonus: isBonus,
      });
      if (r.correct) {
        setFlash("green");
        setTimeout(() => next(true, true), 200);
      } else {
        // Wrong (all modes, incl. practice): keep correct rows filled + locked,
        // clear the wrong rows to re-type; the verb rotates to the back. The miss
        // was already graded on this first-of-day attempt (FSRS Again).
        setResult(r);
        const revealed = emptyConj();
        for (const f of VERB_FORMS) revealed[f] = r.perForm[f] ? r.expected[f] : "";
        setTyped(revealed);
        setFlash("red");
        setPhase("drill");
        setSubmitting(false);
        setTimeout(() => setFlash(null), 450);
      }
    } catch {
      setSubmitting(false);
    }
  }

  // Drill: continue once every previously-wrong row matches the revealed form.
  function drillSubmit() {
    if (!result) return;
    const allFixed = editableForms().every((f) => norm(typed[f]) === norm(result.expected[f]));
    if (allFixed) next(false, false); // rotate to back, come again
    else {
      setFlash("red");
      setTimeout(() => setFlash(null), 450);
    }
  }

  function submit() {
    if (phase === "input") void grade();
    else if (phase === "drill") drillSubmit();
  }

  function onKey(e: KeyboardEvent, form: VerbForm) {
    if (e.key !== "Enter") return;
    e.preventDefault();
    const editable = editableForms();
    const idx = editable.indexOf(form);
    if (idx >= 0 && idx < editable.length - 1) {
      inputRefs.current[editable[idx + 1]]?.focus();
    } else {
      submit();
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
              ? "No new verbs to learn right now."
              : mode === "practice"
                ? "No verbs to practice right now."
                : mode === "misses"
                  ? "Nothing to fix — you aced today's verbs."
                  : "No verbs to do right now. Come back later!"}
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
                {requiredTotal} {requiredTotal === 1 ? "verb" : "verbs"} conjugated. See you tomorrow.
              </p>
              <div class="mt-6">
                <ExtraButtons
                  noun="verbs"
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
                Back to verbs
              </button>
            </>
          ) : (
            <>
              <p class="mt-3 text-2xl font-semibold text-slate-900">Nice work</p>
              <p class="mt-2 text-slate-600">
                {mode === "learn"
                  ? `${completed} new ${completed === 1 ? "verb" : "verbs"} learned.`
                  : mode === "misses"
                    ? `${completed} ${completed === 1 ? "verb" : "verbs"} fixed.`
                    : `${completed} ${completed === 1 ? "verb" : "verbs"} practiced.`}
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
                ? [{ type: "practice" as const, label: `Practice ${EXTRA_PRACTICE} verbs 📝` }]
                : mode === "practice"
                  ? [{ type: "new" as const, label: `Pick ${EXTRA_NEW} new verbs ✋` }]
                  : [
                      { type: "new" as const, label: `Pick ${EXTRA_NEW} new verbs ✋` },
                      { type: "practice" as const, label: `Practice ${EXTRA_PRACTICE} verbs 📝` },
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
                Back to verbs
              </button>
            </>
          )}
        </div>
      </Shell>
    );
  }

  const editable = new Set(editableForms());

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
        {!isBonus ? (
          <div class="mb-6 h-1.5 w-full overflow-hidden rounded-full bg-slate-100">
            <div
              class="h-full rounded-full bg-slate-900 transition-all"
              style={{ width: `${requiredTotal ? (doneCount / requiredTotal) * 100 : 0}%` }}
            />
          </div>
        ) : (
          <div class="mb-6" />
        )}

        <div class="flex items-center justify-center gap-2">
          {current && <RegularityTag regularity={current.regularity} />}
          {current && <TierChip tier={current.tier} />}
        </div>
        <h2 class="mt-2 text-center text-3xl font-semibold tracking-tight text-slate-900">
          {current?.infinitive}
        </h2>
        <p class="mt-1 text-center text-slate-400">{current?.english}</p>

        <div class="mt-6 space-y-2">
          {VERB_FORMS.map((f) => {
            const isEditable = editable.has(f);
            const wrongInDrill = phase === "drill" && result && !result.perForm[f];
            const border = wrongInDrill
              ? "border-red-300 focus:border-red-500"
              : phase === "drill" && !isEditable
                ? "border-emerald-200 bg-emerald-50 text-emerald-800"
                : flash === "green"
                  ? "border-green-500"
                  : flash === "red"
                    ? "border-red-400"
                    : "border-slate-300 focus:border-slate-900";
            return (
              <div key={f} class="flex items-start gap-3">
                <label class="w-20 shrink-0 pt-2.5 text-right text-sm text-slate-500">
                  {VERB_FORM_LABELS[f]}
                </label>
                <div class="flex-1">
                  <input
                    ref={(el) => {
                      inputRefs.current[f] = el;
                    }}
                    value={typed[f]}
                    disabled={!isEditable}
                    onInput={(e) =>
                      setTyped((t) => ({ ...t, [f]: (e.target as HTMLInputElement).value }))
                    }
                    onKeyDown={(e) => onKey(e, f)}
                    placeholder={isEditable ? "…" : ""}
                    autocomplete="off"
                    autocapitalize="off"
                    autocorrect="off"
                    spellcheck={false}
                    enterkeyhint={f === "sie" ? "go" : "next"}
                    class={`w-full rounded-lg border px-3 py-2 text-lg outline-none transition-colors disabled:opacity-90 ${border}`}
                  />
                  {wrongInDrill && result && (
                    <p class="mt-0.5 text-xs text-amber-700">
                      correct: <span class="font-semibold">{result.expected[f]}</span>
                    </p>
                  )}
                </div>
              </div>
            );
          })}
        </div>

        {phase === "drill" && result && (
          <div class="mt-4 rounded-xl bg-amber-50 px-4 py-3 text-center text-sm text-amber-900 ring-1 ring-amber-200">
            <p class="font-medium">Not quite — type the correct forms shown to continue.</p>
            <p class="mt-1 opacity-70">You'll see this verb again later.</p>
          </div>
        )}

        <button
          onClick={submit}
          disabled={submitting}
          class="mt-6 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700 disabled:opacity-50"
        >
          {phase === "input" ? "Check" : "Continue"}
        </button>
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
