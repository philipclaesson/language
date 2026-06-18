import { defineConfig } from "vite";
import preact from "@preact/preset-vite";
import tailwindcss from "@tailwindcss/vite";

// SPA lives in /web; built output goes to /web/dist (served by the Hono server in prod).
export default defineConfig({
  root: "web",
  plugins: [preact(), tailwindcss()],
  build: {
    outDir: "dist",
    emptyOutDir: true,
  },
  server: {
    port: 5173,
    // In dev the SPA is served by Vite and proxies API calls to the Hono server.
    proxy: {
      "/api": "http://localhost:8787",
    },
  },
});
