import { navigate, usePath } from "./router";

// Bottom tab bar (VERBS.md): Tutor · Words · Verbs. Mobile-first, fixed to the
// bottom. Shown on the tab-root screens only — the review loops render full-screen
// without it (the never-blurring input keeps the mobile keyboard open). Screens
// that show the footer add `pb-24` so content clears it.

type Tab = { label: string; icon: string; path: string; isActive: (p: string) => boolean };

const TABS: Tab[] = [
  { label: "Tutor", icon: "💬", path: "/chat", isActive: (p) => p === "/chat" },
  // Words owns the home dashboard, its review loop, and deck screens.
  {
    label: "Words",
    icon: "📖",
    path: "/",
    isActive: (p) => p === "/" || p === "/review" || p.startsWith("/decks/"),
  },
  { label: "Verbs", icon: "🔤", path: "/verbs", isActive: (p) => p.startsWith("/verbs") },
];

export function TabBar() {
  const path = usePath();
  return (
    <nav class="fixed inset-x-0 bottom-0 z-10 border-t border-slate-200 bg-white/90 backdrop-blur">
      <div class="mx-auto flex max-w-md">
        {TABS.map((t) => {
          const active = t.isActive(path);
          return (
            <button
              key={t.path}
              onClick={() => navigate(t.path)}
              class={`flex flex-1 flex-col items-center gap-0.5 py-2.5 text-xs transition-colors ${
                active ? "text-slate-900" : "text-slate-400 hover:text-slate-600"
              }`}
              aria-current={active ? "page" : undefined}
            >
              <span class="text-lg leading-none">{t.icon}</span>
              <span class={active ? "font-medium" : ""}>{t.label}</span>
            </button>
          );
        })}
      </div>
    </nav>
  );
}
