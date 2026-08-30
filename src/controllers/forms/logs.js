// Imports
import {
	// getSessionLogsForCampaign,
	// getSessionLogContent,
	getParagraphsForLogs,
	getGalleryForLogs
} from "../../models/pages/journal.js";

import {
	createLog,
	updateLog,
	deleteLog,
	deleteParagraphsForLog,
	insertParagraph,
	deleteGalleryForLog,
	insertGalleryImage,
	getLogById
} from "../../models/forms/logs.js";

import { hasRole } from "../../utils/permissions.js";
import db from "../../models/db.js";

// Helpers
// Load campaigns and log types
async function loadFormData() {
	const { rows: campaigns } = await db.query(`
    SELECT id, campaign_name
    FROM campaigns
    ORDER BY id ASC
  `);

	// Hard-coded log types with other field for text entry
	const logTypes = [
		"session summary",
		"quest recap",
		"npc spotlight",
		"lore entry",
		"other"
	];

	return { campaigns, logTypes };
}

// Handle selection of existing logs
async function handleLogSelect(req, res) {
	if (!req.session.user || !canEdit(req.session.user)) {
		return res.redirect("/login");
	}

	const {
		campaign_id,
		log_type,
		custom_log_type,
		session_number
	} = req.body;

	const finalLogType =
		log_type === "other" ? (custom_log_type || "").trim() : log_type;

	try {
		const { rows } = await db.query(
			`
      SELECT id
      FROM session_logs
      WHERE campaign_id = $1
        AND log_type = $2
        AND session_number = $3
      LIMIT 1
      `,
			[Number(campaign_id), finalLogType, Number(session_number)]
		);

		// If found, redirect to edit page. If not found, redirect to page creation.
		if (rows.length > 0) {
			return res.redirect(`/logs/${rows[0].id}/edit`);
		}
		else {
			req.flash("info", "No log found for that selection. You can create a new one.");
			return res.redirect("/logs/new");
		}

	} catch (err) {
		console.error(err);
		req.flash("error", "Failed to load log selection.");
		return res.redirect("/logs/select");
	}
}

// Sanitation and Validation
function sanitizeParagraphContent(raw = "") {
	if (!raw) return "";

	// Escape all HTML
	let safe = raw.replace(/&/g, "&amp;")
		.replace(/</g, "&lt;")
		.replace(/>/g, "&gt;");

	// Allowed and re-enabled: <b> and <i>
	safe = safe
		.replace(/&lt;b&gt;/g, "<b>")
		.replace(/&lt;\/b&gt;/g, "</b>")
		.replace(/&lt;i&gt;/g, "<i>")
		.replace(/&lt;\/i&gt;/g, "</i>");

	// Trim leading/trailing whitespace
	return safe.trim();
}

function isValidImageUrl(url) {
	// Must not contain whitespace
	if (/\s/.test(url)) return false;

	// Must start with http or https
	if (!/^https?:\/\//i.test(url)) return false;

	// Must end with a common image extension
	if (!/\.(png|jpg|jpeg|gif|webp)$/i.test(url)) return false;

	return true;
}

function canEdit(user) {
	return hasRole(user, "gm_admin") || hasRole(user, "moderator");
}

function canDelete(user) {
	return hasRole(user, "gm_admin");
}


// Controller Functions
async function submitNewLog(req, res) {
	if (!req.session.user || !canEdit(req.session.user)) {
		return res.redirect("/login");
	}

	const {
		campaign_id,
		log_type,
		custom_log_type,
		book_number,
		session_number,
		title,
		time_span,
		session_date,
		pinned,
		paragraph_text,
		gallery_url,
		gallery_alt,
		gallery_type,
		gallery_is_tall,
		gallery_hover_visible
	} = req.body;

	// Allow typing custom log type string
	const finalLogType = log_type === "other" ? (custom_log_type || "").trim() : log_type;

	try {
		// Create main log
		const logId = await createLog({
			campaignId: Number(campaign_id),
			logType: finalLogType,
			bookNumber: Number(book_number) || null,
			sessionNumber: Number(session_number),
			title: title.trim(),
			timeSpan: time_span || null,
			sessionDate: session_date || null,
			pinned: pinned === "true"
		});

		// Sanitize and insert paragraphs
		await deleteParagraphsForLog(logId);
		if (Array.isArray(paragraph_text)) {
			for (let i = 0; i < paragraph_text.length; i++) {
				const raw = paragraph_text[i];
				const text = sanitizeParagraphContent(raw);
				if (text.length > 0) {
					await insertParagraph(logId, i + 1, text, req.session.user.id);
				}
			}
		}

		// Sanitize and insert gallery images
		await deleteGalleryForLog(logId);
		if (Array.isArray(gallery_url)) {
			let mainAssigned = false;
			let hoverAssigned = false;

			for (let i = 0; i < gallery_url.length; i++) {
				const url = (gallery_url[i] || "").trim();

				// Validate
				if (!isValidImageUrl(url)) {
					req.flash("error", `Invalid image URL: "${url}". Must be a valid http/https image link.`);
					continue; // Skip invalid URL
				}

				const alt = (gallery_alt && gallery_alt[i]) || "Session Image";
				const type = gallery_type && gallery_type[i] ? gallery_type[i] : "extra";
				let isMain = false;
				let isHover = false;

				if (type === "main" && !mainAssigned) {
					isMain = true;
					mainAssigned = true;
				} else if (type === "hover" && !hoverAssigned) {
					isHover = true;
					hoverAssigned = true;
				}

				const isTall = gallery_is_tall && gallery_is_tall[i] === "true";
				const hoverVisible = gallery_hover_visible && gallery_hover_visible[i] === "true";

				await insertGalleryImage(logId, {
					imageUrl: url,
					alt,
					isMain,
					isHover,
					hoverVisible,
					isTall
				});
			}
		}

		req.flash("success", "Log created successfully!");
		res.redirect("/journal");
	} catch (err) {
		console.error(err);
		req.flash("error", "Failed to create log.");
		res.redirect("/logs/new");
	}
}

async function submitLogEdit(req, res) {
	if (!req.session.user || !canEdit(req.session.user)) {
		return res.redirect("/login");
	}

	const logId = Number(req.params.id);

	const {
		campaign_id,
		log_type,
		custom_log_type,
		book_number,
		session_number,
		title,
		time_span,
		session_date,
		pinned,
		paragraph_text,
		gallery_url,
		gallery_alt,
		gallery_type,
		gallery_is_tall,
		gallery_hover_visible
	} = req.body;

	// Allow typing custom log type string
	const finalLogType = log_type === "other" ? (custom_log_type || "").trim() : log_type;

	try {
		await updateLog(logId, {
			campaignId: Number(campaign_id),
			logType: finalLogType,
			bookNumber: Number(book_number) || null,
			sessionNumber: Number(session_number),
			title: title.trim(),
			timeSpan: time_span || null,
			sessionDate: session_date || null,
			pinned: pinned === "true"
		});

		// Sanitize and replace paragraphs
		await deleteParagraphsForLog(logId);
		if (Array.isArray(paragraph_text)) {
			for (let i = 0; i < paragraph_text.length; i++) {
				const raw = paragraph_text[i];
				const text = sanitizeParagraphContent(raw);
				if (text.length > 0) {
					await insertParagraph(logId, i + 1, text, req.session.user.id);
				}
			}
		}

		// Sanitize and replace gallery
		await deleteGalleryForLog(logId);
		if (Array.isArray(gallery_url)) {
			let mainAssigned = false;
			let hoverAssigned = false;

			for (let i = 0; i < gallery_url.length; i++) {
				const url = (gallery_url[i] || "").trim();

				if (!isValidImageUrl(url)) {
					req.flash("error", `Invalid image URL: "${url}". Must be a valid http/https image link.`);
					continue; // Skip invalid URL
				}

				const alt = (gallery_alt && gallery_alt[i]) || "Session Image";
				const type = gallery_type && gallery_type[i] ? gallery_type[i] : "extra";
				let isMain = false;
				let isHover = false;

				if (type === "main" && !mainAssigned) {
					isMain = true;
					mainAssigned = true;
				} else if (type === "hover" && !hoverAssigned) {
					isHover = true;
					hoverAssigned = true;
				}

				const isTall = gallery_is_tall && gallery_is_tall[i] === "true";
				const hoverVisible = gallery_hover_visible && gallery_hover_visible[i] === "true";

				await insertGalleryImage(logId, {
					imageUrl: url,
					alt,
					isMain,
					isHover,
					hoverVisible,
					isTall
				});
			}
		}

		req.flash("success", "Log updated successfully!");
		res.redirect("/journal");
	} catch (err) {
		console.error(err);
		req.flash("error", "Failed to update log.");
		res.redirect(`/logs/${logId}/edit`);
	}
}

async function togglePin(req, res) {
	if (!req.session.user || !canEdit(req.session.user)) {
		return res.redirect("/login");
	}

	const logId = Number(req.params.id);
	const { pinned } = req.body;

	try {
		await updateLog(logId, { pinned: pinned === "true" });
		req.flash("success", pinned === "true" ? "Pinned!" : "Unpinned!");
		res.redirect("/journal");
	} catch (err) {
		console.error(err);
		req.flash("error", "Failed to update pin status.");
		res.redirect("/journal");
	}
}

// GM Only Controller Functions
async function deleteLogController(req, res) {
	if (!req.session.user || !canDelete(req.session.user)) {
		return res.redirect("/login");
	}

	const logId = Number(req.params.id);

	try {
		await deleteLog(logId);
		req.flash("success", "Log deleted.");
		res.redirect("/journal");
	} catch (err) {
		console.error(err);
		req.flash("error", "Failed to delete log.");
		res.redirect("/journal");
	}
}

// Router Renders
async function showLogSelectPage(req, res) {
	if (!req.session.user || !canEdit(req.session.user)) {
		return res.redirect("/login");
	}

	const { campaigns, logTypes } = await loadFormData();
	const campaign_id = res.locals.campaign_id;

	res.render("forms/logs/select", {
		title: "Manage Logs",
		activePage: "logs",
		campaign_id,
		campaigns,
		logTypes
	});
}

async function showCreateLogForm(req, res) {
	if (!req.session.user || !canEdit(req.session.user)) {
		return res.redirect("/login");
	}

	const { campaigns, logTypes } = await loadFormData();
	const campaign_id = res.locals.campaign_id;

	res.render("forms/logs/form", {
		title: "Create Log",
		activePage: "logs",
		formMode: "create",
		campaign_id,
		log: null,
		paragraphs: [],
		gallery: [],
		campaigns,
		logTypes
	});
}

async function showEditLogForm(req, res) {
	if (!req.session.user || !canEdit(req.session.user)) {
		return res.redirect("/login");
	}

	const logId = Number(req.params.id);
	const log = await getLogById(logId);

	if (!log) {
		return res.status(404).send("Log not found.");
	}

	const paragraphs = await getParagraphsForLogs([logId]);
	const gallery = await getGalleryForLogs([logId]);
	const { campaigns, logTypes } = await loadFormData();

	res.render("forms/logs/form", {
		title: "Edit Log",
		activePage: "logs",
		formMode: "edit",
		log,
		paragraphs,
		gallery,
		campaigns,
		logTypes
	});
}

// Exports
export {
	showLogSelectPage,
	showCreateLogForm,
	submitNewLog,
	showEditLogForm,
	submitLogEdit,
	handleLogSelect,
	deleteLogController,
	togglePin
};
