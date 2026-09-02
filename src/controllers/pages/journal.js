// Imports
import {
	getSessionLogsForCampaign,
	getParagraphsForLogs,
	getGalleryForLogs,
	// getItemsForCampaign,
	// getItemGalleryForItems
} from "../../models/pages/journal.js";
import {
	getNotesForUserCampaign,
	getPublicNotesForCampaign
} from "../../models/forms/notes.js";

// Controller Function
const journalPage = async (req, res, next) => {
	try {
		// Constants on top
		const campaignId = res.locals.campaign_id;
		const user = req.session.user;
		const userId = user ? user.id : null;

		// Load all logs, map them to log ids, and load their linked table data
		let logs = await getSessionLogsForCampaign(campaignId);
		const logIds = logs.map(l => l.id);
		const [paragraphs, gallery] = await Promise.all([
			getParagraphsForLogs(logIds),
			getGalleryForLogs(logIds)
		]);

		// Attach paragraphs + images to each log
		const logsWithContent = logs.map(log => {
			const logParagraphs = paragraphs.filter(p => p.session_log_id === log.id);
			const logImages = gallery.filter(g => g.session_log_id === log.id);
			const mainImage = logImages.find(img => img.is_main) || logImages[0] || null;
			const hoverImage = logImages.find(img => img.is_hover) || null;

			return {
				...log,
				paragraphs: logParagraphs,
				images: logImages,
				mainImage,
				hoverImage
			};
		});

		// Group and sort session summary logs
		const sessionLogs = logsWithContent.filter(l => l.log_type === "session summary");
		const latestLog = sessionLogs[0] || null;

		// Group logs by book_number for listing
		const logsByBook = {};
		logsWithContent.forEach(log => {
			const key = `book${log.book_number || 0}`;
			if (!logsByBook[key]) logsByBook[key] = [];
			logsByBook[key].push(log);
		});

		// Group and sort all other logs
		const definedTypes = ["documents", "dreams", "lore", "npc spotlight"];

		const logsByType = {
			documents: logsWithContent.filter(l => l.log_type === "documents"),
			dreams: logsWithContent.filter(l => l.log_type === "dreams"),
			lore: logsWithContent.filter(l => l.log_type === "lore"),
			npcSpotlight: logsWithContent.filter(l => l.log_type === "npc spotlight"),

			// "other" = anything NOT in definedTypes AND NOT session summary or location spotlight
			other: logsWithContent.filter(l =>
				!definedTypes.includes(l.log_type) &&
				l.log_type !== "session summary" &&
				l.log_type !== "location spotlight"
			)
		};

		// Get Notes
		let publicNotes = await getPublicNotesForCampaign(campaignId);
		let userNotes = [];
		if (userId) { userNotes = await getNotesForUserCampaign(userId, campaignId); }

		// Controller note sorting before view display
		publicNotes.sort((a, b) => a.category_name.localeCompare(b.category_name));
		userNotes.sort((a, b) => a.category_name.localeCompare(b.category_name));

		// Legacy load via items list, method preserved during data migration
		// Load items (notes, dreams, logs, etc.)
		// const items = await getItemsForCampaign(campaignId);
		// const itemIds = items.map(i => i.id);
		// const itemGallery = await getItemGalleryForItems(itemIds);

		// Attach images to items
		// const itemsWithImages = items.map(item => {
		// 	const images = itemGallery.filter(img => img.item_id === item.id);
		// 	const mainImage = images.find(img => img.is_main) || images[0] || null;

		// 	return {
		// 		...item,
		// 		images,
		// 		mainImage
		// 	};
		// });

		res.render("pages/journal/journal", {
			title: "Travel Log",
			activePage: "journal",
			latestLog,
			logsByBook,
			logsByType,
			// items: itemsWithImages,
			publicNotes,
			userNotes,
			campaignId: campaignId,
			isLoggedIn: Boolean(user)
		});
	} catch (err) {
		next(err); //Defined in global errorHandler.js
	}
}

export { journalPage };
