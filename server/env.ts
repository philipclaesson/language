import "dotenv/config";

function required(name: string): string {
  const value = process.env[name];
  if (!value) throw new Error(`Missing required env var: ${name}`);
  return value;
}

export const env = {
  isProd: process.env.NODE_ENV === "production",
  // Cloud Run injects PORT (8080). Dev server uses 8787 (Vite proxies /api here).
  port: Number(process.env.PORT) || 8787,
  databaseUrl: required("DATABASE_URL"),
  googleClientId: required("GOOGLE_CLIENT_ID"),
  googleClientSecret: required("GOOGLE_CLIENT_SECRET"),
  sessionSecret: required("SESSION_SECRET"),
  baseUrl: process.env.BASE_URL || "http://localhost:5173",
  allowedEmails: required("ALLOWED_EMAILS")
    .split(",")
    .map((e) => e.trim().toLowerCase())
    .filter(Boolean),
};
