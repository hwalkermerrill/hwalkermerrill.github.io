// Imports
import { getMapsForCampaign, getLocationsForCampaign, getCampaignMainMapId, setCampaignMainMap } from "../../models/pages/maps.js";

// Controller Function
const mapPage = async (req, res) => {
  const campaignId = res.locals.campaign_id;

  try {
    const maps = await getMapsForCampaign(campaignId);
    const spotlights = await getLocationsForCampaign(campaignId);
    const mainMapId = await getCampaignMainMapId(campaignId);
    const galleryTall = maps.filter(m => m.is_tall);
    const galleryWide = maps.filter(m => !m.is_tall);

    // Main map fallback logic
    const mainMap =
      maps.find(m => m.id === mainMapId) ||
      maps[0] ||
      null;

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
      pastLocations,
      mainMapId
    });
  } catch (error) {
    console.error("Error rendering maps page:", error);
    req.flash("error", "Unable to load maps at this time.");
    return res.redirect("/");
  }
};

// Post set main map (manage_maps permission required)
const setMainMap = async (req, res, next) => {
  try {
    const campaignId = res.locals.campaign_id;
    const mapId = Number(req.params.id);

    // Verify the map belongs to this campaign
    const maps = await getMapsForCampaign(campaignId);
    const map = maps.find(m => m.id === mapId);

    if (!map) {
      return next({ status: 404, message: "Map not found" });
    }

    await setCampaignMainMap(campaignId, mapId);

    req.flash("success", `${map.item_name} is now the main map.`);
    res.redirect("/maps");
  } catch (err) {
    next(err);
  }
};

export { mapPage, setMainMap };