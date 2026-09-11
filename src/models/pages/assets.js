// Imports
import db from "../db.js";
import { sanitizeText } from "../../utils/validation.js";
import { normalizeToArray } from "../../utils/normalization.js";

// Quick Update Helpers
const updateItemStatus = async (itemId, activeStatusId) => {
	await db.query(
		`
      UPDATE items
      SET active_status_id = $1
      WHERE id = $2
    `,
		[activeStatusId, itemId]
	);
};

const updateItemIdentified = async (itemId, isIdentified) => {
	await db.query(
		`
      UPDATE items
      SET is_identified = $1
      WHERE id = $2
    `,
		[isIdentified, itemId]
	);
};

const updateItemBoonsVisible = async (itemId, boonsVisible) => {
	await db.query(
		`
      UPDATE items
      SET boons_visible = $1
      WHERE id = $2
    `,
		[boonsVisible, itemId]
	);
};

const updateItemOwner = async (itemId, pcId) => {
	await db.query(
		`
		INSERT INTO item_owners (item_id, pc_id, companion_id, npc_id, faction_id)
		VALUES ($1, $2, NULL, NULL, NULL)
		ON CONFLICT (item_id)
		DO UPDATE SET
			pc_id = EXCLUDED.pc_id,
			companion_id = NULL,
			npc_id = NULL,
			faction_id = NULL
    `,
		[itemId, pcId || null]
	);
};

// Allowed item types for the Assets page
const ASSET_TYPES = ["artifact", "relic", "major", "minor", "special", "favor"];

// Get all assets (with main gallery image) for a campaign
const getAssetsForCampaign = async (campaignId) => {
	const query = `
    SELECT
      i.id,
      i.active_status_id,
      i.item_name,
      i.item_type,
      i.item_subtype,
      i.sort_order,
      i.is_identified,
      i.pinned,
      i.description,
      i.ability,
      i.unlocked_boons,
      i.unlock_method,
      i.destruction_method,
      i.secrets,
      i.caster_level,
      i.unique_destruction,
      i.boons_visible,
      i.unlock_visible,
      g.image_url,
      g.alt,
      g.is_tall
    FROM items i
    LEFT JOIN item_gallery g
      ON g.item_id = i.id
      AND g.is_main = TRUE
      AND i.item_type IN ('artifact', 'relic', 'major', 'special')
    WHERE i.campaign_id = $1
      AND i.item_type = ANY($2)
    ORDER BY i.sort_order NULLS LAST, i.item_name;
  `;

	const { rows } = await db.query(query, [campaignId, ASSET_TYPES]);
	return rows;
};

// Get single item by ID
const getItemById = async (itemId) => {
	const { rows } = await db.query(`
    SELECT *
    FROM items
    WHERE id = $1
  `, [itemId]);

	return rows[0] || null;
};

// Crud Models
const createItem = async (data) => {
	const {
		campaign_id,
		item_type,
		item_subtype,
		item_name,
		description,
		ability,
		caster_level,
		active_status_id,
		is_identified,
		pinned,
		unlock_method,
		unlocked_boons,
		boons_visible,
		unlock_visible,
		destruction_method,
		unique_destruction,
		secrets
	} = data;

	const { rows } = await db.query(`
    INSERT INTO items (
      campaign_id, item_type, item_subtype, item_name,
      description, ability, caster_level,
      active_status_id, is_identified, pinned,
      unlock_method, unlocked_boons, boons_visible, unlock_visible,
      destruction_method, unique_destruction, secrets
    )
    VALUES (
      $1, $2, $3, $4,
      $5, $6, $7,
      $8, $9, $10,
      $11, $12, $13, $14,
      $15, $16, $17
    )
    RETURNING id
  `, [
		Number(campaign_id),
		item_type,
		item_subtype,
		item_name.trim(),
		sanitizeText(description),
		sanitizeText(ability),
		caster_level ? Number(caster_level) : null,
		Number(active_status_id),
		is_identified === "true",
		pinned === "true",
		sanitizeText(unlock_method),
		sanitizeText(unlocked_boons),
		boons_visible === "true",
		unlock_visible === "true",
		sanitizeText(destruction_method),
		unique_destruction === "true",
		sanitizeText(secrets)
	]);

	return rows[0].id;
};

const updateItem = async (itemId, data) => {
	const {
		item_type,
		item_subtype,
		item_name,
		description,
		ability,
		caster_level,
		active_status_id,
		is_identified,
		pinned,
		unlock_method,
		unlocked_boons,
		boons_visible,
		unlock_visible,
		destruction_method,
		unique_destruction,
		secrets
	} = data;

	await db.query(`
    UPDATE items
    SET
      item_type = $1,
      item_subtype = $2,
      item_name = $3,
      description = $4,
      ability = $5,
      caster_level = $6,
      active_status_id = $7,
      is_identified = $8,
      pinned = $9,
      unlock_method = $10,
      unlocked_boons = $11,
      boons_visible = $12,
      unlock_visible = $13,
      destruction_method = $14,
      unique_destruction = $15,
      secrets = $16
    WHERE id = $17
  `, [
		item_type,
		item_subtype,
		item_name.trim(),
		sanitizeText(description),
		sanitizeText(ability),
		caster_level ? Number(caster_level) : null,
		Number(active_status_id),
		is_identified === "true",
		pinned === "true",
		sanitizeText(unlock_method),
		sanitizeText(unlocked_boons),
		boons_visible === "true",
		unlock_visible === "true",
		sanitizeText(destruction_method),
		unique_destruction === "true",
		sanitizeText(secrets),
		itemId
	]);
};

const deleteItem = async (itemId) => {
	await db.query(`DELETE FROM item_gallery WHERE item_id = $1`, [itemId]);
	await db.query(`DELETE FROM item_owners WHERE item_id = $1`, [itemId]);
	await db.query(`DELETE FROM item_quests WHERE item_id = $1`, [itemId]);
	await db.query(`DELETE FROM items WHERE id = $1`, [itemId]);
};

// Item galleries
const getGalleryForItem = async (itemId) => {
	const { rows } = await db.query(`
    SELECT *
    FROM item_gallery
    WHERE item_id = $1
    ORDER BY id ASC
  `, [itemId]);

	return rows;
};

const replaceGalleryForItem = async (itemId, data) => {
	const urls = normalizeToArray(data.gallery_url);
	const alts = normalizeToArray(data.gallery_alt);
	const talls = normalizeToArray(data.gallery_is_tall);
	const captions = normalizeToArray(data.gallery_figcaption);

	await db.query(`
    DELETE FROM item_gallery
    WHERE item_id = $1
  `, [itemId]);

	for (let i = 0; i < urls.length; i++) {
		const url = urls[i]?.trim();
		if (!url) continue;

		await db.query(`
      INSERT INTO item_gallery (item_id, image_url, alt, is_main, is_tall, figcaption)
      VALUES ($1, $2, $3, $4, $5, $6)
    `, [
			itemId,
			url,
			sanitizeText(alts[i] || "Item Image"),
			i === 0,
			talls[i] === "true",
			sanitizeText(captions[i] || "")
		]);
	}
};

// Item Ownership
const getOwnersForItem = async (itemId) => {
	const { rows } = await db.query(`
    SELECT *
    FROM item_owners
    WHERE item_id = $1
  `, [itemId]);

	return rows[0] || null;
};

const replaceOwnersForItem = async (itemId, data) => {
	await db.query(`
    DELETE FROM item_owners
    WHERE item_id = $1
  `, [itemId]);

	await db.query(`
    INSERT INTO item_owners (item_id, pc_id, companion_id, npc_id, faction_id)
    VALUES ($1, $2, $3, $4, $5)
  `, [
		itemId,
		data.pc_id || null,
		data.companion_id || null,
		data.npc_id || null,
		data.faction_id || null
	]);
};

export {
	getAssetsForCampaign,
	getItemById,
	getGalleryForItem,
	getOwnersForItem,
	createItem,
	updateItem,
	updateItemStatus,
	updateItemIdentified,
	updateItemOwner,
	updateItemBoonsVisible,
	deleteItem,
	replaceGalleryForItem,
	replaceOwnersForItem
};