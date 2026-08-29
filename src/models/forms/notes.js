// Imports
import db from "../db.js";

// Security
/**
 * Sanitizes note content by stripping all HTML except <i>, <b>, <br>.
 * Converts newlines to <br> for display consistency.
 */
function sanitizeNoteContent(rawContent = "") {
	if (!rawContent) return "";

	// Escape all HTML first
	let safe = rawContent
		.replace(/</g, "&lt;")
		.replace(/>/g, "&gt;");

	// Re‑enable allowed tags
	safe = safe
		.replace(/&lt;i&gt;/g, "<i>")
		.replace(/&lt;\/i&gt;/g, "</i>")
		.replace(/&lt;b&gt;/g, "<b>")
		.replace(/&lt;\/b&gt;/g, "</b>")
		.replace(/&lt;br&gt;/g, "<br>");

	// Convert newlines to <br>
	safe = safe.replace(/\n/g, "<br>");

	return safe;
}

// Model Functions
// Get note categories (dropdowns).
async function getAllCategories() {
	const { rows } = await db.query(
		`SELECT id, category_name
     FROM player_note_categories
     ORDER BY id ASC`
	);
	return rows;
}

// Retrieval Functions
async function getNotesForUserCampaign(userId, campaignId) {
	const { rows } = await db.query(
		`SELECT pn.*, cat.category_name, pc.pc_name, u.username
     FROM player_notes AS pn
     JOIN player_note_categories AS cat
       ON pn.category_id = cat.id
		 LEFT JOIN pc_main AS pc
			 ON pn.pc_id = pc.id
		 LEFT JOIN users AS u
		   ON pn.user_id = u.id
     WHERE pn.user_id = $1
       AND pn.campaign_id = $2
     ORDER BY pn.updated_at DESC`,
		[userId, campaignId]
	);
	return rows;
}
async function getPublicNotesForCampaign(campaignId) {
	const { rows } = await db.query(
		`SELECT pn.*, cat.category_name, pc.pc_name, u.username
     FROM player_notes AS pn
     JOIN player_note_categories AS cat
       ON pn.category_id = cat.id
		 LEFT JOIN pc_main AS pc
			 ON pn.pc_id = pc.id
		 LEFT JOIN users AS u
		   ON pn.user_id = u.id
     WHERE pn.campaign_id = $1
       AND pn.is_public = TRUE
     ORDER BY pn.updated_at DESC`,
		[campaignId]
	);
	return rows;
}
async function getNoteById(noteId) {
	const { rows } = await db.query(
		`SELECT pn.*, cat.category_name, pc.pc_name, u.username
     FROM player_notes AS pn
     JOIN player_note_categories AS cat
       ON pn.category_id = cat.id
		 LEFT JOIN pc_main AS pc
  		 ON pn.pc_id = pc.id
		 LEFT JOIN users AS u
		   ON pn.user_id = u.id
     WHERE pn.id = $1`,
		[noteId]
	);
	return rows[0] || null;
}
async function getNotesByPC(pcId) {
	const { rows } = await db.query(
		`SELECT pn.*, cat.category_name, pc.pc_name, u.username
     FROM player_notes AS pn
     JOIN player_note_categories AS cat
       ON pn.category_id = cat.id
		 LEFT JOIN pc_main AS pc
		   ON pn.pc_id = pc.id
		 LEFT JOIN users AS u
		   ON pn.user_id = u.id
     WHERE pn.pc_id = $1
     ORDER BY pn.updated_at DESC`,
		[pcId]
	);
	return rows;
}

// CRUD Functions
async function createPlayerNote({
	userId,
	campaignId,
	pcId = null,
	categoryId,
	title,
	content,
	isPublic = false
}) {
	const sanitized = sanitizeNoteContent(content);

	const { rows } = await db.query(
		`INSERT INTO player_notes
      (user_id, campaign_id, pc_id, category_id,
       note_title, note_content, is_public)
     VALUES ($1, $2, $3, $4, $5, $6, $7)
     RETURNING id`,
		[userId, campaignId, pcId, categoryId, title, sanitized, isPublic]
	);

	return rows[0].id;
}
async function updatePlayerNote(
	noteId,
	{ title, content, categoryId, pcId = null, isPublic }
) {
	const sanitized = sanitizeNoteContent(content);

	await db.query(
		`UPDATE player_notes
     SET note_title = $1,
         note_content = $2,
         category_id = $3,
         pc_id = $4,
         is_public = $5,
         updated_at = NOW()
     WHERE id = $6`,
		[title, sanitized, categoryId, pcId, isPublic, noteId]
	);

	return true;
}
async function deletePlayerNote(noteId) {
	await db.query(
		`DELETE FROM player_notes
     WHERE id = $1`,
		[noteId]
	);
	return true;
}

// Exports
export {
	sanitizeNoteContent,
	getAllCategories,
	getNotesForUserCampaign,
	getPublicNotesForCampaign,
	getNoteById,
	getNotesByPC,
	createPlayerNote,
	updatePlayerNote,
	deletePlayerNote
};