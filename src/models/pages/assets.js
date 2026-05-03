// Imports
import db from "../db.js";

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

export { getAssetsForCampaign };