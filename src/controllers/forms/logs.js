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

// Permissions
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
		gallery_is_main
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

		// Insert paragraphs
		if (Array.isArray(paragraph_text)) {
			await deleteParagraphsForLog(logId);
			for (let i = 0; i < paragraph_text.length; i++) {
				const text = paragraph_text[i].trim();
				if (text.length > 0) {
					await insertParagraph(logId, i + 1, text, req.session.user.id);
				}
			}
		}

		// Insert gallery images
		if (Array.isArray(gallery_url)) {
			await deleteGalleryForLog(logId);
			for (let i = 0; i < gallery_url.length; i++) {
				const url = gallery_url[i].trim();
				if (url.length > 0) {
					await insertGalleryImage(logId, {
						imageUrl: url,
						alt: gallery_alt[i] || "Session Image",
						isMain: gallery_is_main[i] === "true"
					});
				}
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
		gallery_is_main
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

		// Replace paragraphs
		await deleteParagraphsForLog(logId);
		if (Array.isArray(paragraph_text)) {
			for (let i = 0; i < paragraph_text.length; i++) {
				const text = paragraph_text[i].trim();
				if (text.length > 0) {
					await insertParagraph(logId, i + 1, text, req.session.user.id);
				}
			}
		}

		// Replace gallery
		await deleteGalleryForLog(logId);
		if (Array.isArray(gallery_url)) {
			for (let i = 0; i < gallery_url.length; i++) {
				const url = gallery_url[i].trim();
				if (url.length > 0) {
					await insertGalleryImage(logId, {
						imageUrl: url,
						alt: gallery_alt[i] || "Session Image",
						isMain: gallery_is_main[i] === "true"
					});
				}
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

	res.render("forms/logs/select", {
		title: "Manage Logs",
		activePage: "logs",
		campaigns,
		logTypes
	});
}

async function showCreateLogForm(req, res) {
	if (!req.session.user || !canEdit(req.session.user)) {
		return res.redirect("/login");
	}

	const { campaigns, logTypes } = await loadFormData();

	res.render("forms/logs/form", {
		title: "Create Log",
		activePage: "logs",
		formMode: "create",
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
	deleteLogController,
	togglePin
};
