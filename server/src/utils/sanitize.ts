import { User as DbUser } from "../schema/user";

// 🔐 Type for public API responses (excludes sensitive fields)
export type PublicUser = Omit<DbUser, "password">;

/**
 * Remove sensitive fields from a single user object
 * @param user - Database user object with password
 * @returns Safe user object for JSON responses
 */
export function sanitizeUser(user: DbUser): PublicUser {
    const { password, ...safe } = user;
    return safe;
}

/**
 * Remove sensitive fields from multiple user objects
 * @param users - Array of database user objects
 * @returns Array of safe user objects for JSON responses
 */
export function sanitizeUsers(users: DbUser[]): PublicUser[] {
    return users.map(sanitizeUser);
}
