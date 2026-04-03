// Imports
import db from "./db.js";
import fs from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";

// Constants
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const setupDatabase = async () => {
	// Setup and test database connection
	let hasData = false;
	try {
		const result = await db.query(
			"SELECT EXISTS (SELECT 1 FROM pc_main LIMIT 1) as has_data"
		);
		hasData = result.rows[0]?.has_data || false;
	} catch (error) { // eslint-disable-line no-unused-vars
		hasData = false;
	}

	if (hasData) {
		console.log("Database already seeded");
		return true;
	}

	// Run structure.sql if it exists to ensure tables are created
	const structurePath = join(__dirname, "sql", "structure.sql");
	if (fs.existsSync(structurePath)) {
		const structureSQL = fs.readFileSync(structurePath, "utf8");
		await db.query(structureSQL);
		console.log("Structure database tables initialized");
	}

	// No faculty found - run full seed
	console.log("Seeding database...");
	const seedPath = join(__dirname, "sql", "seed.sql");
	const seedSQL = fs.readFileSync(seedPath, "utf8");
	await db.query(seedSQL);

	console.log("Database seeded successfully");
	return true;
};

// Development Tests
const testConnection = async () => {
	const result = await db.query("SELECT NOW() as current_time");
	console.log("Database connection successful:", result.rows[0].current_time);
	return true;
}

export { setupDatabase, testConnection };