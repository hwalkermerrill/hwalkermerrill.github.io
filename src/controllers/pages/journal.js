// Imports
import { getSessionLogsForCampaign, getParagraphsForLogs, getGalleryForLogs, getNotesForUserCampaign, getItemsForCampaign, getItemGalleryForItems } from "../../models/pages/journal.js";

// Controller Function
const journalPage = async (req, res) => {
  try {
    const campaignId = req.session.campaign_id;
    const userId = req.session.user_id || null;

    let logs = await getSessionLogsForCampaign(campaignId);
    logs = logs.filter(l => l.log_type === "session summary");
    const logIds = logs.map(l => l.id);

    const [paragraphs, gallery, notes] = await Promise.all([
      getParagraphsForLogs(logIds),
      getGalleryForLogs(logIds),
      getNotesForUserCampaign(userId, campaignId)
    ]);

    // Attach paragraphs + main image to each log
    const logsWithContent = logs.map(log => {
      const logParagraphs = paragraphs.filter(p => p.session_log_id === log.id);
      const logImages = gallery.filter(g => g.session_log_id === log.id);
      const mainImage = logImages.find(img => img.is_main) || logImages[0] || null;

      return {
        ...log,
        paragraphs: logParagraphs,
        images: logImages,
        mainImage
      };
    });

    // Most recent recap (first in sorted list)
    const latestLog = logsWithContent[0] || null;

    // Group logs by book_number for listing
    const logsByBook = {};
    logsWithContent.forEach(log => {
      const key = `book${log.book_number || 0}`;
      if (!logsByBook[key]) logsByBook[key] = [];
      logsByBook[key].push(log);
    });

    // Load items (notes, dreams, logs, etc.)
    const items = await getItemsForCampaign(campaignId);
    const itemIds = items.map(i => i.id);

    // Load item images
    const itemGallery = await getItemGalleryForItems(itemIds);

    // Attach images to items
    const itemsWithImages = items.map(item => {
      const images = itemGallery.filter(img => img.item_id === item.id);
      const mainImage = images.find(img => img.is_main) || images[0] || null;

      return {
        ...item,
        images,
        mainImage
      };
    });

    res.render("journal/journal", {
      title: "Travel Log",
      activePage: "journal",
      isLoggedIn: res.locals.isLoggedIn,
      user: req.session.user,
      campaign_id: req.session.campaign_id,
      latestLog,
      logsByBook,
      notes,
      items: itemsWithImages
    });
  } catch (err) {
    next(err); //Defined in global errorHandler.js
  }
}

export { journalPage };
