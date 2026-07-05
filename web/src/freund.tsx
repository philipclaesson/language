import { useEffect, useRef, useState } from "preact/hooks";
import type {
  CorrectionSegment,
  FreundMessage,
  FreundSuggestedCard,
} from "../../shared/types";
import { postFreundCards, postFreundMessage, postFreundReview } from "./api";

// A rendered conversation turn. A user turn shows the learner's message — replaced
// in place by the diffed correction once Freund's reply comes back, so a fixed
// message reads as if it were magically corrected. Freund's turns carry the German
// reply plus an optional English explanation of the mistake.
type Turn =
  | { role: "user"; content: string; correction: CorrectionSegment[] | null }
  | { role: "assistant"; reply: string; explanation: string | null };

// The end-of-conversation card review flow.
type Suggestion = { card: FreundSuggestedCard; accepted: boolean };
type Review =
  | { status: "off" }
  | { status: "loading" }
  | { status: "ready"; suggestions: Suggestion[] }
  | { status: "saving"; suggestions: Suggestion[] }
  | { status: "saved"; added: number; deckName: string }
  | { status: "error" };

const OPENERS = [
  "Hallo! Wie geht es dir heute?",
  "Erzähl mir von deinem Tag.",
  "Worüber möchtest du sprechen?",
];

function fullCard(c: FreundSuggestedCard): string {
  return c.article ? `${c.article} ${c.answer}` : c.answer;
}

// Only the German replies are replayed to the model as history (corrections are
// display-only). User turns send their raw text.
function toHistory(turns: Turn[]): FreundMessage[] {
  return turns.map((t) =>
    t.role === "user"
      ? { role: "user", content: t.content }
      : { role: "assistant", content: t.reply },
  );
}

/** Freund: chat in German, get gently corrected, and bank your misses as cards. */
export function Freund() {
  const [turns, setTurns] = useState<Turn[]>([]);
  const [input, setInput] = useState("");
  const [sending, setSending] = useState(false);
  const [error, setError] = useState(false);
  const [review, setReview] = useState<Review>({ status: "off" });
  const endRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    endRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [turns, sending]);

  const hasExchange = turns.some((t) => t.role === "assistant");

  async function send(text: string) {
    const message = text.trim();
    if (!message || sending) return;
    setError(false);
    setInput("");

    const next: Turn[] = [...turns, { role: "user", content: message, correction: null }];
    setTurns(next);
    setSending(true);
    try {
      const res = await postFreundMessage(toHistory(next));
      // Fold the correction back onto the message it corrects (the last user turn),
      // so it visibly replaces what the learner typed.
      const corrected = next.map((t, i) =>
        i === next.length - 1 && t.role === "user" && res.correction
          ? { ...t, correction: res.correction }
          : t,
      );
      setTurns([
        ...corrected,
        { role: "assistant", reply: res.reply, explanation: res.explanation },
      ]);
    } catch {
      setError(true);
      setTurns(next); // keep the user's message so they can retry
    } finally {
      setSending(false);
    }
  }

  async function endConversation() {
    setReview({ status: "loading" });
    try {
      const res = await postFreundReview(toHistory(turns));
      setReview({
        status: "ready",
        suggestions: res.cards.map((card) => ({ card, accepted: true })),
      });
    } catch {
      setReview({ status: "error" });
    }
  }

  function newConversation() {
    setTurns([]);
    setInput("");
    setError(false);
    setReview({ status: "off" });
  }

  if (review.status !== "off") {
    return (
      <ReviewPanel review={review} setReview={setReview} onDone={newConversation} />
    );
  }

  return (
    <div class="mx-auto flex h-screen max-w-md flex-col px-5 pb-20 pt-6">
      <header class="flex items-center justify-between">
        <h1 class="text-base font-semibold tracking-tight text-slate-900">Freund 🗣️</h1>
        {hasExchange && (
          <button
            onClick={endConversation}
            class="rounded-full border border-slate-200 px-3 py-1 text-xs font-medium text-slate-600 transition hover:border-slate-300 hover:text-slate-900"
          >
            End conversation
          </button>
        )}
      </header>

      <main class="mt-4 flex-1 space-y-4 overflow-y-auto">
        {turns.length === 0 && (
          <div class="rounded-2xl bg-slate-50 p-5">
            <p class="text-slate-600">
              Chat with Freund in German. He replies, keeps the conversation going, and
              corrects your mistakes as you go. Kick it off:
            </p>
            <div class="mt-3 space-y-2">
              {OPENERS.map((ex) => (
                <button
                  key={ex}
                  onClick={() => send(ex)}
                  class="block w-full rounded-xl border border-slate-200 px-3 py-2 text-left text-sm text-slate-700 transition-colors hover:border-slate-300 hover:bg-white"
                >
                  {ex}
                </button>
              ))}
            </div>
          </div>
        )}

        {turns.map((t, i) =>
          t.role === "user" ? (
            <div key={i} class="flex justify-end">
              <div class="max-w-[85%] whitespace-pre-wrap rounded-2xl rounded-br-sm bg-slate-900 px-4 py-2.5 text-white">
                {t.correction ? <CorrectionLine segments={t.correction} /> : t.content}
              </div>
            </div>
          ) : (
            <BotTurn key={i} turn={t} />
          ),
        )}

        {sending && (
          <div class="flex justify-start">
            <div class="rounded-2xl rounded-bl-sm bg-slate-100 px-4 py-2.5 text-slate-400">…</div>
          </div>
        )}
        {error && (
          <p class="text-center text-sm text-red-500">Something went wrong. Try again.</p>
        )}
        <div ref={endRef} />
      </main>

      <form
        class="mt-3 flex gap-2"
        onSubmit={(e) => {
          e.preventDefault();
          send(input);
        }}
      >
        <input
          value={input}
          onInput={(e) => setInput((e.target as HTMLInputElement).value)}
          placeholder="Schreib auf Deutsch…"
          disabled={sending}
          class="flex-1 rounded-xl border border-slate-200 px-4 py-3 text-slate-900 outline-none focus:border-slate-400 disabled:opacity-50"
        />
        <button
          type="submit"
          disabled={sending || !input.trim()}
          class="rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700 disabled:opacity-40"
        >
          Send
        </button>
      </form>
    </div>
  );
}

// One Freund turn: an optional English error note (yellow), then the German reply.
// The correction now lives in the learner's own bubble (rendered in place there).
function BotTurn({ turn }: { turn: Extract<Turn, { role: "assistant" }> }) {
  return (
    <div class="flex flex-col items-start gap-1.5">
      {turn.explanation && (
        <div class="max-w-[85%] rounded-2xl rounded-bl-sm bg-amber-50 px-4 py-2.5 text-sm text-amber-900 ring-1 ring-amber-100">
          {turn.explanation}
        </div>
      )}
      <div class="max-w-[85%] whitespace-pre-wrap rounded-2xl rounded-bl-sm bg-slate-100 px-4 py-2.5 text-slate-900">
        {turn.reply}
      </div>
    </div>
  );
}

// Render the word-diff inside the learner's (dark) message bubble: deleted words
// struck through and dimmed, inserted words emphasized in green, unchanged words
// plain white. Segments are word-runs joined by spaces.
function CorrectionLine({ segments }: { segments: CorrectionSegment[] }) {
  return (
    <span>
      {segments.map((s, i) => (
        <span key={i}>
          {i > 0 && " "}
          {s.op === "del" ? (
            <span class="text-red-300/80 line-through">{s.text}</span>
          ) : s.op === "ins" ? (
            <span class="font-medium italic text-emerald-300">{s.text}</span>
          ) : (
            <span>{s.text}</span>
          )}
        </span>
      ))}
    </span>
  );
}

// End-of-conversation card review: accept/reject the suggestions, then save the
// accepted ones into the shared "Freund cards" deck.
function ReviewPanel({
  review,
  setReview,
  onDone,
}: {
  review: Review;
  setReview: (r: Review) => void;
  onDone: () => void;
}) {
  const suggestions =
    review.status === "ready" || review.status === "saving" ? review.suggestions : [];
  const acceptedCount = suggestions.filter((s) => s.accepted).length;

  function toggle(idx: number) {
    if (review.status !== "ready") return;
    setReview({
      status: "ready",
      suggestions: review.suggestions.map((s, i) =>
        i === idx ? { ...s, accepted: !s.accepted } : s,
      ),
    });
  }

  function rejectAll() {
    if (review.status !== "ready") return;
    setReview({
      status: "ready",
      suggestions: review.suggestions.map((s) => ({ ...s, accepted: false })),
    });
  }

  async function save() {
    if (review.status !== "ready") return;
    const accepted = review.suggestions.filter((s) => s.accepted).map((s) => s.card);
    if (accepted.length === 0) return;
    setReview({ status: "saving", suggestions: review.suggestions });
    try {
      const res = await postFreundCards(accepted);
      setReview({ status: "saved", added: res.added, deckName: res.deckName });
    } catch {
      setReview({ status: "error" });
    }
  }

  return (
    <div class="mx-auto flex min-h-screen max-w-md flex-col px-5 pb-24 pt-10">
      <header class="text-center">
        <h1 class="text-2xl font-semibold tracking-tight text-slate-900">Schönes Gespräch! 👋</h1>
      </header>

      <main class="mt-8 flex-1">
        {review.status === "loading" && (
          <p class="text-center text-slate-400">Looking over the conversation…</p>
        )}

        {review.status === "error" && (
          <div class="text-center">
            <p class="text-red-500">Something went wrong reviewing the chat.</p>
            <button
              onClick={onDone}
              class="mt-6 rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700"
            >
              New conversation
            </button>
          </div>
        )}

        {review.status === "saved" && (
          <div class="text-center">
            <p class="text-lg text-slate-700">
              Added <span class="font-semibold">{review.added}</span>{" "}
              {review.added === 1 ? "card" : "cards"} to{" "}
              <span class="font-medium">{review.deckName}</span> ✓
            </p>
            <button
              onClick={onDone}
              class="mt-6 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700"
            >
              New conversation
            </button>
          </div>
        )}

        {(review.status === "ready" || review.status === "saving") && (
          <>
            {suggestions.length === 0 ? (
              <div class="text-center">
                <p class="text-slate-600">No mistakes worth drilling — well done! 🎉</p>
                <button
                  onClick={onDone}
                  class="mt-6 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700"
                >
                  New conversation
                </button>
              </div>
            ) : (
              <>
                <p class="text-slate-500">
                  Cards for what you missed. Uncheck any you don't want.
                </p>
                <ul class="mt-4 space-y-2">
                  {suggestions.map((s, i) => (
                    <li key={i}>
                      <button
                        onClick={() => toggle(i)}
                        disabled={review.status === "saving"}
                        class={`flex w-full items-start gap-3 rounded-xl border px-4 py-3 text-left transition ${
                          s.accepted
                            ? "border-slate-300 bg-white"
                            : "border-slate-200 bg-slate-50 opacity-60"
                        }`}
                      >
                        <span
                          class={`mt-0.5 flex h-5 w-5 flex-none items-center justify-center rounded-md border text-xs ${
                            s.accepted
                              ? "border-slate-900 bg-slate-900 text-white"
                              : "border-slate-300 text-transparent"
                          }`}
                        >
                          ✓
                        </span>
                        <span class="min-w-0">
                          <span class="block text-slate-900">{s.card.prompt}</span>
                          <span class="block text-sm text-slate-500">
                            {fullCard(s.card)}
                            {s.card.partOfSpeech ? ` · ${s.card.partOfSpeech}` : ""}
                          </span>
                        </span>
                      </button>
                    </li>
                  ))}
                </ul>

                <div class="mt-6 flex gap-2">
                  <button
                    onClick={rejectAll}
                    disabled={review.status === "saving" || acceptedCount === 0}
                    class="flex-1 rounded-xl border border-slate-200 px-4 py-3 font-medium text-slate-600 transition hover:border-slate-300 disabled:opacity-40"
                  >
                    Reject all
                  </button>
                  <button
                    onClick={save}
                    disabled={review.status === "saving" || acceptedCount === 0}
                    class="flex-1 rounded-xl bg-slate-900 px-4 py-3 font-medium text-white transition hover:bg-slate-700 disabled:opacity-40"
                  >
                    {review.status === "saving"
                      ? "Adding…"
                      : `Add ${acceptedCount} ${acceptedCount === 1 ? "card" : "cards"}`}
                  </button>
                </div>
                <button
                  onClick={onDone}
                  disabled={review.status === "saving"}
                  class="mt-3 w-full py-2 text-center text-sm text-slate-400 transition hover:text-slate-600 disabled:opacity-40"
                >
                  Skip — don't add any
                </button>
              </>
            )}
          </>
        )}
      </main>
    </div>
  );
}
