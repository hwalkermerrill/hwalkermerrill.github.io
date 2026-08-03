// Imports
import mongoose from "mongoose";
import fs from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";

// Constants
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// MongoDB Connection Setup
const connectMongo = async () => {
	// Test Connection (Initial Connect)
	try {
		// Connect to MongoDB using MONGO_URI and a fixed dbName
		await mongoose.connect(process.env.MONGO_URI, {
			dbName: "merrill-ttrpg"
		});

		console.log("MongoDB connection OK");
	} catch (err) {
		console.error("MongoDB connection failed:", err);
		throw err;
	}

	// NOTE: The following structure/seed logic is currently based on SQL files.
	// For MongoDB, these will need to be replaced with JS/JSON-based seed scripts
	// using Mongoose models. We keep the organization and comments here so we
	// don't forget to revisit each part during the migration.

	// NOTE: Everything below this point is legacy SQL-based seeding logic.
	// We keep the structure and comments so we do not forget to convert each part.

	// Constant Paths (Legacy SQL)
	const sqlDir = join(__dirname, "sql");
	const structurePath = join(sqlDir, "structure.sql");
	const seedCorePath = join(sqlDir, "seed_core.sql");

	// If the sql directory does not exist, we skip legacy seed logic.
	if (!fs.existsSync(sqlDir)) {
		console.log("Legacy SQL directory not found. Skipping SQL-based structure/seed steps.");
		return true;
	}

	const files = fs.readdirSync(sqlDir);

	// Legacy: Run structure.sql (idempotent)
	// TODO: Convert structure.sql → Mongoose schema definitions + indexes.
	console.log("Initializing database structure (legacy SQL placeholder)...");
	if (fs.existsSync(structurePath)) {
		console.log("structure.sql detected. No MongoDB action performed.");
		console.log("TODO: Translate structure.sql into Mongoose schemas.");
	}

	// Legacy: Run seed_core.sql (idempotent)
	// TODO: Convert seed_core.sql → JS/JSON seed scripts using Mongoose models.
	console.log("Seeding database core (legacy SQL placeholder)...");
	if (fs.existsSync(seedCorePath)) {
		console.log("seed_core.sql detected. No MongoDB action performed.");
		console.log("TODO: Translate seed_core.sql into Mongoose seed scripts.");
	}

	// Legacy: Process campaign seed files
	// TODO: Convert seed_campaign_* → Mongoose-based campaign seed scripts.
	console.log("Processing campaign seeds (legacy SQL placeholder)...");
	const campaignSeeds = files
		.filter((f) => f.startsWith("seed_campaign_") && f.endsWith(".sql"))
		.sort();

	let appliedCount = 0;
	let skippedCount = 0;

	for (const file of campaignSeeds) {
		const filePath = join(sqlDir, file);
		const sql = fs.readFileSync(filePath, "utf8");

		// Skip empty files
		if (!sql.trim()) {
			console.log(`Skipping ${file}: file is empty (legacy SQL seed)`);
			skippedCount++;
			continue;
		}

		// Extract campaign name from SQL (legacy logic preserved)
		const match = sql.match(
			/INSERT\s+INTO\s+campaigns\s*\([^)]*campaign_name[^)]*\)\s*VALUES\s*\(\s*'([^']+)'/i
		);
		const campaignName = match ? match[1] : null;

		if (!campaignName) {
			console.log(`Skipping ${file}: could not detect campaign name (legacy SQL seed)`);
			skippedCount++;
			continue;
		}

		console.log(
			`Detected legacy campaign seed for "${campaignName}". No MongoDB insert performed yet.`
		);

		skippedCount++;
	}

	console.log(
		`Legacy campaign seeds processed (MongoDB placeholder): ${appliedCount} applied, ${skippedCount} skipped`
	);

	return true;
};

// Development Tests (MongoDB)
const testConnection = async () => {
	try {
		if (mongoose.connection.readyState === 1) {
			console.log("MongoDB connection successful (readyState 1)");
			return true;
		}

		await mongoose.connect(process.env.MONGO_URI, {
			dbName: "merrill-ttrpg"
		});

		console.log("MongoDB connection successful via testConnection()");
		return true;
	} catch (err) {
		console.error("MongoDB testConnection failed:", err);
		throw err;
	}
};

export { connectMongo, testConnection };