// Imports
import { getLocationsForCampaign } from "../../models/pages/maps.js";
// Later: import { getTribesForCampaign } from "../../models/pages/home.js";

const homePage = async (req, res) => {
  const campaignId = res.locals.campaign_id;

  try {
    // Load location spotlights (same model used by maps)
    const spotlights = await getLocationsForCampaign(campaignId);

    let currentLocation = null;
    let overviewLocation = null;

    if (spotlights.length > 0) {
      overviewLocation = spotlights[0];                       // first spotlight
      currentLocation = spotlights[spotlights.length - 1];    // newest spotlight
    }

    // Placeholder for tribes until dynamic model is built
    const tribes = []; // will be replaced with DB data later

    return res.render("home/home", {
      title: "Welcome Home",
      currentLocation,
      overviewLocation,
      tribes
    });

  } catch (error) {
    console.error("Error rendering home page:", error);
    req.flash("error", "Unable to load home page at this time.");
    return res.redirect("/");
  }
};

export { homePage };