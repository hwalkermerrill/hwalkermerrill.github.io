// Imports
import {
	getAllCategories,
	// getNotesForUserCampaign,
	// getPublicNotesForCampaign,
	getNoteById,
	createPlayerNote,
	updatePlayerNote,
	deletePlayerNote
} from "../../models/forms/notes.js";

import { hasRole } from "../../utils/permissions.js";
import db from "../../models/db.js";

// Helper Functions

/**
 * Load all dropdown data needed for the note form:
 * - categories
 * - campaigns
 * - PCs for the user
 */
async function loadFormData(userId) {
	const categories = await getAllCategories();

	// Load all campaigns (for dropdown)
	const { rows: campaigns } = await db.query(
		`SELECT id, campaign_name
     FROM campaigns
     ORDER BY id ASC`
	);

	// Load PCs for the user (for dropdown)
	const { rows: pcs } = await db.query(
		`SELECT id, pc_name, campaign_id
     FROM pc_main
     WHERE user_id = $1
     ORDER BY pc_name ASC`,
		[userId]
	);

	return { categories, campaigns, pcs };
}

// CRUD Functions
// *Create
async function showCreateNoteForm(req, res) {
	if (!req.session.user) {
		return res.redirect("/login");
	}

	const userId = req.session.user.id;
	const formData = await loadFormData(userId);
	const campaign_id = res.locals.campaign_id;

	res.render("forms/notes/form", {
		title: "Take Notes",
		activePage: "notes",
		formMode: "create",
		note: null,
		campaign_id,
		...formData
	});
}
async function submitNewNote(req, res) {
	if (!req.session.user) {
		return res.redirect("/login");
	}

	const userId = req.session.user.id;
	const {
		campaign_id,
		pc_id,
		category_id,
		note_title,
		note_content,
		is_public
	} = req.body;

	// Validation
	if (!note_title || !note_title.trim()) {
		req.flash("error", "Note title cannot be empty.");
		return res.redirect("/journal/notes/new");
	}

	if (!note_content || !note_content.trim()) {
		req.flash("error", "Note content cannot be empty.");
		return res.redirect("/journal/notes/new");
	}

	await createPlayerNote({
		userId,
		campaignId: Number(campaign_id),
		pcId: pc_id ? Number(pc_id) : null,
		categoryId: Number(category_id),
		title: note_title.trim(),
		content: note_content,
		isPublic: is_public === "true"
	});

	// Flash and redirect
	req.flash("success", "You have taken note...");
	res.redirect("/journal#journal-tab-notes");
}


// *Update
async function showEditNoteForm(req, res) {
	if (!req.session.user) {
		return res.redirect("/login");
	}

	const userId = req.session.user.id;
	const noteId = Number(req.params.id);

	const note = await getNoteById(noteId);
	if (!note) {
		return res.status(404).send("Note not found.");
	}

	// Only the author or GM can edit
	const isGM = hasRole(req.session.user, "gm_admin");
	if (note.user_id !== userId && !isGM) {
		return res.status(403).send("Forbidden.");
	}

	const formData = await loadFormData(userId);
	const campaign_id = res.locals.campaign_id;

	res.render("forms/notes/form", {
		title: "Take Notes",
		activePage: "notes",
		formMode: "edit",
		note,
		campaign_id,
		...formData
	});
}
async function submitNoteEdit(req, res) {
	if (!req.session.user) {
		return res.redirect("/login");
	}

	const userId = req.session.user.id;
	const noteId = Number(req.params.id);

	const existing = await getNoteById(noteId);
	if (!existing) {
		return res.status(404).send("Note not found.");
	}

	const isGM = hasRole(req.session.user, "gm_admin");
	if (existing.user_id !== userId && !isGM) {
		return res.status(403).send("Forbidden.");
	}

	const {
		campaign_id,
		pc_id,
		category_id,
		note_title,
		note_content,
		is_public
	} = req.body;

	// Validation
	if (!note_title || !note_title.trim()) {
		req.flash("error", "Note title cannot be empty.");
		return res.redirect(`/journal/notes/${noteId}/edit`);
	}

	if (!note_content || !note_content.trim()) {
		req.flash("error", "Note content cannot be empty.");
		return res.redirect(`/journal/notes/${noteId}/edit`);
	}

	await updatePlayerNote(noteId, {
		title: note_title.trim(),
		content: note_content,
		categoryId: Number(category_id),
		pcId: pc_id ? Number(pc_id) : null,
		isPublic: is_public === "true"
	});

	// Flash and redirect
	req.flash("success", "You adjusted your view of the taken note...");
	res.redirect("/journal#journal-tab-notes");
}

// *Delete
async function deleteNote(req, res) {
	if (!req.session.user) {
		return res.redirect("/login");
	}

	const userId = req.session.user.id;
	const noteId = Number(req.params.id);

	const existing = await getNoteById(noteId);
	if (!existing) {
		return res.status(404).send("Note not found.");
	}

	const isGM = hasRole(req.session.user, "gm_admin");

	// Author OR GM can delete
	if (existing.user_id !== userId && !isGM) {
		return res.status(403).send("Forbidden.");
	}

	await deletePlayerNote(noteId);

	// Flash and redirect
	req.flash("success", "You have forgotten...");
	res.redirect("/journal#journal-tab-notes");
}

// Exports
export {
	showCreateNoteForm,
	submitNewNote,
	showEditNoteForm,
	submitNoteEdit,
	deleteNote
};
