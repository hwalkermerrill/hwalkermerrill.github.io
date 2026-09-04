// Imports
import {
	createQuest,
	updateQuest,
	deleteQuest,
	deleteNpcLinksForQuest,
	deleteFactionLinksForQuest,
	deleteItemLinksForQuest,
	attachNpcToQuest,
	attachFactionToQuest,
	attachItemToQuest,
	getQuestById
} from "../../models/forms/quests.js";

import { hasRole } from "../../utils/permissions.js";
import db from "../../models/db.js";

// Normalization
function normalizeToArray(value) {
	if (!value) return [];
	return Array.isArray(value) ? value : [value];
}

// Permissions (GM only for everything)
function canEdit(user) {
	return hasRole(user, "gm_admin");
}

function canDelete(user) {
	return hasRole(user, "gm_admin");
}

// Helpers
async function loadFormData(campaignId) {
	// All campaigns (for dropdown)
	const { rows: campaigns } = await db.query(`
    SELECT id, campaign_name
    FROM campaigns
    ORDER BY id ASC
  `);

	// Active status options (Pending, Active, Retired, Deceased)
	const { rows: activeStatuses } = await db.query(`
    SELECT id, active_status_name
    FROM active_status
    ORDER BY id ASC
  `);

	// Hard-coded quest types in desired order
	const questTypes = [
		"main",
		"personal",
		"companion",
		"area",
		"side",
		"radiant",
		"other"
	];

	// NPCs for this campaign
	const { rows: npcs } = await db.query(
		`
    SELECT id, npc_name
    FROM npc_main
    WHERE campaign_id = $1
    ORDER BY npc_name ASC
    `,
		[campaignId]
	);

	// Factions for this campaign
	const { rows: factions } = await db.query(
		`
    SELECT id, faction_name
    FROM factions
    WHERE campaign_id = $1
    ORDER BY faction_name ASC
    `,
		[campaignId]
	);

	// Items for this campaign
	const { rows: items } = await db.query(
		`
    SELECT id, item_name
    FROM items
    WHERE campaign_id = $1
    ORDER BY item_name ASC
    `,
		[campaignId]
	);

	return { campaigns, activeStatuses, questTypes, npcs, factions, items };
}

// --- Dry helpers for FK links ---

async function replaceQuestLinks(questId, npc_ids, faction_ids, item_ids) {
	// Clear existing links
	await deleteNpcLinksForQuest(questId);
	await deleteFactionLinksForQuest(questId);
	await deleteItemLinksForQuest(questId);

	const npcIds = normalizeToArray(npc_ids).map(Number).filter(Boolean);
	const factionIds = normalizeToArray(faction_ids).map(Number).filter(Boolean);
	const itemIds = normalizeToArray(item_ids).map(Number).filter(Boolean);

	// Reattach NPCs
	for (const npcId of npcIds) {
		await attachNpcToQuest(npcId, questId);
	}

	// Reattach factions
	for (const factionId of factionIds) {
		await attachFactionToQuest(factionId, questId);
	}

	// Reattach items
	for (const itemId of itemIds) {
		await attachItemToQuest(itemId, questId);
	}
}

// --- Controller Functions ---

// List / manage quests (GM view)
async function showQuestListPage(req, res) {
	if (!req.session.user || !canEdit(req.session.user)) {
		return res.redirect("/login");
	}

	const campaign_id = res.locals.campaign_id;

	// Load all quests for this campaign
	const { rows: quests } = await db.query(
		`
    SELECT q.*, a.active_status_name
    FROM quests AS q
    JOIN active_status AS a
      ON a.id = q.active_status_id
    WHERE q.campaign_id = $1
    ORDER BY
      q.quest_type ASC,
      q.pinned DESC,
      q.quest_name ASC
    `,
		[campaign_id]
	);

	const formData = await loadFormData(campaign_id);

	res.render("forms/quests/list", {
		title: "Manage Quests",
		activePage: "quests",
		campaign_id,
		quests,
		...formData
	});
}

// Show create quest form
async function showCreateQuestForm(req, res) {
	if (!req.session.user || !canEdit(req.session.user)) {
		return res.redirect("/login");
	}

	const campaign_id = res.locals.campaign_id;
	const formData = await loadFormData(campaign_id);

	res.render("forms/quests/form", {
		title: "Create Quest",
		activePage: "quests",
		formMode: "create",
		campaign_id,
		quest: null,
		npcLinks: [],
		factionLinks: [],
		itemLinks: [],
		...formData
	});
}

// Submit new quest
async function submitNewQuest(req, res) {
	if (!req.session.user || !canEdit(req.session.user)) {
		return res.redirect("/login");
	}

	const {
		campaign_id,
		active_status_id,
		quest_type,
		quest_name,
		deadline,
		description,
		session_received,
		session_complete,
		pinned,
		npc_ids,
		faction_ids,
		item_ids
	} = req.body;

	try {
		const questId = await createQuest({
			campaignId: Number(campaign_id),
			activeStatusId: Number(active_status_id),
			questType: quest_type,
			questName: quest_name.trim(),
			deadline: deadline || null,
			description: description || null,
			sessionReceived: session_received ? Number(session_received) : null,
			sessionComplete: session_complete ? Number(session_complete) : null,
			pinned: pinned === "true"
		});

		await replaceQuestLinks(questId, npc_ids, faction_ids, item_ids);

		req.flash("success", "Quest created successfully!");
		res.redirect("/quests/manage");
	} catch (err) {
		console.error(err);
		req.flash("error", "Failed to create quest.");
		res.redirect("/quests/create");
	}
}

// Show edit quest form
async function showEditQuestForm(req, res) {
	if (!req.session.user || !canEdit(req.session.user)) {
		return res.redirect("/login");
	}

	const questId = Number(req.params.id);
	const quest = await getQuestById(questId);

	if (!quest) {
		return res.status(404).send("Quest not found.");
	}

	// Load existing links
	const { rows: npcLinksRows } = await db.query(
		`
    SELECT npc_id
    FROM npc_quests
    WHERE quest_id = $1
    `,
		[questId]
	);
	const { rows: factionLinksRows } = await db.query(
		`
    SELECT faction_id
    FROM faction_quests
    WHERE quest_id = $1
    `,
		[questId]
	);
	const { rows: itemLinksRows } = await db.query(
		`
    SELECT item_id
    FROM item_quests
    WHERE quest_id = $1
    `,
		[questId]
	);

	const npcLinks = npcLinksRows.map(r => r.npc_id);
	const factionLinks = factionLinksRows.map(r => r.faction_id);
	const itemLinks = itemLinksRows.map(r => r.item_id);

	const formData = await loadFormData(quest.campaign_id);

	res.render("forms/quests/form", {
		title: "Edit Quest",
		activePage: "quests",
		formMode: "edit",
		campaign_id: quest.campaign_id,
		quest,
		npcLinks,
		factionLinks,
		itemLinks,
		...formData
	});
}

// Submit quest edit
async function submitQuestEdit(req, res) {
	if (!req.session.user || !canEdit(req.session.user)) {
		return res.redirect("/login");
	}

	const questId = Number(req.params.id);

	const {
		campaign_id,
		active_status_id,
		quest_type,
		quest_name,
		deadline,
		description,
		session_received,
		session_complete,
		pinned,
		npc_ids,
		faction_ids,
		item_ids
	} = req.body;

	try {
		await updateQuest(questId, {
			campaignId: Number(campaign_id),
			activeStatusId: Number(active_status_id),
			questType: quest_type,
			questName: quest_name.trim(),
			deadline: deadline || null,
			description: description || null,
			sessionReceived: session_received ? Number(session_received) : null,
			sessionComplete: session_complete ? Number(session_complete) : null,
			pinned: pinned === "true"
		});

		await replaceQuestLinks(questId, npc_ids, faction_ids, item_ids);

		req.flash("success", "Quest updated successfully!");
		res.redirect("/quests/manage");
	} catch (err) {
		console.error(err);
		req.flash("error", "Failed to update quest.");
		res.redirect(`/quests/${questId}/edit`);
	}
}

// Toggle pin
async function toggleQuestPin(req, res) {
	if (!req.session.user || !canEdit(req.session.user)) {
		return res.redirect("/login");
	}

	const questId = Number(req.params.id);
	const { pinned } = req.body;

	try {
		await db.query(
			`
      UPDATE quests
      SET pinned = $1
      WHERE id = $2
      `,
			[pinned === "true", questId]
		);

		req.flash("success", pinned === "true" ? "Quest pinned!" : "Quest unpinned!");
		res.redirect("/quests/manage");
	} catch (err) {
		console.error(err);
		req.flash("error", "Failed to update pin status.");
		res.redirect("/quests/manage");
	}
}

// Change status (Pending/Active/Retired/Deceased)
async function updateQuestStatus(req, res) {
	if (!req.session.user || !canEdit(req.session.user)) {
		return res.redirect("/login");
	}

	const questId = Number(req.params.id);
	const { active_status_id } = req.body;

	try {
		await db.query(
			`
      UPDATE quests
      SET active_status_id = $1
      WHERE id = $2
      `,
			[Number(active_status_id), questId]
		);

		req.flash("success", "Quest status updated.");
		res.redirect("/quests/manage");
	} catch (err) {
		console.error(err);
		req.flash("error", "Failed to update quest status.");
		res.redirect("/quests/manage");
	}
}

// GM-only delete
async function deleteQuestController(req, res) {
	if (!req.session.user || !canDelete(req.session.user)) {
		return res.redirect("/login");
	}

	const questId = Number(req.params.id);

	try {
		await deleteNpcLinksForQuest(questId);
		await deleteFactionLinksForQuest(questId);
		await deleteItemLinksForQuest(questId);
		await deleteQuest(questId);

		req.flash("success", "Quest deleted.");
		res.redirect("/quests/manage");
	} catch (err) {
		console.error(err);
		req.flash("error", "Failed to delete quest.");
		res.redirect("/quests/manage");
	}
}

// Exports
export {
	showQuestListPage,
	showCreateQuestForm,
	submitNewQuest,
	showEditQuestForm,
	submitQuestEdit,
	toggleQuestPin,
	updateQuestStatus,
	deleteQuestController
};
