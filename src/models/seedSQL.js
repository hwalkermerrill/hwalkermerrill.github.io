// Imports
import db from "./db.js";
import fs from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";

//Constants
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const sqlDir = join(__dirname, "sql");

// Helper function to run an SQL file
async function runSQLFile(filename) {
	const filePath = join(sqlDir, filename);

	if (!fs.existsSync(filePath)) {
		console.error(`SQL file not found: ${filename}`);
		process.exit(1);
	}

	const sql = fs.readFileSync(filePath, "utf8");

	try {
		console.log(`Running ${filename}...`);
		await db.query(sql);
		console.log(`${filename} completed.`);
	} catch (err) {
		console.error(`Error running ${filename}:`, err);
		process.exit(1);
	}
}

// Individual runners
const runStructure = async () => {
	await runSQLFile("structure.sql");
	return "structure.sql seeded.";
};

const runSeedCore = async () => {
	await runSQLFile("seed_core.sql");
	return "seed_core.sql seeded.";
};

const runCampaign = async (file) => {
	let fileName = join("seed_campaign_", file);
	await runSQLFile(fileName);
	return `${fileName} seeded.`;
}

export { runStructure, runSeedCore, runCampaign };
