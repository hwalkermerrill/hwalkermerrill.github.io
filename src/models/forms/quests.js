// Imports
import db from "../db.js";
import { sanitizeText } from "../../utils/validation.js";

// Main Model Functions
async function getQuestById(questId) {
	const { rows } = await db.query(
		`
    SELECT *
    FROM quests
    WHERE id = $1
    `,
		[questId]
	);
	return rows[0] || null;
}

async function createQuest({
	campaignId,
	activeStatusId,
	questType,
	questName,
	deadline,
	description,
	sessionReceived,
	sessionComplete,
	pinned
}) {
	const sanitizedDescription = description ? sanitizeText(description) : null;
	const sanitizedDeadline = deadline ? sanitizeText(deadline) : null;

	const { rows } = await db.query(
		`
    INSERT INTO quests
      (campaign_id, active_status_id, quest_type, quest_name,
       deadline, description, session_received, session_complete, pinned)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
    RETURNING id
    `,
		[
			campaignId,
			activeStatusId,
			questType,
			questName,
			sanitizedDeadline,
			sanitizedDescription,
			sessionReceived,
			sessionComplete,
			pinned
		]
	);

	return rows[0].id;
}

async function updateQuest(
	questId,
	{
		campaignId,
		activeStatusId,
		questType,
		questName,
		deadline,
		description,
		sessionReceived,
		sessionComplete,
		pinned
	}
) {
	const sanitizedDescription = description ? sanitizeText(description) : null;
	const sanitizedDeadline = deadline ? sanitizeText(deadline) : null;

	await db.query(
		`
    UPDATE quests
    SET campaign_id = $1,
        active_status_id = $2,
        quest_type = $3,
        quest_name = $4,
        deadline = $5,
        description = $6,
        session_received = $7,
        session_complete = $8,
        pinned = $9
    WHERE id = $10
    `,
		[
			campaignId,
			activeStatusId,
			questType,
			questName,
			sanitizedDeadline,
			sanitizedDescription,
			sessionReceived,
			sessionComplete,
			pinned,
			questId
		]
	);
}

// Delete Model Functions
async function deleteQuest(questId) {
	await db.query(
		`
    DELETE FROM quests
    WHERE id = $1
    `,
		[questId]
	);
}

// Link Tables: NPCs, Factions, Items
async function deleteNpcLinksForQuest(questId) {
	await db.query(
		`
    DELETE FROM npc_quests
    WHERE quest_id = $1
    `,
		[questId]
	);
}

async function deleteFactionLinksForQuest(questId) {
	await db.query(
		`
    DELETE FROM faction_quests
    WHERE quest_id = $1
    `,
		[questId]
	);
}

async function deleteItemLinksForQuest(questId) {
	await db.query(
		`
    DELETE FROM item_quests
    WHERE quest_id = $1
    `,
		[questId]
	);
}

async function attachNpcToQuest(npcId, questId) {
	await db.query(
		`
    INSERT INTO npc_quests (npc_id, quest_id)
    VALUES ($1, $2)
    ON CONFLICT (npc_id, quest_id) DO NOTHING
    `,
		[npcId, questId]
	);
}

async function attachFactionToQuest(factionId, questId) {
	await db.query(
		`
    INSERT INTO faction_quests (faction_id, quest_id)
    VALUES ($1, $2)
    ON CONFLICT (faction_id, quest_id) DO NOTHING
    `,
		[factionId, questId]
	);
}

async function attachItemToQuest(itemId, questId) {
	await db.query(
		`
    INSERT INTO item_quests (item_id, quest_id)
    VALUES ($1, $2)
    ON CONFLICT (item_id, quest_id) DO NOTHING
    `,
		[itemId, questId]
	);
}

// Display log to Journal
async function getQuestsForCampaign(campaignId) {
	const { rows } = await db.query(
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
		[campaignId]
	);
	return rows;
}

// Exports
export {
	getQuestById,
	getQuestsForCampaign,
	createQuest,
	updateQuest,
	deleteQuest,
	deleteNpcLinksForQuest,
	deleteFactionLinksForQuest,
	deleteItemLinksForQuest,
	attachNpcToQuest,
	attachFactionToQuest,
	attachItemToQuest
};
