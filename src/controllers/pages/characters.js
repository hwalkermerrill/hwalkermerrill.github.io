// Imports
import { getPCs, getCompanions, getNPCs, getFactions } from "../../models/pages/characters.js";

// Controller Function
const charactersPage = async (req, res) => {
  const campaignId = res.locals.campaign_id;

  try {
    // Load data from model
    const pcs = (await getPCs({ campaignId })).map(normalizePC);
    const companions = (await getCompanions({ campaignId })).map(normalizeCompanion);
    const npcs = (await getNPCs({ campaignId })).map(normalizeNPC);
    const factions = (await getFactions({ campaignId })).map(normalizeFaction);

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

function computeUnlockedBoons(attitudeId, row) {
  switch (attitudeId) {
    case 1: // Hostile
      return [row.unfriendly_boon, row.hostile_boon].filter(Boolean).join(" ");
    case 2: // Unfriendly
      return row.unfriendly_boon || null;
    case 4: // Friendly
      return row.friendly_boon || null;
    case 5: // Helpful
      return [row.friendly_boon, row.helpful_boon].filter(Boolean).join(" ");
    default:
      return null;
  }
}

// Normalize Functions
function normalizePC(pc) {
  const subtitles = [];

  // TITLE LOGIC (highest title only)
  if (pc.highest_title) {
    const title = pc.highest_title;
    const titleText = title.has_location
      ? `${title.title_name} of ${title.title_location}`
      : title.title_name;

    subtitles.push(titleText);

    // Honorific name
    if (title.use_honorific) {
      pc.name = `${title.title_name} ${pc.name}`;
    }
  }

  // CLASS STRING
  if (pc.class_string) {
    subtitles.push(pc.class_string);
  }

  return {
    ...pc,
    subtitles,
    attitude_class: pc.attitude_name?.toLowerCase() || null,
    unlocked_boons: null,
    boons_visible: false
  };
}

function normalizeCompanion(comp) {
  const subtitles = [];

  // CLASS STRING
  if (comp.class_string) {
    subtitles.push(comp.class_string);
  }

  return {
    ...comp,
    subtitles,
    attitude_class: comp.attitude_name?.toLowerCase() || null,
    unlocked_boons: null,
    boons_visible: false
  };
}

function normalizeNPC(npc) {
  const subtitles = []; // NPCs don't use subtitles except role, if you want

  const unlocked_boons = computeUnlockedBoons(npc.attitude_id, npc);

  return {
    ...npc,
    subtitles,
    attitude_class: npc.attitude_name?.toLowerCase() || null,
    unlocked_boons,
    boons_visible: Boolean(unlocked_boons)
  };
}

function normalizeFaction(faction) {
  const subtitles = [];

  if (faction.faction_type) {
    subtitles.push(faction.faction_type);
  }

  const unlocked_boons = computeUnlockedBoons(faction.attitude_id, faction);

  return {
    ...faction,
    subtitles,
    attitude_class: faction.attitude_name?.toLowerCase() || null,
    unlocked_boons,
    boons_visible: Boolean(unlocked_boons)
  };
}

export { charactersPage };