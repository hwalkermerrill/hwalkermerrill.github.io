// Imports
import { runStructure, runSeedCore, runCampaign } from "./seedSQL.js";

// Get command line arguments
const arg = process.argv[2];
const extra = process.argv[3]; // for campaign filename

// Execute on call based on arguments
(async () => {
	try {
		if (arg === "structure") {
			console.log(await runStructure());
		} else if (arg === "core") {
			console.log(await runSeedCore());
		} else if (arg === "campaign") {
			if (!extra) {
				console.error("Usage: pnpm db:campaign <filename>");
				process.exit(1);
			}
			console.log(await runCampaign(extra));
		} else {
			console.log("Usage:");
			console.log("  pnpm db:structure");
			console.log("  pnpm db:core");
			console.log("  pnpm db:campaign <filename>");
		}

		process.exit(0);
	} catch (err) {
		console.error("Error:", err);
		process.exit(1);
	}
})();
