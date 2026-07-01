import { useEffect, useState } from "preact/hooks";
import type { ProgressResponse, SessionUser, TodayResponse } from "../../shared/types";
import { getMe, getToday, getProgress, logout } from "./api";
import { Review } from "./review";
import { DeckDetailView, DeckList } from "./decks";
import { ChatTutor } from "./chat";
import { VerbsHome, VerbReview, VerbAllView } from "./verbs";
import { TabBar } from "./footer";
import { navigate, usePath } from "./router";
import { TIERS } from "./tiers";

type AuthState =
  | { status: "loading" }
  | { status: "anon" }
  | { status: "authed"; user: SessionUser };

export function App() {
  const [auth, setAuth] = useState<AuthState>({ status: "loading" });

  useEffect(() => {
    getMe()
      .then((res) => setAuth({ status: "authed", user: res.user }))
      .catch(() => setAuth({ status: "anon" }));
  }, []);

  if (auth.status === "loading") return <Centered>…</Centered>;
  if (auth.status === "anon") return <Login />;
  return <Home user={auth.user} />;
}

function Login() {
  return (
    <Centered>
      <div class="w-full max-w-sm text-center">
        <h1 class="text-3xl font-semibold tracking-tight text-slate-900">Sprachen</h1>
        <p class="mt-2 text-slate-500">Your German vocabulary trainer.</p>
        <a
          href="/api/auth/login"
          class="mt-8 inline-flex w-full items-center justify-center gap-2 rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700"
        >
          Sign in with Google
        </a>
      </div>
    </Centered>
  );
}

function Home({ user }: { user: SessionUser }) {
  const path = usePath();
  const deckMatch = path.match(/^\/decks\/(.+)$/);

  // Full-screen review loops render without the tab bar — their single persistent
  // input keeps the mobile keyboard open, and a nav bar there is a focus hazard.
  if (path === "/review") return <Review onDone={() => navigate("/")} />;
  if (path === "/verbs/review") return <VerbReview onDone={() => navigate("/verbs")} />;

  // Drill-downs (a deck detail, the browse-all verbs list): own back button, no tab bar.
  if (deckMatch) return <DeckDetailView deckId={deckMatch[1]} onBack={() => navigate("/")} />;
  if (path === "/verbs/list") return <VerbAllView onBack={() => navigate("/verbs")} />;

  // Tab-root screens carry the bottom tab bar (Tutor · Words · Verbs).
  const content =
    path === "/chat" ? (
      <ChatTutor />
    ) : path === "/verbs" ? (
      <VerbsHome
        onStart={() => navigate("/verbs/review")}
        onOpenList={() => navigate("/verbs/list")}
      />
    ) : (
      <Dashboard
        user={user}
        onStart={() => navigate("/review")}
        onOpenDeck={(id) => navigate(`/decks/${id}`)}
        onOpenChat={() => navigate("/chat")}
      />
    );

  return (
    <>
      {content}
      <TabBar />
    </>
  );
}

function Dashboard({
  user,
  onStart,
  onOpenDeck,
  onOpenChat,
}: {
  user: SessionUser;
  onStart: () => void;
  onOpenDeck: (id: string) => void;
  onOpenChat: () => void;
}) {
  const [today, setToday] = useState<TodayResponse | null>(null);
  const [progress, setProgress] = useState<ProgressResponse | null>(null);

  useEffect(() => {
    getToday().then(setToday).catch(() => setToday(null));
    getProgress().then(setProgress).catch(() => setProgress(null));
  }, []);

  const requiredTotal = today ? today.dueTotal + today.newTotal : 0;
  const pending = today?.pending ?? 0;
  const started = (today?.done ?? 0) > 0;

  async function onLogout() {
    await logout();
    window.location.reload();
  }

  return (
    <div class="mx-auto flex min-h-screen max-w-md flex-col px-5 pb-24 pt-10">
      <header class="flex items-center justify-between">
        <h1 class="text-2xl font-semibold tracking-tight text-slate-900">Sprachen</h1>
        <button
          onClick={onLogout}
          class="text-sm text-slate-500 underline-offset-2 hover:text-slate-900 hover:underline"
        >
          Sign out
        </button>
      </header>

      <main class="mt-10">
        <p class="text-slate-500">
          Hallo, <span class="font-medium text-slate-900">{user.name || user.email}</span>
        </p>

        <div class="mt-6 rounded-2xl bg-slate-50 p-5 text-center">
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
                <span class="font-semibold">{pending}</span> to review today
                <span class="block text-sm text-slate-400">
                  {today.done} / {requiredTotal} done
                </span>
              </p>
            )}
          </div>
          <button
            onClick={onStart}
            disabled={pending === 0}
            class="mt-4 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700 disabled:opacity-40"
          >
            {started && pending > 0 ? "Continue" : "Start review"}
          </button>
        </div>

        <MasteryCard progress={progress} />

        <button
          onClick={onOpenChat}
          class="mt-4 flex w-full items-center gap-3 rounded-2xl border border-slate-200 px-5 py-4 text-left transition-colors hover:border-slate-300 hover:bg-slate-50"
        >
          <span class="text-xl">💬</span>
          <span>
            <span class="block font-medium text-slate-900">Build with the tutor</span>
            <span class="block text-sm text-slate-500">Chat about German and create decks to drill.</span>
          </span>
        </button>

        <h2 class="mt-10 mb-3 text-sm font-medium uppercase tracking-wide text-slate-400">
          Your decks
        </h2>
        <DeckList onOpen={onOpenDeck} />
      </main>
    </div>
  );
}

function MasteryCard({ progress }: { progress: ProgressResponse | null }) {
  if (!progress) return null;
  const { tiers, mastered, total } = progress;

  return (
    <div class="mt-4 rounded-2xl border border-slate-200 p-5">
      <div class="flex items-baseline justify-between">
        <div>
          <span class="text-3xl font-semibold tracking-tight text-slate-900">{mastered}</span>
          <span class="ml-2 text-slate-500">words mastered</span>
        </div>
        <span class="text-sm text-slate-400">{total} total</span>
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
    </div>
  );
}

function Centered({ children }: { children: preact.ComponentChildren }) {
  return (
    <div class="flex min-h-screen items-center justify-center bg-white px-5 text-slate-900">
      {children}
    </div>
  );
}
