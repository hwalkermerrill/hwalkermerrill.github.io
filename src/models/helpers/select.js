// Imports
import db from "../db.js";

// Get all campaigns
const getCampaigns = async () => {
	const { rows } = await db.query(`
    SELECT id, campaign_name
    FROM campaigns
    ORDER BY id ASC
  `);
	return rows;
};

// Get by campaign
const getPcByCampaign = async (campaignId) => {
	const { rows } = await db.query(`
    SELECT id, pc_name AS name
    FROM pc_main
    WHERE campaign_id = $1
    ORDER BY pc_name ASC
  `, [campaignId]);
	return rows;
};

const getCompanionByCampaign = async (campaignId) => {
	const { rows } = await db.query(`
    SELECT id, companion_name AS name
    FROM companion_main
    WHERE campaign_id = $1
    ORDER BY companion_name ASC
  `, [campaignId]);
	return rows;
};

const getNpcByCampaign = async (campaignId) => {
	const { rows } = await db.query(`
    SELECT id, npc_name AS name
    FROM npc_main
    WHERE campaign_id = $1
    ORDER BY npc_name ASC
  `, [campaignId]);
	return rows;
};

const getFactionByCampaign = async (campaignId) => {
	const { rows } = await db.query(`
    SELECT id, faction_name AS name
    FROM factions
    WHERE campaign_id = $1
    ORDER BY faction_name ASC
  `, [campaignId]);
	return rows;
};

// Exports
export {
	getCampaigns,
	getPcByCampaign,
	getCompanionByCampaign,
	getNpcByCampaign,
	getFactionByCampaign
}