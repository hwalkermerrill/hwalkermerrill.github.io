// Imports (Core-Middleware-Routes-Models-Utils)
import express from "express";
import session from "express-session";
import connectPgSimple from "connect-pg-simple";
import path from "path";
import { fileURLToPath } from "url";
import { addLocalVariables, devLogs, campaignMiddleware } from "./src/middleware/global.js";
import { error404Router, globalErrorHandler } from "./src/middleware/errorHandler.js";
import flash from "./src/middleware/flash.js";
import routes from "./src/controllers/routes.js";
import { setupDatabase, testConnection } from "./src/models/setup.js";
import { caCert } from "./src/models/db.js";
import { startSessionCleanup } from "./src/utils/session-cleanup.js";

// Constants
const app = express();
const PgSession = connectPgSimple(session);
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV?.toLowerCase() || "production";

// App Configuration
app.use(express.static(path.join(__dirname, "public")));
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "src/views"));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Session Configuration
app.use(session({
  store: new PgSession({
    conObject: {
      connectionString: process.env.DB_URL,
      // Configure SSL for session store connection (required by BYU-I databases)
      ssl: {
        ca: caCert,
        rejectUnauthorized: true,
        checkServerIdentity: () => { return undefined; }
      }
    },
    tableName: "session",
    createTableIfMissing: true
  }),
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: NODE_ENV.includes("dev") !== true,
    httpOnly: true,
    maxAge: 24 * 60 * 60 * 1000
  }
}));
startSessionCleanup();

// Middleware (AKA Mise en Place)
app.use(addLocalVariables);
app.use(campaignMiddleware);
app.use(flash);

if (process.env.NODE_ENV === "development") {
  app.use(devLogs);
}

// Routes
app.use("/", routes);

// Error Handling
app.use(error404Router);
app.use(globalErrorHandler);

// When in development mode, start a WebSocket server for live reloading
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

// Start the server and listen on the specified port
app.listen(PORT, async () => {
  await setupDatabase();
  await testConnection();
  console.log(`Server is running on http://127.0.0.1:${PORT}`);
});