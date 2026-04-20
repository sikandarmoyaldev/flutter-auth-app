import { eq } from "drizzle-orm";

import { db } from "../lib/db";
import { NewUser, User, users } from "../schema/user";
import { hashPassword, verifyPassword } from "../utils/password";

export class AuthService {
    static async createUser(data: Omit<NewUser, "id" | "createdAt" | "updatedAt">): Promise<User> {
        // Hash password BEFORE inserting
        const hashedPassword = await hashPassword(data.password);

        const [newUser] = await db
            .insert(users)
            .values({ ...data, password: hashedPassword })
            .returning();

        return newUser;
    }

    static async updateUserPassword(userId: string, plainPassword: string): Promise<User> {
        const hashedPassword = await hashPassword(plainPassword);

        const [updatedUser] = await db
            .update(users)
            .set({ password: hashedPassword, updatedAt: new Date() })
            .where(eq(users.id, userId))
            .returning();

        return updatedUser;
    }

    static async findUserByEmail(email: string): Promise<User | undefined> {
        const [user] = await db.select().from(users).where(eq(users.email, email)).limit(1);

        return user;
    }

    static async verifyUserPassword(user: User, plainPassword: string): Promise<boolean> {
        return verifyPassword(plainPassword, user.password);
    }
}
