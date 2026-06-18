import { useEffect, useState } from "preact/hooks";

// Minimal History-API router — no dependency. The server serves index.html for
// any non-API path, so deep links and refreshes resolve to the SPA.

export function usePath(): string {
  const [path, setPath] = useState(window.location.pathname);
  useEffect(() => {
    const onPop = () => setPath(window.location.pathname);
    window.addEventListener("popstate", onPop);
    return () => window.removeEventListener("popstate", onPop);
  }, []);
  return path;
}

export function navigate(to: string): void {
  if (to === window.location.pathname) return;
  window.history.pushState(null, "", to);
  // pushState doesn't emit popstate; nudge our listeners so the UI updates.
  window.dispatchEvent(new PopStateEvent("popstate"));
}
