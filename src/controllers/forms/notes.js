// Imports
import {
	getAllCategories,
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
		return res.redirect("/notes/new");
	}

	if (!note_content || !note_content.trim()) {
		req.flash("error", "Note content cannot be empty.");
		return res.redirect("/notes/new");
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
	res.redirect("/notes/manage");
}

// *Read
async function showNoteManager(req, res) {
	if (!req.session.user) {
		return res.redirect("/login");
	}

	const user = req.session.user;
	const userId = user.id;
	const campaignId = res.locals.campaign_id;
	const isGM = hasRole(user, "gm_admin");
	let allUserNotes = [];

	// Private notes for this user
	const { rows: userNotes } = await db.query(
		`SELECT n.*, c.category_name, u.username, p.pc_name
     FROM player_notes n
     JOIN player_note_categories c ON c.id = n.category_id
     JOIN users u ON u.id = n.user_id
     LEFT JOIN pc_main p ON p.id = n.pc_id
     WHERE n.campaign_id = $1
       AND n.user_id = $2
       AND n.is_public = FALSE
     ORDER BY n.updated_at DESC`,
		[campaignId, userId]
	);

	// Public notes (party notes)
	const { rows: publicNotes } = await db.query(
		`SELECT n.*, c.category_name, u.username, p.pc_name
     FROM player_notes n
     JOIN player_note_categories c ON c.id = n.category_id
     JOIN users u ON u.id = n.user_id
     LEFT JOIN pc_main p ON p.id = n.pc_id
     WHERE n.campaign_id = $1
       AND n.is_public = TRUE
     ORDER BY u.username ASC, n.updated_at DESC`,
		[campaignId]
	);

	// GM's can view all user notes for world-building purposes
	if (isGM) {
		const { rows } = await db.query(
			`SELECT n.*, cat.category_name, u.username, p.pc_name
			FROM player_notes n
			JOIN player_note_categories cat
				ON n.category_id = cat.id
			LEFT JOIN pc_main p
				ON n.pc_id = p.id
			LEFT JOIN users u
				ON n.user_id = u.id
			WHERE n.campaign_id = $1
				AND n.is_public = FALSE
			ORDER BY u.username ASC, n.updated_at DESC`,
			[campaignId]
		);
		allUserNotes = rows;
	}

	res.render("forms/notes/list", {
		title: "Manage Notes",
		activePage: "notes",
		userNotes,
		publicNotes,
		allUserNotes,
		isGM,
		userId,
		campaign_id: campaignId
	});
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

	// Edit Permissions: Must be GM, Owner, or a public note
	const isGM = hasRole(req.session.user, "gm_admin");
	const isOwner = note.user_id === userId;
	const canEdit = note.is_public ? true : (isOwner || isGM)

	if (!canEdit) {
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

	const note = await getNoteById(noteId);
	if (!note) {
		return res.status(404).send("Note not found.");
	}

	// Edit Permissions: Must be GM, Owner, or a public note
	const isGM = hasRole(req.session.user, "gm_admin");
	const isOwner = note.user_id === userId;
	const canEdit = note.is_public ? true : (isOwner || isGM)

	if (!canEdit) {
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
		return res.redirect(`/notes/${noteId}/edit`);
	}

	if (!note_content || !note_content.trim()) {
		req.flash("error", "Note content cannot be empty.");
		return res.redirect(`/notes/${noteId}/edit`);
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
	res.redirect("/notes/manage");
}

// *Delete
async function deleteNote(req, res) {
	if (!req.session.user) {
		return res.redirect("/login");
	}

	const userId = req.session.user.id;
	const noteId = Number(req.params.id);

	const note = await getNoteById(noteId);
	if (!note) {
		return res.status(404).send("Note not found.");
	}

	const isGM = hasRole(req.session.user, "gm_admin");

	// Only author OR GM can delete
	if (note.user_id !== userId && !isGM) {
		return res.status(403).send("Forbidden.");
	}

	await deletePlayerNote(noteId);

	// Flash and redirect
	req.flash("success", "You have forgotten...");
	res.redirect("/notes/manage");
}

// Exports
export {
	showNoteManager,
	showCreateNoteForm,
	showEditNoteForm,
	submitNewNote,
	submitNoteEdit,
	deleteNote
};
