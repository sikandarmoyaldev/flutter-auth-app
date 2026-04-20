import { drizzle, type PostgresJsDatabase } from "drizzle-orm/postgres-js";
import postgres from "postgres";

import * as schema from "../schema/index";

if (!process.env.DATABASE_URL) {
    throw new Error("❌ DATABASE_URL is missing in .env");
}

// postgres.js is Drizzle's recommended driver for Supabase
const client = postgres(process.env.DATABASE_URL, {
    max: 10, // Max connections in pool
    idle_timeout: 20, // Close idle connections after 20s
    connect_timeout: 10, // Fail fast if DB is unreachable
});

// Export typed Drizzle instance with your schema
export const db: PostgresJsDatabase = drizzle(client, { schema });
