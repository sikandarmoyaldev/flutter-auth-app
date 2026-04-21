import { Request, Response, Router } from "express";
import { z } from "zod";
import { AuthService } from "../services/auth.service";
import { generateAccessToken, generateRefreshToken } from "../utils/jwt";
import { sanitizeUser } from "../utils/sanitize";

const router = Router();

// Validation schemas
const registerSchema = z.object({
    name: z
        .string({ error: "Name is required" })
        .min(2, "Name must be at least 2 characters")
        .max(50, "Name must be less than 50 characters"),

    email: z
        .string({ error: "Email is required." })
        .email("Please enter a valid email address")
        .toLowerCase()
        .trim(),

    password: z
        .string({ error: "Password is required" })
        .min(8, "Password must be at least 8 characters"),
});

const loginSchema = z.object({
    email: z
        .string({ error: "Email is required." })
        .email("Please enter a valid email address")
        .toLowerCase()
        .trim(),
    password: z.string({ error: "Password is required" }).min(1, "Password is required"),
});
// POST /api/auth/register
router.post("/register", async (req: Request, res: Response) => {
    try {
        // 1. Validate input
        const parsed = registerSchema.safeParse(req.body);
        if (!parsed.success) {
            return res
                .status(400)
                .json({ error: "Validation failed", details: parsed.error.flatten() });
        }

        const { name, email, password } = parsed.data;

        // 2. Check if user already exists
        const existing = await AuthService.findUserByEmail(email);
        if (existing) {
            return res.status(409).json({ error: "Email already registered" });
        }

        // 3. Create user (password auto-hashed in service)
        const newUser = await AuthService.createUser({ name, email, password });

        // 4. Generate tokens
        const accessToken = generateAccessToken(newUser);
        const refreshToken = generateRefreshToken(newUser);

        // 5. Return safe response (no password)
        res.status(201).json({
            message: "User registered successfully",
            user: sanitizeUser(newUser),
            tokens: { accessToken, refreshToken },
        });
    } catch (error) {
        console.error("Registration error:", error);
        res.status(500).json({ error: "Registration failed" });
    }
});

// POST /api/auth/login
router.post("/login", async (req: Request, res: Response) => {
    try {
        // 1. Validate input
        const parsed = loginSchema.safeParse(req.body);
        if (!parsed.success) {
            return res
                .status(400)
                .json({ error: "Validation failed", details: parsed.error.flatten() });
        }

        const { email, password } = parsed.data;

        // 2. Find user
        const user = await AuthService.findUserByEmail(email);
        if (!user) {
            return res.status(401).json({ error: "Invalid credentials" });
        }

        // 3. Verify password
        const isValid = await AuthService.verifyUserPassword(user, password);
        if (!isValid) {
            return res.status(401).json({ error: "Invalid credentials" });
        }

        // 4. Generate tokens
        const accessToken = generateAccessToken(user);
        const refreshToken = generateRefreshToken(user);

        // 5. Return safe response
        res.json({
            message: "Login successful",
            user: sanitizeUser(user),
            tokens: { accessToken, refreshToken },
        });
    } catch (error) {
        console.error("Login error:", error);
        res.status(500).json({ error: "Login failed" });
    }
});

// GET /api/auth/me (protected route placeholder)
router.get("/me", async (req: Request, res: Response) => {
    // TODO: Add auth middleware to verify JWT and attach user to req
    res.json({ message: "Protected route - implement auth middleware next" });
});

export default router;
