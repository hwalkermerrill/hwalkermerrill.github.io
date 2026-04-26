// Imports
import { getLocationsForCampaign } from "../../models/pages/maps.js";
import { getTribesForCampaign, getLatestSessionRecap } from "../../models/pages/home.js";

const homePage = async (req, res) => {
  const campaignId = res.locals.campaign_id;

  try {
    // Load imports for all home page sections
    const spotlights = await getLocationsForCampaign(campaignId);
    const tribes = await getTribesForCampaign(campaignId);
    const latestRecap = await getLatestSessionRecap(campaignId);

    let currentLocation = null;
    let overviewLocation = null;

    if (spotlights.length > 0) {
      overviewLocation = spotlights[0];                       // first spotlight
      currentLocation = spotlights[spotlights.length - 1];    // newest spotlight
    }

    return res.render("home/home", {
      title: "Welcome Home",
      currentLocation,
      overviewLocation,
      tribes,
      latestRecap
    });

  } catch (error) {
    console.error("Error rendering home page:", error);
    req.flash("error", "Unable to load home page at this time.");
    return res.redirect("/");
  }
};

export { homePage };