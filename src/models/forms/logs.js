// Imports
import db from "../db.js";

// Main Model Functions
async function getLogById(logId) {
	const { rows } = await db.query(
		`
    SELECT *
    FROM session_logs
    WHERE id = $1
    `,
		[logId]
	);
	return rows[0] || null;
}

async function createLog({
	campaignId,
	logType,
	bookNumber,
	sessionNumber,
	title,
	timeSpan,
	sessionDate,
	pinned
}) {
	const { rows } = await db.query(
		`
    INSERT INTO session_logs
      (campaign_id, log_type, book_number, session_number,
       title, time_span, session_date, pinned)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
    RETURNING id
    `,
		[
			campaignId,
			logType,
			bookNumber,
			sessionNumber,
			title,
			timeSpan,
			sessionDate,
			pinned
		]
	);

	return rows[0].id;
}

async function updateLog(
	logId,
	{
		campaignId,
		logType,
		bookNumber,
		sessionNumber,
		title,
		timeSpan,
		sessionDate,
		pinned
	}
) {
	await db.query(
		`
    UPDATE session_logs
    SET campaign_id = $1,
        log_type = $2,
        book_number = $3,
        session_number = $4,
        title = $5,
        time_span = $6,
        session_date = $7,
        pinned = $8
    WHERE id = $9
    `,
		[
			campaignId,
			logType,
			bookNumber,
			sessionNumber,
			title,
			timeSpan,
			sessionDate,
			pinned,
			logId
		]
	);
}

// Delete Model Functions
async function deleteLog(logId) {
	await db.query(
		`
    DELETE FROM session_logs
    WHERE id = $1
    `,
		[logId]
	);
}

async function deleteParagraphsForLog(logId) {
	await db.query(
		`
    DELETE FROM session_log_paragraphs
    WHERE session_log_id = $1
    `,
		[logId]
	);
}

async function deleteGalleryForLog(logId) {
	await db.query(
		`
    DELETE FROM session_log_gallery
    WHERE session_log_id = $1
    `,
		[logId]
	);
}

// Single Insert/ Edit Model Functions
async function insertParagraph(logId, order, text, userId) {
	await db.query(
		`
    INSERT INTO session_log_paragraphs
      (session_log_id, user_id, paragraph_order, paragraph_text)
    VALUES ($1, $2, $3, $4)
    `,
		[logId, userId, order, text]
	);
}

async function insertGalleryImage(logId, { imageUrl, alt, isMain, isHover, hoverVisible, isTall }) {
	await db.query(
		`
    INSERT INTO session_log_gallery
      (session_log_id, image_url, alt, is_main, is_Hover, hover_Visible, is_Tall)
    VALUES ($1, $2, $3, $4, $5, $6, $7,)
    `,
		[logId, imageUrl, alt, isMain, isHover, hoverVisible, isTall]
	);
}

// Exports
export {
	getLogById,
	createLog,
	updateLog,
	deleteLog,
	deleteParagraphsForLog,
	insertParagraph,
	deleteGalleryForLog,
	insertGalleryImage
};
