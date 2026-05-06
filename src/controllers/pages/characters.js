// Imports
import { getPCs, getCompanions, getNPCs, getFactions } from "../../models/pages/characters.js";

// Controller Function
const charactersPage = async (req, res) => {
  const campaignId = res.locals.campaign_id;

  try {
    // Load data from model
    const pcs = await getPCs({ campaignId });
    const companions = await getCompanions({ campaignId });
    const npcs = await getNPCs({ campaignId });
    const factions = await getFactions({ campaignId });

    // === SPOTLIGHT (exclusive) ===
    const npcSpotlight = npcs.filter(i => i.pinned === true);
    const factionSpotlight = factions.filter(i => i.pinned === true);

    // === PCs ===
    const pcPending = pcs.filter(i => i.active_status_id === 1);
    const pcActive = pcs.filter(i => i.active_status_id === 2 && i.is_identified === true);
    const pcUnidentified = pcs.filter(i => i.active_status_id === 2 && i.is_identified === false);
    const pcRetired = pcs.filter(i => i.active_status_id === 3);
    const pcDead = pcs.filter(i => i.active_status_id === 4);

    // === Companions ===
    const compPending = companions.filter(i => i.active_status_id === 1);
    const compActive = companions.filter(i => i.active_status_id === 2 && i.is_identified === true);
    const compUnidentified = companions.filter(i => i.active_status_id === 2 && i.is_identified === false);
    const compRetired = companions.filter(i => i.active_status_id === 3);
    const compDead = companions.filter(i => i.active_status_id === 4);

    // === NPCs (spotlight removed) ===
    const npcPending = npcs.filter(i => i.active_status_id === 1 && !i.pinned);
    const npcActive = npcs.filter(i => i.active_status_id === 2 && i.is_identified === true && !i.pinned);
    const npcUnidentified = npcs.filter(i => i.active_status_id === 2 && i.is_identified === false && !i.pinned);
    const npcRetired = npcs.filter(i => i.active_status_id === 3 && !i.pinned);
    const npcDead = npcs.filter(i => i.active_status_id === 4 && !i.pinned);

    // === Factions (spotlight removed) ===
    const factionPending = factions.filter(i => i.active_status_id === 1 && !i.pinned);
    const factionActive = factions.filter(i => i.active_status_id === 2 && !i.pinned);
    const factionUnidentified = factions.filter(i => i.active_status_id === 2 && i.is_identified === false && !i.pinned);
    const factionRetired = factions.filter(i => i.active_status_id === 3 && !i.pinned);
    const factionDead = factions.filter(i => i.active_status_id === 4 && !i.pinned);

    //Render page data
    return res.render("pages/characters/characters", {
      title: "The Full Cast of Heroic and Villainous Characters and Factions",

      // PCs
      pcPending,
      pcActive,
      pcUnidentified,
      pcRetired,
      pcDead,

      // Companions
      compPending,
      compActive,
      compUnidentified,
      compRetired,
      compDead,

      // NPCs
      npcSpotlight,
      npcPending,
      npcActive,
      npcUnidentified,
      npcRetired,
      npcDead,

      // Factions
      factionSpotlight,
      factionPending,
      factionActive,
      factionUnidentified,
      factionRetired,
      factionDead
    });

  } catch (error) {
    console.error("Error rendering characters page:", error);
    req.flash("error", "Unable to load characters at this time.");
    return res.redirect("/");
  }
};

export { charactersPage };