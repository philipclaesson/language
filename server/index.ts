import { serve } from "@hono/node-server";
import { serveStatic } from "@hono/node-server/serve-static";
import { Hono } from "hono";
import { existsSync } from "node:fs";
import { env } from "./env";
import { authRoutes, requireAuth, type AppEnv } from "./auth";
import { reviewRoutes } from "./review-routes";
import { deckRoutes } from "./deck-routes";
import { chatRoutes } from "./chat-routes";

const app = new Hono<AppEnv>();

// ---- API ----
const api = new Hono<AppEnv>();
api.route("/auth", authRoutes);
api.get("/me", requireAuth, (c) => c.json({ user: c.get("user") }));
api.route("/", reviewRoutes); // /session/next, /reviews
api.route("/", deckRoutes); // /decks, /decks/:id
api.route("/", chatRoutes); // /chat

app.route("/api", api);

// ---- Static SPA (production only; in dev Vite serves the frontend) ----
const webDist = "./web/dist";
if (existsSync(webDist)) {
  app.use("/*", serveStatic({ root: webDist }));
  // SPA fallback: any non-API, non-file route returns index.html.
  app.get("*", serveStatic({ path: `${webDist}/index.html` }));
} else {
  app.get("/", (c) =>
    c.text("Frontend not built. Run `npm run dev` (Vite on :5173) or `npm run build`."),
  );
}

serve({ fetch: app.fetch, port: env.port }, (info) => {
  console.log(`server listening on http://localhost:${info.port}`);
});
