import dotenv from "dotenv";
import express, { Express, Request, Response } from "express";
import authRoutes from "./routes/auth";

// Load environment variables
dotenv.config();

const app: Express = express();
const PORT = parseInt(process.env.PORT ?? "3000", 10);

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check route
app.get("/", (req: Request, res: Response) => {
    res.json({ status: "ok", message: "Auth server is running!" });
});

// 🔐 Auth routes (mounted at /api/auth)
app.use("/api/auth", authRoutes);

const batteryLogs: any[] = [];

app.post("/api/battery", (req: Request, res: Response) => {
    const payload = req.body;
    console.log("🔋 Battery payload received:", JSON.stringify(payload, null, 2));
    batteryLogs.push({
        ...payload,
        receivedAt: new Date().toISOString(),
    });
    console.log(`📦 Total battery logs in memory: ${batteryLogs.length}`);

    res.json({
        success: true,
        message: "Battery data received",
        count: batteryLogs.length,
    });
});

// Start server
app.listen(PORT, "0.0.0.0", () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});

// Export for testing purposes
export default app;
