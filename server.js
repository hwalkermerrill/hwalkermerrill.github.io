// Imports (Core-Middleware-Routes-Models-Utils)
import express from "express";
import session from "express-session";
import connectPgSimple from "connect-pg-simple";
// import MongoStore from "connect-mongo"; // Mongodb
import path from "path";
import { fileURLToPath } from "url";
import { addLocalVariables, devLogs, campaignMiddleware } from "./src/middleware/global.js";
import { error404Router, globalErrorHandler } from "./src/middleware/errorHandler.js";
import flash from "./src/middleware/flash.js";
import routes from "./src/controllers/routes.js";
import { testConnection } from "./src/models/setupPostgres.js"; //setupDatabase no longer needed, so now this just runs the testConnection
// import { connectMongo, testConnection } from "./src/models/setupMongo.js"; // MongoDB connection
// import { caCert } from "./src/models/db.js"; //Cert only used with byui db
// import { startSessionCleanup } from "./src/utils/session-cleanup.js"; //Session cleanup now automatic

// Constants
const app = express();
const PgSession = connectPgSimple(session);
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV?.toLowerCase() || "production";

// Test Session Connection
console.log("DB_URL at runtime:", process.env.DB_URL); // Postgres connection test
// console.log("MONGO_URI at runtime:", process.env.MONGO_URI); // MongoDB connection test

// App Configuration
app.use(express.static(path.join(__dirname, "public")));
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "src/views"));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Session Configuration
app.use(session({
	name: "merrill.sid", // rename cookies to avoid auto drop by browsers and to avoid conflicts
	store: new PgSession({
		conString: process.env.DB_URL,
		// ssl: { //For BYUICSE
		// 	ca: caCert,
		// 	rejectUnauthorized: true,
		// 	checkServerIdentity: () => { return undefined; }
		// }
		tableName: "session",
		createTableIfMissing: true
	}),
	// store: MongoStore.create({
	// 	mongoUrl: process.env.MONGO_URI,
	// 	dbName: "merrill-ttrpg",
	// 	collectionName: "sessions",
	// 	ttl: 24 * 60 * 60, // 1 day in seconds
	// 	autoRemove: "native", // Use native MongoDB TTL index for automatic removal
	// }),
	secret: process.env.SESSION_SECRET,
	resave: false,
	saveUninitialized: false,
	cookie: {
		secure: process.env.RENDER === "true",
		httpOnly: true,
		sameSite: "lax",
		maxAge: 24 * 60 * 60 * 1000 // 1 day in milliseconds
	}
}));
// startSessionCleanup();

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

// Test Logging
console.log("RENDER =", process.env.RENDER);
console.log("NODE_ENV =", process.env.NODE_ENV);

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
	// await setupDatabase(); no longer runs every time, only when needed.
	// await connectMongo();
	await testConnection();
	console.log(`Server is running on http://127.0.0.1:${PORT}`);
});