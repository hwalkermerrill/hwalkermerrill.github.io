// Imports
import db from "../db.js";

// Helpers - JOIN
const SOCIAL_JOIN = (type) => `
  LEFT JOIN ${type}_social soc
    ON soc.${type}_id = character.id
`;

const GALLERY_JOIN = (type) => `
  LEFT JOIN ${type}_gallery g
    ON g.${type}_id = character.id
`;

const TITLES_JOIN = (type) => `
  LEFT JOIN ${type}_titles t
    ON t.${type}_id = character.id
  LEFT JOIN titles ti
    ON ti.id = t.title_id
  LEFT JOIN title_ranks tr
    ON tr.id = ti.rank_id
`;

const CLASSES_JOIN = (type) => `
  LEFT JOIN ${type}_class cls
    ON cls.${type}_id = character.id
  LEFT JOIN ${type}_class_archetype arch
    ON arch.${type}_class_id = cls.id
`;

const ACHIEVEMENTS_JOIN = (type) => `
  LEFT JOIN ${type}_achievements ach
    ON ach.${type}_id = character.id
`;

const SCARS_JOIN = (type) => `
  LEFT JOIN ${type}_scars sc
    ON sc.${type}_id = character.id
`;

const ATTITUDE_JOIN = (type) => `
  LEFT JOIN ${type}_attitude att
    ON att.${type}_id = character.id
`;

const QUESTS_JOIN = (type) => `
  LEFT JOIN ${type}_quests q
    ON q.${type}_id = character.id
`;

const LANGUAGES_JOIN = (type) => `
  LEFT JOIN ${type}_language lang
    ON lang.${type}_id = character.id
`;

const MERCHANT_JOIN = (type) => `
  LEFT JOIN merchants m
    ON m.${type}_id = character.id
  LEFT JOIN merchant_details md
    ON md.merchant_id = m.id
`;

// Helpers - SELECT
const SELECT_GALLERY_AGG = `
  json_agg(
    jsonb_build_object(
      'image_url', g.image_url,
      'alt', g.alt,
      'is_main', g.is_main,
      'is_hover', g.is_hover,
      'hover_visible', g.hover_visible,
      'is_tall', g.is_tall
    )
  ) FILTER (WHERE g.id IS NOT NULL) AS gallery
`;

const SELECT_TITLES_AGG = `
  json_agg(
    jsonb_build_object(
      'title_id', t.title_id,
      'title_name', ti.title_name,
      'title_location', t.title_location,
      'has_location', t.has_location,
      'use_honorific', t.use_honorific,
      'adjust_ranking', t.adjust_ranking,
      'adjust_value', t.adjust_value,
      'title_sort_order', tr.sort_order
    )
  ) FILTER (WHERE t.title_id IS NOT NULL) AS titles
`;

const SELECT_CLASSES_AGG = `
  json_agg(
    jsonb_build_object(
      'class_id', cls.class_id,
      'class_level', cls.class_level,
      'unknown_name', cls.unknown_name,
      'archetype_name', arch.archetype_name
    )
  ) FILTER (WHERE cls.class_id IS NOT NULL) AS classes
`;

const SELECT_SCARS_AGG = `
  json_agg(
    jsonb_build_object(
      'scar_cause', sc.scar_cause,
      'scar_description', sc.scar_description,
      'session_received', sc.session_received
    )
  ) FILTER (WHERE sc.scar_cause IS NOT NULL) AS scars
`;

const SELECT_ACHIEVEMENTS_AGG = `
  json_agg(
    jsonb_build_object(
      'achievement_id', ach.achievement_id,
      'is_killing_blow', ach.is_killing_blow
    )
  ) FILTER (WHERE ach.achievement_id IS NOT NULL) AS achievements
`;

const SELECT_QUESTS_AGG = `
  json_agg(q.quest_id) FILTER (WHERE q.quest_id IS NOT NULL) AS quests
`;

const SELECT_LANGUAGES_AGG = `
  json_agg(lang.language_id) FILTER (WHERE lang.language_id IS NOT NULL) AS languages
`;

const SELECT_ATTITUDE_OBJECT = `
  jsonb_agg(
    jsonb_build_object(
      'attitude_id', att.attitude_id,
      'favored_pc', att.favored_pc,
      'allies', att.allies,
      'allies_visible', att.allies_visible,
      'enemies', att.enemies,
      'enemies_visible', att.enemies_visible,
      'influence_skills', att.influence_skills,
      'skills_visible', att.skills_visible,
      'influence_notes', att.influence_notes,
      'notes_visible', att.notes_visible,
      'progress_made', att.progress_made,
      'progress_threshold', att.progress_threshold,
      'hostile_boon', att.hostile_boon,
      'unfriendly_boon', att.unfriendly_boon,
      'friendly_boon', att.friendly_boon,
      'helpful_boon', att.helpful_boon,
      'notes', att.notes,
      'secrets', att.secrets
    )
  ) FILTER (WHERE att.attitude_id IS NOT NULL) AS attitude
`;

const SELECT_MERCHANT_AGG = `
  jsonb_agg(
    jsonb_build_object(
      'merchant_id', m.id,
      'merchant_type', md.merchant_type,
      'shop_name', md.shop_name,
      'size', md.size,
      'base_value', md.base_value,
      'purchase_limit', md.purchase_limit,
      'minor_items', md.minor_items,
      'moderate_items', md.moderate_items,
      'major_items', md.major_items,
      'spellcasting_limit', md.spellcasting_limit,
      'notes', md.notes,
      'secrets', md.secrets
    )
  ) FILTER (WHERE m.id IS NOT NULL) AS merchant
`;

const SELECT_SOCIAL_OBJECT = (type) => {
  switch (type) {
    case "pc":
      return `
        jsonb_build_object(
          'appearance', soc.appearance,
          'background', soc.background,
          'associates', soc.associates,
          'rumors', soc.rumors,
          'aspirations', soc.aspirations,
          'anathema', soc.anathema,
          'phobias', soc.phobias,
          'quirks', soc.quirks,
          'flaws', soc.flaws,
          'secrets', soc.secrets
        ) AS social
      `;
    case "companion":
      return `
        jsonb_build_object(
          'appearance', soc.appearance,
          'background', soc.background,
          'extra_details', soc.extra_details,
          'secrets', soc.secrets
        ) AS social
      `;
    case "npc":
    case "faction":
      return `
        jsonb_build_object(
          'appearance', soc.appearance,
          'background', soc.background,
          'extra_details', soc.extra_details,
          'hidden_details', soc.hidden_details,
          'reveal_hidden_details', soc.reveal_hidden_details,
          'secrets', soc.secrets
        ) AS social
      `;
  }
};

// Helpers - WHERE
function buildWhereClause({ campaignId, userId, type }) {
  const params = [];
  const conditions = [];

  if (campaignId) {
    params.push(campaignId);
    conditions.push(`character.campaign_id = $${params.length}`);
  }

  if (userId && (type === "pc" || type === "companion")) {
    params.push(userId);
    conditions.push(`character.user_id = $${params.length}`);
  }

  const whereClause = conditions.length
    ? `WHERE ${conditions.join(" AND ")}`
    : "";

  return { whereClause, params };
}

// Helpers - Group By
const SOCIAL_GROUP_BY = (type) => {
  switch (type) {
    case "pc":
      return `
        soc.appearance, soc.background, soc.associates, soc.rumors,
        soc.aspirations, soc.anathema, soc.phobias, soc.quirks,
        soc.flaws, soc.secrets
      `;
    case "companion":
      return `
        soc.appearance, soc.background, soc.extra_details, soc.secrets
      `;
    case "npc":
    case "faction":
      return `
        soc.appearance, soc.background, soc.extra_details,
        soc.hidden_details, soc.reveal_hidden_details, soc.secrets
      `;
  }
};

// Core Query Builder
function buildCharacterQuery({ type, whereClause }) {
  return `
    SELECT
      character.*,

      ${SELECT_SOCIAL_OBJECT(type)},
      ${SELECT_GALLERY_AGG},

      ${type === "pc" || type === "companion" || type === "npc" ? SELECT_TITLES_AGG : "NULL AS titles"},
      ${type === "pc" || type === "companion" ? SELECT_CLASSES_AGG : "NULL AS classes"},
      ${type === "pc" || type === "companion" ? SELECT_SCARS_AGG : "NULL AS scars"},
      ${type === "pc" || type === "companion" ? SELECT_ACHIEVEMENTS_AGG : "NULL AS achievements"},
      ${type === "npc" || type === "faction" ? SELECT_ATTITUDE_OBJECT : "NULL AS attitude"},
      ${type === "npc" || type === "faction" ? SELECT_QUESTS_AGG : "NULL AS quests"},
      ${type === "npc" ? SELECT_LANGUAGES_AGG : "NULL AS languages"},
      ${type === "npc" || type === "faction" ? SELECT_MERCHANT_AGG : "NULL AS merchant"}

    FROM ${type === "faction" ? "factions" : `${type}_main`} character

    ${SOCIAL_JOIN(type)}
    ${GALLERY_JOIN(type)}
    
    ${type === "pc" || type === "companion" || type === "npc" ? TITLES_JOIN(type) : ""}
    ${type === "pc" || type === "companion" ? CLASSES_JOIN(type) : ""}
    ${type === "pc" || type === "companion" ? ACHIEVEMENTS_JOIN(type) : ""}
    ${type === "pc" || type === "companion" ? SCARS_JOIN(type) : ""}
    ${type === "npc" || type === "faction" ? ATTITUDE_JOIN(type) : ""}
    ${type === "npc" || type === "faction" ? QUESTS_JOIN(type) : ""}
    ${type === "npc" ? LANGUAGES_JOIN(type) : ""}
    ${type === "npc" || type === "faction" ? MERCHANT_JOIN(type) : ""}

    ${whereClause}

    GROUP BY
      character.id,
      ${SOCIAL_GROUP_BY(type)}

    ORDER BY character.${type}_name ASC;
  `;
}

// Model Functions
const getPCs = async ({ campaignId = null, userId = null } = {}) => {
  const { whereClause, params } = buildWhereClause({ campaignId, userId, type: "pc" });
  const query = buildCharacterQuery({ type: "pc", whereClause });
  const { rows } = await db.query(query, params);
  return rows;
};

const getCompanions = async ({ campaignId = null, userId = null } = {}) => {
  const { whereClause, params } = buildWhereClause({ campaignId, userId, type: "companion" });
  const query = buildCharacterQuery({ type: "companion", whereClause });
  const { rows } = await db.query(query, params);
  return rows;
};

const getNPCs = async ({ campaignId = null } = {}) => {
  const { whereClause, params } = buildWhereClause({ campaignId, type: "npc" });
  const query = buildCharacterQuery({ type: "npc", whereClause });
  const { rows } = await db.query(query, params);
  return rows;
};

const getFactions = async ({ campaignId = null } = {}) => {
  const { whereClause, params } = buildWhereClause({ campaignId, type: "faction" });
  const query = buildCharacterQuery({ type: "faction", whereClause });
  const { rows } = await db.query(query, params);
  return rows;
};

// Exports
export { getPCs, getCompanions, getNPCs, getFactions };