// Imports
import { getSessionLogsForCampaign, getParagraphsForLogs, getGalleryForLogs, getNotesForUserCampaign } from "../../models/journal/journal.js";

const journalPage = async (req, res) => {
  try {
    const campaignId = req.session.campaign_id; // adjust to your setup
    const userId = req.session.user_id || null;

    const logs = await getSessionLogsForCampaign(campaignId);
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

    res.render("journal/journal", {
      title: "Travel Log",
      activePage: "journal",
      isLoggedIn: !!userId,
      latestLog,
      logsByBook,
      notes
    });
  } catch (err) {
    next(err); //es-lint-disable-line no-undef
  }
}

export { journalPage };
