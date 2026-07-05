import { useEffect, useState } from "preact/hooks";
import type { ExtraType, ProgressResponse, SessionUser, TodayResponse } from "../../shared/types";
import { getMe, getToday, getProgress, getPushConfig, logout } from "./api";
import { currentPushState, disablePush, enablePush, needsInstall } from "./push";
import { ExtraButtons, Review, type ReviewMode } from "./review";
import { DeckDetailView, DeckList } from "./decks";
import { ChatTutor } from "./chat";
import { Freund } from "./freund";
import { VerbsHome, VerbReview, VerbAllView } from "./verbs";
import { Stats } from "./stats";
import { TabBar } from "./footer";
import { navigate, usePath } from "./router";
import { TIERS } from "./tiers";

// Map an extra-work route suffix (/review/learn, /review/practice, /review/misses)
// to a review mode; bare /review is the required daily set.
function modeFromSuffix(suffix: string | undefined): ReviewMode {
  return suffix === "learn"
    ? "learn"
    : suffix === "practice"
      ? "practice"
      : suffix === "misses"
        ? "misses"
        : "daily";
}
const extraPath = (base: string, type: ExtraType) =>
  `${base}/${type === "new" ? "learn" : type}`;

// Time-of-day German greeting for the home header (☀️ by day, 🌛 at night).
function greeting(): { text: string; emoji: string } {
  const h = new Date().getHours();
  if (h < 5) return { text: "Gute Nacht", emoji: "🌛" };
  if (h < 11) return { text: "Guten Morgen", emoji: "☀️" };
  if (h < 13) return { text: "Guten Tag", emoji: "☀️" };
  if (h < 18) return { text: "Guten Nachmittag", emoji: "☀️" };
  if (h < 22) return { text: "Guten Abend", emoji: "🌛" };
  return { text: "Gute Nacht", emoji: "🌛" };
}

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
  // /review, /review/learn, /review/practice, /review/misses (and /verbs/review too).
  const reviewMatch = path.match(/^\/review(?:\/(learn|practice|misses))?$/);
  if (reviewMatch)
    return (
      <Review
        mode={modeFromSuffix(reviewMatch[1])}
        onDone={() => navigate("/")}
        onStartExtra={(type) => navigate(extraPath("/review", type))}
      />
    );
  const verbReviewMatch = path.match(/^\/verbs\/review(?:\/(learn|practice|misses))?$/);
  if (verbReviewMatch)
    return (
      <VerbReview
        mode={modeFromSuffix(verbReviewMatch[1])}
        onDone={() => navigate("/verbs")}
        onStartExtra={(type) => navigate(extraPath("/verbs/review", type))}
      />
    );

  // Drill-downs (a deck detail, the browse-all verbs list): own back button, no tab bar.
  if (deckMatch) return <DeckDetailView deckId={deckMatch[1]} onBack={() => navigate("/")} />;
  if (path === "/verbs/list") return <VerbAllView onBack={() => navigate("/verbs")} />;

  // Tab-root screens carry the bottom tab bar (Tutor · Words · Verbs).
  const content =
    path === "/chat" ? (
      <ChatTutor />
    ) : path === "/freund" ? (
      <Freund />
    ) : path === "/stats" ? (
      <Stats />
    ) : path === "/verbs" ? (
      <VerbsHome
        onStart={() => navigate("/verbs/review")}
        onOpenList={() => navigate("/verbs/list")}
        onStartExtra={(type) => navigate(extraPath("/verbs/review", type))}
      />
    ) : (
      <Dashboard
        user={user}
        onStart={() => navigate("/review")}
        onOpenDeck={(id) => navigate(`/decks/${id}`)}
        onStartExtra={(type) => navigate(extraPath("/review", type))}
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
  onStartExtra,
}: {
  user: SessionUser;
  onStart: () => void;
  onOpenDeck: (id: string) => void;
  onStartExtra: (type: ExtraType) => void;
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
  // No required work left to do (finished today, or nothing was due) → offer the
  // extra-work on-ramps instead of a dead "Start" button.
  const canReview = pending > 0;

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
          {greeting().text},{" "}
          <span class="font-medium text-slate-900">
            {user.name?.split(" ")[0] || user.email}
          </span>{" "}
          {greeting().emoji}
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
          {today && today.bonusToday > 0 && (
            <p class="mt-2 text-sm text-slate-400">
              +{today.bonusToday} extra {today.bonusToday === 1 ? "card" : "cards"} today ✨
            </p>
          )}
          {canReview && (
            <button
              onClick={onStart}
              class="mt-4 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700"
            >
              {started ? "Continue" : "Start review"}
            </button>
          )}
          {!canReview && today && (
            <div class="mt-4">
              <ExtraButtons
                noun="cards"
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

        <ReminderToggle />

        <MasteryCard progress={progress} />

        <h2 class="mt-10 mb-3 text-sm font-medium uppercase tracking-wide text-slate-400">
          Your decks
        </h2>
        <DeckList onOpen={onOpenDeck} />
      </main>
    </div>
  );
}

// Daily-reminder switch. Hidden entirely unless the server has push configured
// (VAPID keys present). On iPhone it shows install guidance instead of a dead
// switch, since Web Push there needs the home-screen PWA. See web/src/push.ts.
type ToggleState = "loading" | "hidden" | "install" | "denied" | "off" | "on";

function ReminderToggle() {
  const [state, setState] = useState<ToggleState>("loading");
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      try {
        const config = await getPushConfig();
        if (cancelled) return;
        if (!config.enabled) return setState("hidden");
        if (needsInstall()) return setState("install");
        const s = await currentPushState();
        if (cancelled) return;
        setState(s === "unsupported" ? "hidden" : s);
      } catch {
        if (!cancelled) setState("hidden");
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  if (state === "loading" || state === "hidden") return null;

  async function toggle() {
    setBusy(true);
    try {
      const next = state === "on" ? await disablePush() : await enablePush();
      setState(next === "unsupported" ? "install" : next);
    } finally {
      setBusy(false);
    }
  }

  const subtitle =
    state === "on"
      ? "On — a nudge each morning when cards are due."
      : state === "off"
        ? "Get a morning nudge when cards are due."
        : state === "denied"
          ? "Blocked. Enable notifications for this site in your browser settings."
          : "On iPhone: tap Share → Add to Home Screen, then open the app here to enable.";

  return (
    <div class="mt-4 flex items-center justify-between gap-4 rounded-2xl border border-slate-200 px-5 py-4">
      <div>
        <p class="font-medium text-slate-900">Daily reminder</p>
        <p class="mt-0.5 text-sm text-slate-500">{subtitle}</p>
      </div>
      {(state === "on" || state === "off") && (
        <button
          onClick={toggle}
          disabled={busy}
          class={`shrink-0 rounded-xl px-4 py-2 text-sm font-medium transition disabled:opacity-50 ${
            state === "on"
              ? "border border-slate-300 text-slate-700 hover:bg-slate-50"
              : "bg-slate-900 text-white hover:bg-slate-700"
          }`}
        >
          {busy ? "…" : state === "on" ? "Turn off" : "Turn on"}
        </button>
      )}
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
