import { useEffect, useState } from "preact/hooks";
import type { SessionUser } from "../../shared/types";
import { getMe, getSession, logout } from "./api";
import { Review } from "./review";
import { DeckDetailView, DeckList } from "./decks";
import { navigate, usePath } from "./router";

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

  if (path === "/review") return <Review onDone={() => navigate("/")} />;
  if (deckMatch) return <DeckDetailView deckId={deckMatch[1]} onBack={() => navigate("/")} />;
  return (
    <Dashboard
      user={user}
      onStart={() => navigate("/review")}
      onOpenDeck={(id) => navigate(`/decks/${id}`)}
    />
  );
}

function Dashboard({
  user,
  onStart,
  onOpenDeck,
}: {
  user: SessionUser;
  onStart: () => void;
  onOpenDeck: (id: string) => void;
}) {
  const [counts, setCounts] = useState<{ due: number; new: number } | null>(null);

  useEffect(() => {
    getSession()
      .then((s) => setCounts({ due: s.dueCount, new: s.newCount }))
      .catch(() => setCounts({ due: 0, new: 0 }));
  }, []);

  const total = counts ? counts.due + counts.new : 0;

  async function onLogout() {
    await logout();
    window.location.reload();
  }

  return (
    <div class="mx-auto flex min-h-screen max-w-md flex-col px-5 py-10">
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
            {counts === null ? (
              <p class="text-slate-400">…</p>
            ) : total === 0 ? (
              <p class="text-slate-600">Nothing due right now. 🎉</p>
            ) : (
              <p class="text-lg">
                <span class="font-semibold">{counts.due}</span> due
                {counts.new > 0 && (
                  <>
                    {" · "}
                    <span class="font-semibold">{counts.new}</span> new
                  </>
                )}
              </p>
            )}
          </div>
          <button
            onClick={onStart}
            disabled={total === 0}
            class="mt-4 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700 disabled:opacity-40"
          >
            Start review
          </button>
        </div>

        <h2 class="mt-10 mb-3 text-sm font-medium uppercase tracking-wide text-slate-400">
          Your decks
        </h2>
        <DeckList onOpen={onOpenDeck} />
      </main>
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
