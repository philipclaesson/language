import { useEffect, useRef, useState } from "preact/hooks";
import { marked } from "marked";
import type { ChatAction, ChatMessage } from "../../shared/types";
import { postChat } from "./api";

type Turn = ChatMessage & { actions?: ChatAction[] };

// We render only the assistant's own replies as Markdown (bold, lists, tables).
// User messages stay plain text, so anything the learner types can never be
// interpreted as HTML — the only content turned into markup is Claude's output.
function renderMarkdown(md: string): string {
  return marked.parse(md, { gfm: true, breaks: true, async: false });
}

const EXAMPLES = [
  "Build a deck of the 10 most common irregular German verbs",
  "When do I use möchte vs. hätte?",
  "Add the days of the week to a new deck",
];

/** The AI tutor chat: talk through German, build decks as you go. */
export function ChatTutor() {
  const [turns, setTurns] = useState<Turn[]>([]);
  const [input, setInput] = useState("");
  const [sending, setSending] = useState(false);
  const [error, setError] = useState(false);
  const endRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    endRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [turns, sending]);

  async function send(text: string) {
    const message = text.trim();
    if (!message || sending) return;
    setError(false);
    setInput("");

    const history: Turn[] = [...turns, { role: "user", content: message }];
    setTurns(history);
    setSending(true);
    try {
      const res = await postChat(history.map((t) => ({ role: t.role, content: t.content })));
      setTurns([...history, { role: "assistant", content: res.reply, actions: res.actions }]);
    } catch {
      setError(true);
      setTurns(history); // keep the user's message so they can retry
    } finally {
      setSending(false);
    }
  }

  return (
    <div class="mx-auto flex h-screen max-w-md flex-col px-5 pb-20 pt-6">
      <header class="text-center">
        <h1 class="text-base font-semibold tracking-tight text-slate-900">Tutor</h1>
      </header>

      <main class="mt-4 flex-1 space-y-4 overflow-y-auto">
        {turns.length === 0 && (
          <div class="rounded-2xl bg-slate-50 p-5">
            <p class="text-slate-600">
              Chat about German and build decks to drill. Try:
            </p>
            <div class="mt-3 space-y-2">
              {EXAMPLES.map((ex) => (
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

        {turns.map((t, i) => (
          <div key={i} class={t.role === "user" ? "flex justify-end" : "flex justify-start"}>
            <div class="max-w-[85%]">
              {t.role === "user" ? (
                <div class="whitespace-pre-wrap rounded-2xl rounded-br-sm bg-slate-900 px-4 py-2.5 text-white">
                  {t.content}
                </div>
              ) : (
                <div
                  class="chat-md rounded-2xl rounded-bl-sm bg-slate-100 px-4 py-2.5 text-slate-900"
                  dangerouslySetInnerHTML={{ __html: renderMarkdown(t.content) }}
                />
              )}
              {t.actions && t.actions.length > 0 && (
                <div class="mt-1.5 flex flex-wrap gap-1.5">
                  {t.actions.map((a, j) => (
                    <span
                      key={j}
                      class="rounded-full bg-green-100 px-2 py-0.5 text-xs font-medium text-green-800"
                    >
                      ✓ {a.summary}
                    </span>
                  ))}
                </div>
              )}
            </div>
          </div>
        ))}

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
          placeholder="Ask, or describe a deck to build…"
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
