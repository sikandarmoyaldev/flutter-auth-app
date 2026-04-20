import jwt from "jsonwebtoken";
import { User } from "../schema/user";

const JWT_SECRET = process.env.JWT_SECRET!;
const JWT_EXPIRES_IN = "7d";
const REFRESH_TOKEN_EXPIRES_IN = "30d";

if (!JWT_SECRET) {
    throw new Error("❌ JWT_SECRET is missing in .env");
}

export type TokenPayload = {
    userId: string;
    email: string;
};

export function generateAccessToken(user: Pick<User, "id" | "email">): string {
    return jwt.sign({ userId: user.id, email: user.email } as TokenPayload, JWT_SECRET, {
        expiresIn: JWT_EXPIRES_IN,
    });
}

export function generateRefreshToken(user: Pick<User, "id" | "email">): string {
    return jwt.sign({ userId: user.id, email: user.email } as TokenPayload, JWT_SECRET, {
        expiresIn: REFRESH_TOKEN_EXPIRES_IN,
    });
}

export function verifyToken(token: string): TokenPayload | null {
    try {
        return jwt.verify(token, JWT_SECRET) as TokenPayload;
    } catch {
        return null;
    }
}
