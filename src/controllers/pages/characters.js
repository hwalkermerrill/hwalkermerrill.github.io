// Imports
import { getPCs, getCompanions, getNPCs, getFactions } from "../../models/pages/characters.js";

// Constants
const ATTITUDE_CLASS_MAP = {
  1: "hostile",
  2: "unfriendly",
  3: "indifferent", //AKA Neutral
  4: "friendly",
  5: "helpful",
  6: "locked"
};

const FALLBACK_IMAGE = {
  image_url: "/images/core/unknown.png",
  alt: "Unknown Character",
  is_main: true,
  is_hover: false,
  hover_visible: false,
  is_tall: false
};

const FACTION_PRIORITY = {
  "major faction": 1,
  // alphabetical middle group = 2 (default)
  "spirit totem": 3
};

// Helper Functions
const mapAttitudeClass = (attitudeId) => ATTITUDE_CLASS_MAP[attitudeId] || "";

function factionSortKey(f) {
  const type = f.faction_type?.toLowerCase() || "";
  return FACTION_PRIORITY[type] || 2; // 2 = alphabetical middle group
}

function extractGalleryImages(gallery) {
  const list = Array.isArray(gallery) ? gallery : [];

  const main_image = list.find(i => i.is_main) || FALLBACK_IMAGE;
  const hover_image = list.find(i => i.is_hover) || null;

  return { main_image, hover_image };
}

function computeClassString(classes = []) {
  if (!classes.length) return null;

  return classes
    .map(c => {
      const name = c.unknown_name || c.class_id;
      const arch = c.archetype_name ? ` (${c.archetype_name})` : "";
      return `${name}${arch} ${c.class_level}`;
    })
    .join(" / ");
}

function computeUnlockedBoons(att) {
  if (!att) return null;

  switch (att.attitude_id) {
    case 1: // Hostile
      return [att.unfriendly_boon, att.hostile_boon].filter(Boolean).join(" ") || null;
    case 2: // Unfriendly
      return att.unfriendly_boon || null;
    case 4: // Friendly
      return att.friendly_boon || null;
    case 5: // Helpful
      return [att.friendly_boon, att.helpful_boon].filter(Boolean).join(" ") || null;
    default:
      return null;
  }
}

function capitalize(str) {
  if (!str) return str;
  return str.charAt(0).toUpperCase() + str.slice(1);
}

function applyTitleLogic(row, baseName) {
  const titles = row.titles || [];
  const subtitles = [];

  if (!titles.length) {
    return { name: baseName, subtitles, highest_title: null };
  }

  // Compute effective sort order
  const ranked = titles.map(t => {
    let effective = t.title_sort_order;

    if (t.adjust_ranking === "Up") {
      effective -= (t.adjust_value || 0);
    } else if (t.adjust_ranking === "Down") {
      effective += (t.adjust_value || 0);
    }

    return { ...t, effective_sort: effective };
  });

  ranked.sort((a, b) => a.effective_sort - b.effective_sort);
  const highest = ranked[0];

  // Apply honorific
  let name = baseName;
  if (highest.use_honorific) {
    name = `${capitalize(highest.title_name)} ${name}`;
  }

  // Determine if subtitle should be added
  const honorificMatchesTitle =
    highest.use_honorific &&
    !highest.has_location &&
    highest.title_name.toLowerCase() === highest.title_name.toLowerCase();

  if (!honorificMatchesTitle) {
    const titleText = highest.has_location
      ? `${capitalize(highest.title_name)} of ${capitalize(highest.title_location)}`
      : highest.title_name;

    subtitles.push(titleText);
  }

  return { name, subtitles, highest_title: highest };
}

function buildSocialProfile(social = {}) {
  const parts = [];

  if (social.associates) parts.push(social.associates);
  if (social.quirks) parts.push(social.quirks);
  if (social.flaws) parts.push(social.flaws);
  if (social.rumors) parts.push(social.rumors);
  if (social.aspirations) parts.push(social.aspirations);
  if (social.anathema) parts.push(social.anathema);
  if (social.phobias) parts.push(social.phobias);

  return parts;
}

// Normalize Functions
function normalizeCharacter(row, type) {
  const baseName = row[`${type}_name`];
  const { name, subtitles, highest_title } = applyTitleLogic(row, baseName);

  const att = row.attitude?.[0] || null;
  const unlocked_boons = computeUnlockedBoons(att);

  const class_string = computeClassString(row.classes || []);
  const { main_image, hover_image } = extractGalleryImages(row.gallery);
  const merchant = Array.isArray(row.merchant) ? row.merchant[0] : row.merchant || null;

  // Build PC-only social profile
  const social_profile =
    type === "pc" ? buildSocialProfile(row.social || {}) : null;

  return {
    ...row,

    // Name & Titles
    name,
    subtitles: [
      ...subtitles,
      ...(class_string ? [class_string] : [])
    ],
    highest_title,
    class_string,
    merchant,

    // Social
    social: row.social || null,
    appearance: row.social?.appearance || null,
    background: row.social?.background || null,
    extra_details: row.social?.extra_details || null,
    hidden_details: row.social?.hidden_details || null,
    reveal_hidden_details: row.social?.reveal_hidden_details || null,
    social_profile,

    // Attitude
    attitude_class: mapAttitudeClass(att?.attitude_id),
    unlocked_boons,
    boons_visible: Boolean(unlocked_boons),

    // Gallery
    main_image,
    hover_image

  };
}


const normalizePC = (pc) => normalizeCharacter(pc, "pc");
const normalizeCompanion = (c) => normalizeCharacter(c, "companion");
const normalizeNPC = (npc) => normalizeCharacter(npc, "npc");
const normalizeFaction = (f) => normalizeCharacter(f, "faction");

// Controller Function
const charactersPage = async (req, res) => {
  const campaignId = res.locals.campaign_id;

  try {
    const pcs = (await getPCs({ campaignId })).map(normalizePC);
    const companions = (await getCompanions({ campaignId })).map(normalizeCompanion);
    const npcs = (await getNPCs({ campaignId })).map(normalizeNPC);
    const factions = (await getFactions({ campaignId })).map(normalizeFaction);

    // Spotlight
    const npcSpotlight = npcs.filter(i => i.pinned);
    const factionSpotlight = factions.filter(i => i.pinned);

    // PCs
    const pcPending = pcs.filter(i => i.active_status_id === 1);
    const pcActive = pcs.filter(i => i.active_status_id === 2 && i.is_identified);
    const pcUnidentified = pcs.filter(i => i.active_status_id === 2 && !i.is_identified);
    const pcRetired = pcs.filter(i => i.active_status_id === 3);
    const pcDead = pcs.filter(i => i.active_status_id === 4);

    // Companions
    const compPending = companions.filter(i => i.active_status_id === 1);
    const compActive = companions.filter(i => i.active_status_id === 2 && i.is_identified);
    const compUnidentified = companions.filter(i => i.active_status_id === 2 && !i.is_identified);
    const compRetired = companions.filter(i => i.active_status_id === 3);
    const compDead = companions.filter(i => i.active_status_id === 4);

    // NPCs
    const npcPending = npcs.filter(i => i.active_status_id === 1 && !i.pinned);
    const npcActive = npcs.filter(i => i.active_status_id === 2 && i.is_identified && !i.pinned);
    const npcUnidentified = npcs.filter(i => i.active_status_id === 2 && !i.is_identified && !i.pinned);
    const npcRetired = npcs.filter(i => i.active_status_id === 3 && !i.pinned);
    const npcDead = npcs.filter(i => i.active_status_id === 4 && !i.pinned);

    // Factions
    const factionPending = factions.filter(i => i.active_status_id === 1 && !i.pinned).sort((a, b) => factionSortKey(a) - factionSortKey(b));
    const factionActive = factions.filter(i => i.active_status_id === 2 && !i.pinned).sort((a, b) => factionSortKey(a) - factionSortKey(b));
    const factionUnidentified = factions.filter(i => i.active_status_id === 2 && !i.is_identified && !i.pinned).sort((a, b) => factionSortKey(a) - factionSortKey(b));
    const factionRetired = factions.filter(i => i.active_status_id === 3 && !i.pinned).sort((a, b) => factionSortKey(a) - factionSortKey(b));
    const factionDead = factions.filter(i => i.active_status_id === 4 && !i.pinned).sort((a, b) => factionSortKey(a) - factionSortKey(b));

    return res.render("pages/characters/characters", {
      title: "The Full Cast of Heroic and Villainous Characters and Factions",

      pcPending,
      pcActive,
      pcUnidentified,
      pcRetired,
      pcDead,

      compPending,
      compActive,
      compUnidentified,
      compRetired,
      compDead,

      npcSpotlight,
      npcPending,
      npcActive,
      npcUnidentified,
      npcRetired,
      npcDead,

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