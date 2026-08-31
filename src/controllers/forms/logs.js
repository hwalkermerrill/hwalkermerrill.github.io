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

function normalizeToArray(value) {
	if (!value) return [];
	return Array.isArray(value) ? value : [value];
}

function isValidImageUrl(url) {
	// Must not contain whitespace
	if (/\s/.test(url)) return false;

	// Allow absolute URLs
	if (/^https?:\/\//i.test(url)) {
		// Must end with a common image extension
		return /\.(png|jpg|jpeg|gif|webp)$/i.test(url);
	}

	// Allow relative URLs starting with /
	if (url.startsWith("/")) {
		// Must end with a common image extension
		return /\.(png|jpg|jpeg|gif|webp)$/i.test(url);
	}

	// Everything else is invalid
	return false;
}

function canEdit(user) {
	return hasRole(user, "gm_admin") || hasRole(user, "moderator");
}

function canDelete(user) {
	return hasRole(user, "gm_admin");
}

// Helpers
async function loadFormData() {
	const { rows: campaigns } = await db.query(`
    SELECT id, campaign_name
    FROM campaigns
    ORDER BY id ASC
  `);

	// Hard-coded log types with other field for text entry
	// Session Summary on top, documents | lore | npc spotlight | quests, other on bottom
	const logTypes = [
		"session summary",
		"documents",
		"lore",
		"npc spotlight",
		// "quests",
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

// - Dry Helpers (paragraphs | galleries)
async function replaceParagraphsForLog(logId, paragraph_text, userId) {
	await deleteParagraphsForLog(logId);

	const paragraphs = normalizeToArray(paragraph_text);

	for (let i = 0; i < paragraphs.length; i++) {
		const raw = paragraphs[i];
		const text = sanitizeParagraphContent(raw);
		if (text.length > 0) {
			await insertParagraph(logId, i + 1, text, userId);
		}
	}
}

async function replaceGalleryForLog(req, logId, {
	gallery_url,
	gallery_alt,
	gallery_type,
	gallery_is_tall,
	gallery_hover_visible
}) {
	await deleteGalleryForLog(logId);

	const galleryUrls = normalizeToArray(gallery_url);
	const galleryAlts = normalizeToArray(gallery_alt);
	const galleryTypes = normalizeToArray(gallery_type);
	const galleryTall = normalizeToArray(gallery_is_tall);
	const galleryHoverVisible = normalizeToArray(gallery_hover_visible);

	if (galleryUrls.length === 0) {
		return; // No gallery rows to insert.
	}

	let mainAssigned = false;
	let hoverAssigned = false;

	for (let i = 0; i < galleryUrls.length; i++) {
		const rawUrl = galleryUrls[i] || "";
		const url = rawUrl.trim();

		// Server-side URL validation.
		if (!isValidImageUrl(url)) {
			req.flash("error", `Invalid image URL: "${rawUrl}". Must be a valid http/https image link.`);
			continue;
		}

		const alt = galleryAlts[i] || "Session Image";
		const type = galleryTypes[i] || "extra";

		let isMain = false;
		let isHover = false;

		// Enforce only one Main image.
		if (type === "main") {
			if (!mainAssigned) {
				isMain = true;
				mainAssigned = true;
			} else {
				req.flash("error", "Only one image can be Main. Extra images were downgraded to Extra.");
			}
		}

		// Enforce only one Hover image.
		if (type === "hover") {
			if (!hoverAssigned) {
				isHover = true;
				hoverAssigned = true;
			} else {
				req.flash("error", "Only one image can be Hover. Extra images were downgraded to Extra.");
			}
		}

		const isTall = galleryTall[i] === "true";
		const hoverVisible = galleryHoverVisible[i] === "true";

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

		// Use dry helpers for sanitized paragraphs and galleries
		await replaceParagraphsForLog(logId, paragraph_text, req.session.user.id);
		await replaceGalleryForLog(req, logId, { gallery_url, gallery_alt, gallery_type, gallery_is_tall, gallery_hover_visible });

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

		// Use dry helpers for sanitized paragraphs and galleries
		await replaceParagraphsForLog(logId, paragraph_text, req.session.user.id);
		await replaceGalleryForLog(req, logId, { gallery_url, gallery_alt, gallery_type, gallery_is_tall, gallery_hover_visible });

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
