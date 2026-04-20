import dotenv from "dotenv";
import express, { Express, Request, Response } from "express";
import authRoutes from "./routes/auth";

// Load environment variables
dotenv.config();

const app: Express = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check route
app.get("/", (req: Request, res: Response) => {
    res.json({ status: "ok", message: "Auth server is running!" });
});

// 🔐 Auth routes (mounted at /api/auth)
app.use("/api/auth", authRoutes);

// Start server
app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});

// Export for testing purposes
export default app;
