// Wrapper for `npm run db:migrate`. Normally just execs `drizzle-kit migrate`
// (the path CI uses against prod). With DATABASE_WEBSOCKET=1 (local dev behind
// a VPN that blocks TCP 5432 — see .env.example) it applies the same
// ./drizzle migrations programmatically over Neon's WebSocket proxy instead;
// drizzle-kit and drizzle-orm's migrate() share journal + bookkeeping table,
// so the two paths are interchangeable.
import "dotenv/config";

if (process.env.DATABASE_WEBSOCKET === "1") {
  const { Pool } = await import("@neondatabase/serverless");
  const { drizzle } = await import("drizzle-orm/neon-serverless");
  const { migrate } = await import("drizzle-orm/neon-serverless/migrator");
  const pool = new Pool({ connectionString: process.env.DATABASE_URL });
  await migrate(drizzle(pool), { migrationsFolder: "./drizzle" });
  await pool.end();
  console.log("migrations applied (over websocket)");
} else {
  const { execSync } = await import("node:child_process");
  execSync("drizzle-kit migrate", { stdio: "inherit" });
}
