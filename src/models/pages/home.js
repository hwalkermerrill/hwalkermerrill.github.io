// Imports
import db from "../db.js";

// Model Functions

// Get all tribes (factions with type 'Tribe') for a campaign
const getTribesForCampaign = async (campaignId) => {
  const query = `
     SELECT
      f.id,
      f.faction_name,
      f.description,
      f.faction_type,

      -- Social details (appearance, background, extra_details)
      s.extra_details,

      -- Attitude (relationship)
      a.attitude_id,

      -- Main gallery image
      g.image_url,
      g.alt,
      g.is_tall

    FROM factions f

    LEFT JOIN faction_social s
      ON s.faction_id = f.id

    LEFT JOIN faction_attitude a
      ON a.faction_id = f.id

    LEFT JOIN faction_gallery g
      ON g.faction_id = f.id
     AND g.is_main = TRUE

    WHERE f.campaign_id = $1
      AND f.faction_type = 'Tribe'
      AND f.is_identified = TRUE

    ORDER BY f.faction_name;
  `;

  const { rows } = await db.query(query, [campaignId]);
  return rows.map(t => ({
    ...t,
    extra_list: t.extra_details
      ? t.extra_details.split("<br>").map(s => s.trim()).filter(Boolean)
      : []
  }));
};

// (Optional future expansion)
// const getHeroImageForCampaign = async (campaignId) => { ... }
// const getAnnouncementsForCampaign = async (campaignId) => { ... }

export { getTribesForCampaign };