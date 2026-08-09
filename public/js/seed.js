import { runStructure, runSeedCore, runAllCampaigns } from "../src/models/seedSQL.js";

const arg = process.argv[2];

(async () => {
	try {
		if (arg === "structure") {
			await runStructure();
			console.log("structure.sql complete");
		} else if (arg === "core") {
			await runSeedCore();
			console.log("seed_core.sql complete");
		} else if (arg === "campaigns") {
			await runAllCampaigns();
			console.log("All campaign seeds complete");
		} else {
			console.error("Usage: pnpm db:<structure|core|campaigns>");
		}
		process.exit(0);
	} catch (err) {
		console.error(err);
		process.exit(1);
	}
})();
