import { Pool as NeonPool } from "@neondatabase/serverless";
import { drizzle as drizzleNeonWs } from "drizzle-orm/neon-serverless";
import { drizzle, type NodePgDatabase } from "drizzle-orm/node-postgres";
import pg from "pg";
import { env } from "../env";
import * as schema from "./schema";

const isLocal =
  env.databaseUrl.includes("localhost") || env.databaseUrl.includes("127.0.0.1");

function makeDb(): NodePgDatabase<typeof schema> {
  if (env.databaseWebsocket) {
    // Reach Neon via its WebSocket proxy (port 443) instead of TCP 5432 —
    // for local dev behind corporate VPNs (Zscaler) that blackhole 5432.
    // Same query API as node-postgres, so the cast is safe.
    const pool = new NeonPool({ connectionString: env.databaseUrl });
    return drizzleNeonWs(pool, { schema }) as unknown as NodePgDatabase<
      typeof schema
    >;
  }
  const pool = new pg.Pool({
    connectionString: env.databaseUrl,
    // Neon (and most hosted Postgres) require TLS; local Postgres usually doesn't.
    ssl: isLocal ? false : { rejectUnauthorized: false },
  });
  return drizzle(pool, { schema });
}

export const db = makeDb();
