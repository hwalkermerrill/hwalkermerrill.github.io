// Imports
import { getAssetsForCampaign } from "../../models/pages/assets.js";

// Controller Function
const assetsPage = async (req, res) => {
  const campaignId = res.locals.campaign_id;

  try {
    const assets = await getAssetsForCampaign(campaignId);

    //Set status groups
    const pending = assets.filter(i => i.active_status_id === 1);
    const active = assets.filter(i => i.active_status_id === 2 && i.is_identified === true);
    const unidentified = assets.filter(i => i.active_status_id === 2 && i.is_identified === false);
    const lost = assets.filter(i => i.active_status_id >= 3);

    // Group assets by type
    const artifact = active.filter(i => i.item_type === "artifact");
    const relic = active.filter(i => i.item_type === "relic");
    const major = active.filter(i => i.item_type === "major");
    const minor = active.filter(i => i.item_type === "minor");
    const special = active.filter(i => i.item_type === "special");
    const favor = active.filter(i => i.item_type === "favor");

    return res.render("pages/assets/assets", {
      title: "Assets, Artifacts, Relics, Magical Items, Resources, and Favors",
      artifact,
      relic,
      major,
      minor,
      special,
      favor,
      unidentified,
      pending,
      lost
    });

  } catch (error) {
    console.error("Error rendering assets page:", error);
    req.flash("error", "Unable to load assets at this time.");
    return res.redirect("/");
  }
};

export { assetsPage };
