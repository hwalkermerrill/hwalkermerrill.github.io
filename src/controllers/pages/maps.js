// Imports
import { getMapsForCampaign, getLocationsForCampaign } from "../../models/pages/maps.js";

// Controller Function

const mapPage = async (req, res) => {
  const campaignId = res.locals.campaign_id;

  try {
    const maps = await getMapsForCampaign(campaignId);
    const spotlights = await getLocationsForCampaign(campaignId);

    // Main map: pick a specific one or fall back to first
    const mainMap =
      maps.find(m => m.item_name === "Map of Saventh-Yhi") ||
      maps[0] ||
      null;

    const galleryTall = maps.filter(m => m.is_tall);
    const galleryWide = maps.filter(m => !m.is_tall);

    let currentLocation = null;
    let pastLocations = [];

    if (spotlights.length > 0) {
      currentLocation = spotlights[spotlights.length - 1];
      pastLocations = spotlights.slice(0, -1);
    }

    return res.render("maps/maps", {
      title: "Maps of the Mwangi Expanse",
      mainMap,
      galleryTall,
      galleryWide,
      currentLocation,
      pastLocations
    });
  } catch (error) {
    console.error("Error rendering maps page:", error);
    req.flash("error", "Unable to load maps at this time.");
    return res.redirect("/");
  }
};

export { mapPage };