// Imports
import db from "../db.js";

// Model Functions
async function getSessionLogsForCampaign(campaignId) {
  const { rows } = await db.query(
    `
    SELECT *
    FROM session_logs
    WHERE campaign_id = $1
      AND log_type = 'session summary'
    ORDER BY book_number DESC, session_number DESC, id ASC
    `,
    [campaignId]
  );
  return rows;
}

async function getParagraphsForLogs(logIds) {
  if (logIds.length === 0) return [];
  const { rows } = await db.query(
    `
    SELECT *
    FROM session_log_paragraphs
    WHERE session_log_id = ANY($1::int[])
    ORDER BY session_log_id ASC, paragraph_order ASC
    `,
    [logIds]
  );
  return rows;
}

async function getGalleryForLogs(logIds) {
  if (logIds.length === 0) return [];
  const { rows } = await db.query(
    `
    SELECT *
    FROM session_log_gallery
    WHERE session_log_id = ANY($1::int[])
    ORDER BY is_main DESC, id ASC
    `,
    [logIds]
  );
  return rows;
}

async function getNotesForUserCampaign(userId, campaignId) {
  if (!userId || !campaignId) return [];
  const { rows } = await db.query(
    `
    SELECT *
    FROM campaign_notes
    WHERE user_id = $1
      AND campaign_id = $1
    ORDER BY created_at DESC
    `,
    [userId, campaignId]
  );
  return rows;
}

export { getSessionLogsForCampaign, getParagraphsForLogs, getGalleryForLogs, getNotesForUserCampaign };