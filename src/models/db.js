// Imports
import fs from "fs";
import path from "path";
import { Pool } from "pg";
import { fileURLToPath } from "url";

// Constants
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const caCert = fs.readFileSync(path.join(__dirname, "../../bin", "byuicse-psql-cert.pem"));

const pool = new Pool({
	// Create a connection pool to avoid the overhead of creating new connections for
	// each request. This improves performance and reduces load on the database server.
	connectionString: process.env.DB_URL,
	ssl: {
		ca: caCert,
		rejectUnauthorized: true,  // SECURITY: Keep this true for proper security
		checkServerIdentity: () => { return undefined; }  // Skip hostname verification but keep cert chain validation
	}
});

// Development Tools
let db = null; // Allows development mode modifications
if (process.env.NODE_ENV.includes("dev") && process.env.ENABLE_SQL_LOGGING === "true") {
	// Logs queries and errors in development mode only.
	db = {
		async query(text, params) {
			try {
				const start = Date.now();
				const res = await pool.query(text, params);
				const duration = Date.now() - start;
				console.log("Executed query:", {
					text: text.replace(/\s+/g, " ").trim(),
					duration: `${duration}ms`,
					rows: res.rowCount
				});
				return res;
			} catch (error) {
				console.error("Error in query:", {
					text: text.replace(/\s+/g, " ").trim(),
					error: error.message
				});
				throw error;
			}
		},

		async close() {
			await pool.end();
		}
	};
} else {
	db = pool;
}

// Exports
export default db;
export { caCert };