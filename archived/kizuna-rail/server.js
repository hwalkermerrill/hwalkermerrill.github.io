import express from "express";
import globalMiddleware from "./src/middleware/global.js";
import Path from "path";
import routes from "./src/controllers/router.js";
import pkg from "./package.json" with { type: "json" };
import { fileURLToPath } from "url";
import { initializeDatabase } from "./src/models/db-in-file.js";

/**
 * Declare Important Variables
 */
const __filename = fileURLToPath(import.meta.url);
const __dirname = Path.dirname(__filename);
const NODE_ENV = process.env.NODE_ENV?.toLowerCase() || "production";
const PORT = process.env.PORT || 3000;
const DATABASE_FILE = Path.join(__dirname, "src/models/db-in-file.json");

/**
 * Setup Express Server
 */
const app = express();

/**
 * Configure Express middleware
 */

// Setup file-based database
initializeDatabase(DATABASE_FILE);

// Add version info to res.locals for access in templates
app.use((req, res, next) => {
    res.locals.appVersion = pkg.version;
    next();
});

// Serve static files from the public directory
app.use(express.static(Path.join(__dirname, "public")));

// Set EJS as the templating engine
app.set("view engine", "ejs");

// Tell Express where to find your templates
app.set("views", Path.join(__dirname, "src/views"));

// Parse JSON and URL-encoded request bodies (for processing POST data)
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true, limit: "10mb" }));

/**
 * Global Middleware
 */

app.use(globalMiddleware);

/**
 * Routes
 */

app.use("/", routes);

/**
 * Error Handling
 */

// Catch-all route for 404 errors
app.use((req, res, next) => {
    const err = new Error("Page Not Found");
    err.status = 404;
    next(err);
});

// Global error handler
app.use((err, req, res, next) => { // eslint-disable-line no-unused-vars
    // Determine status and template
    const status = err.status || 500;
    const template = status === 404 ? "404" : "500";

    // Prepare data for the template
    const context = {
        title: status === 404 ? "Page Not Found" : "Server Error",
        error: err.message,
        stack: err.stack
    };

    // Render the appropriate error template
    res.status(status).render(`errors/${template}`, context);
});

/**
 * Start WebSocket Server in Development Mode; used for live reloading
 */
if (NODE_ENV.includes("dev")) {
    const ws = await import("ws");

    try {
        const wsPort = parseInt(PORT) + 1;
        const wsServer = new ws.WebSocketServer({ port: wsPort });

        wsServer.on("listening", () => {
            console.log(`WebSocket server is running on port ${wsPort}`);
        });

        wsServer.on("error", (error) => {
            console.error("WebSocket server error:", error);
        });
    } catch (error) {
        console.error("Failed to start WebSocket server:", error);
    }
}

/**
 * Start Server
 */
app.listen(PORT, async () => {
    console.log(`Server is running on http://127.0.0.1:${PORT}`);
});