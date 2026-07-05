import "dotenv/config";

function required(name: string): string {
  const value = process.env[name];
  if (!value) throw new Error(`Missing required env var: ${name}`);
  return value;
}

function optional(name: string): string | undefined {
  return process.env[name] || undefined;
}

export const env = {
  isProd: process.env.NODE_ENV === "production",
  // Cloud Run injects PORT (8080). Dev server uses 8787 (Vite proxies /api here).
  port: Number(process.env.PORT) || 8787,
  databaseUrl: required("DATABASE_URL"),
  googleClientId: required("GOOGLE_CLIENT_ID"),
  googleClientSecret: required("GOOGLE_CLIENT_SECRET"),
  sessionSecret: required("SESSION_SECRET"),
  anthropicApiKey: required("ANTHROPIC_API_KEY"),
  baseUrl: process.env.BASE_URL || "http://localhost:5173",
  allowedEmails: required("ALLOWED_EMAILS")
    .split(",")
    .map((e) => e.trim().toLowerCase())
    .filter(Boolean),
  // Web Push (daily training reminder). All optional so local dev / CI run without
  // them — the feature simply reports itself disabled when the VAPID pair is absent
  // (see push-routes.ts / push/send.ts). Generate a pair with:
  //   npx web-push generate-vapid-keys
  vapidPublicKey: optional("VAPID_PUBLIC_KEY"),
  vapidPrivateKey: optional("VAPID_PRIVATE_KEY"),
  // Contact URI web-push embeds in the VAPID JWT (spec wants a mailto:/https:).
  vapidSubject: optional("VAPID_SUBJECT") || "mailto:philip.claesson@sanalabs.com",
  // Shared secret the reminders cron (GitHub Actions) presents to POST
  // /api/push/send-reminders. Unset → that endpoint is disabled (503).
  cronSecret: optional("CRON_SECRET"),
};
