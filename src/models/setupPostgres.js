// Imports
import db from "./db.js";
import fs from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";

// Constants
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const setupDatabase = async () => {
	// Constant Paths
	const structurePath = join(__dirname, "sql", "structure.sql");
	const seedCorePath = join(__dirname, "sql", "seed_core.sql");
	const sqlDir = join(__dirname, "sql");
	const files = fs.readdirSync(sqlDir);

	// Test Connection
	try {
		await db.query("SELECT 1");
		console.log("Database connection OK");
	} catch (err) {
		console.error("Database connection failed:", err);
		throw err;
	}

	// Run structure.sql (idempotent)
	console.log("Initializing database structure...");
	if (fs.existsSync(structurePath)) {
		const structureSQL = fs.readFileSync(structurePath, "utf8");
		await db.query(structureSQL);
		console.log("Structure initialized (idempotent)");
	}

	// Run seed_core.sql (idempotent)
	console.log("Seeding database core...");
	if (fs.existsSync(seedCorePath)) {
		const seedCoreSQL = fs.readFileSync(seedCorePath, "utf8");
		await db.query(seedCoreSQL);
		console.log("Database Core Seeded (idempotent)");
	}

	// Process all campaign seed files
	console.log("Processing campaign seeds...");
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
			console.log(`Skipping ${file}: file is empty`);
			skippedCount++;
			continue;
		}

		// Extract campaign name from the VALUES clause
		const match = sql.match(
			/INSERT\s+INTO\s+campaigns\s*\([^)]*campaign_name[^)]*\)\s*VALUES\s*\(\s*'([^']+)'/i
		);
		const campaignName = match ? match[1] : null;

		if (!campaignName) {
			console.log(`Skipping ${file}: could not detect campaign name`);
			skippedCount++;
			continue;
		}

		// Check if this campaign already exists
		const exists = await db.query(
			"SELECT 1 FROM campaigns WHERE campaign_name = $1 LIMIT 1",
			[campaignName]
		);

		if (exists.rowCount > 0) {
			console.log(`Skipping ${file}: campaign "${campaignName}" already exists`);
			skippedCount++;
			continue;
		}

		// Seed the campaign
		console.log(`Seeding new campaign: ${campaignName}`);

		// Transaction safety
		await db.query("BEGIN");
		try {
			await db.query(sql);
			await db.query("COMMIT");
			appliedCount++;
		} catch (err) {
			await db.query("ROLLBACK");
			skippedCount++;
			throw err;
		}
	}

	console.log(`All campaign seeds processed: ${appliedCount} applied, ${skippedCount} skipped`);
	return true;
};

// Development Tests
const testConnection = async () => {
	const result = await db.query("SELECT NOW() as current_time");
	console.log("Database connection successful:", result.rows[0].current_time);
	return true;
}

export { setupDatabase, testConnection };