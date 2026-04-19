// Imports
import db from "../db.js";

// Model Functions
// Get all maps (items + main gallery image) for a campaign
const getMapsForCampaign = async (campaignId) => {
  const query = `
    SELECT
      i.id,
      i.item_name,
      i.item_subtype,
      g.image_url,
      g.alt,
      g.is_tall
    FROM items i
    JOIN item_gallery g
      ON g.item_id = i.id
     AND g.is_main = TRUE
    WHERE i.campaign_id = $1
      AND i.item_type = 'map'
    ORDER BY i.sort_order NULLS LAST, i.item_name;
  `;
  const { rows } = await db.query(query, [campaignId]);
  return rows;
};

// Get the main map ID for a campaign (if set)
const getCampaignMainMapId = async (campaignId) => {
  const query = `
    SELECT main_map_id
    FROM campaigns
    WHERE id = $1
  `;
  const { rows } = await db.query(query, [campaignId]);
  return rows[0]?.main_map_id || null;
};

// Set the main map for a campaign (manage_maps permission required)
const setCampaignMainMap = async (campaignId, mapId) => {
  const query = `
    UPDATE campaigns
    SET main_map_id = $1
    WHERE id = $2
  `;
  await db.query(query, [mapId, campaignId]);
};

// Get all location spotlights for a campaign
const getLocationsForCampaign = async (campaignId) => {
  const logsQuery = `
    SELECT id, session_number, title
    FROM session_logs
    WHERE campaign_id = $1
      AND log_type = 'location spotlight'
    ORDER BY session_number;
  `;
  const { rows: logs } = await db.query(logsQuery, [campaignId]);
  if (!logs.length) return [];

  const spotlightIds = logs.map(l => l.id);

  const galleryQuery = `
    SELECT session_log_id, image_url, alt, is_tall
    FROM session_log_gallery
    WHERE session_log_id = ANY($1::int[])
    ORDER BY session_log_id, is_main DESC;
  `;
  const { rows: galleryRows } = await db.query(galleryQuery, [spotlightIds]);

  const paragraphsQuery = `
    SELECT session_log_id, paragraph_order, paragraph_text
    FROM session_log_paragraphs
    WHERE session_log_id = ANY($1::int[])
    ORDER BY session_log_id, paragraph_order;
  `;
  const { rows: paragraphRows } = await db.query(paragraphsQuery, [spotlightIds]);

  // Assemble location spotlights by attaching gallery + paragraphs to each log
  return logs.map(log => {
    const gallery = galleryRows.find(g => g.session_log_id === log.id) || null;
    const paragraphs = paragraphRows
      .filter(p => p.session_log_id === log.id)
      .sort((a, b) => a.paragraph_order - b.paragraph_order)
      .map(p => p.paragraph_text);

    return {
      id: log.id,
      session_number: log.session_number,
      title: log.title,
      image_url: gallery ? gallery.image_url : null,
      alt: gallery ? gallery.alt : log.title,
      is_tall: gallery ? gallery.is_tall : false,
      paragraphs
    };
  });
};

export { getMapsForCampaign, getLocationsForCampaign, getCampaignMainMapId, setCampaignMainMap };