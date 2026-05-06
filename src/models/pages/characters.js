// Imports
import db from "../../db.js";

/**
 * Get all PCs for a campaign OR for a specific user.
 * 
 * @param {Object} filters
 * @param {number|null} filters.campaignId - Filter by campaign
 * @param {number|null} filters.userId - Filter by owner
 * 
 * If both are provided → AND filter.
 * If neither is provided → return ALL PCs (GM tools).
 */
const getPCs = async ({ campaignId = null, userId = null } = {}) => {
	// Create constants
	const params = [];
	const conditions = [];

	// Filter by campaign
	if (campaignId) {
		params.push(campaignId);
		conditions.push(`pc.campaign_id = $${params.length}`);
	}

	// Filter by owner
	if (userId) {
		params.push(userId);
		conditions.push(`pc.user_id = $${params.length}`);
	}

	// WHERE clause (optional)
	const whereClause = conditions.length > 0
		? `WHERE ${conditions.join(" AND ")}`
		: "";

	const query = `
    SELECT
      pc.id,
      pc.user_id,
      pc.campaign_id,
      pc.active_status_id,
      pc.race_id,
      pc.pc_name,
      pc.unknown_name,
      pc.is_identified,
      pc.secret_name,
      pc.show_secret_name,
      pc.secret_color,
      pc.is_gendered,
      pc.is_female,
      pc.description,
      pc.race_traits,
      pc.retired_reason,
      pc.death_cause,
      pc.end_session,
      pc.created_at,

      -- Social biography
      soc.appearance AS social_appearance,
      soc.background AS social_background,
      soc.associates AS social_associates,
      soc.rumors AS social_rumors,
      soc.aspirations AS social_aspirations,
      soc.anathema AS social_anathema,
      soc.phobias AS social_phobias,
      soc.quirks AS social_quirks,
      soc.flaws AS social_flaws,
      soc.secrets AS social_secrets,

      -- Main gallery image
      gal_main.image_url AS main_image_url,
      gal_main.alt AS main_image_alt,
      gal_main.is_tall AS main_image_tall,

      -- Hover image (optional)
      gal_hover.image_url AS hover_image_url,
      gal_hover.alt AS hover_image_alt,
      gal_hover.is_tall AS hover_image_tall,

      -- Religion (optional)
      rel.religion_id,
      rel.notes AS religion_notes,
      rel.secrets AS religion_secrets,

      -- Titles (optional)
      t.title_id,
      t.title_location,
      t.adjust_ranking,
      t.adjust_value,
      t.has_location,
      t.use_honorific,
      t.received_session,

      -- Class + archetypes
      cls.class_id,
      cls.class_level,
      cls.unknown_name AS class_unknown_name,
      arch.archetype_name,

      -- Achievements (optional)
      ach.achievement_id,
      ach.is_killing_blow,

      -- Scars (optional)
      sc.scar_cause,
      sc.scar_description,
      sc.session_received

    FROM pc_main pc

    -- Social biography
    LEFT JOIN pc_social soc
      ON soc.pc_id = pc.id

    -- Main gallery image
    LEFT JOIN pc_gallery gal_main
      ON gal_main.pc_id = pc.id
      AND gal_main.is_main = TRUE

    -- Hover image
    LEFT JOIN pc_gallery gal_hover
      ON gal_hover.pc_id = pc.id
      AND gal_hover.is_hover = TRUE
      AND gal_hover.hover_visible = TRUE

    -- Religion
    LEFT JOIN pc_religion rel
      ON rel.pc_id = pc.id

    -- Titles
    LEFT JOIN pc_titles t
      ON t.pc_id = pc.id

    -- Classes
    LEFT JOIN pc_class cls
      ON cls.pc_id = pc.id

    -- Archetypes
    LEFT JOIN pc_class_archetype arch
      ON arch.pc_class_id = cls.id

    -- Achievements
    LEFT JOIN pc_achievements ach
      ON ach.pc_id = pc.id

    -- Scars
    LEFT JOIN pc_scars sc
      ON sc.pc_id = pc.id

    ${whereClause}

    ORDER BY pc.pc_name ASC;
  `;

	const { rows } = await db.query(query, params);
	return rows;
}

const getCompanions = async ({ campaignId = null, userId = null } = {}) => {
	// Create constants
	const params = [];
	const conditions = [];

	// Filter by campaign
	if (campaignId) {
		params.push(campaignId);
		conditions.push(`c.campaign_id = $${params.length}`);
	}

	// Filter by owner
	if (userId) {
		params.push(userId);
		conditions.push(`c.user_id = $${params.length}`);
	}

	// WHERE clause (optional)
	const whereClause = conditions.length > 0
		? `WHERE ${conditions.join(" AND ")}`
		: "";

	const query = `
    SELECT
      c.id,
      c.user_id,
      c.pc_id,
      c.campaign_id,
      c.active_status_id,
      c.race_id,
      c.companion_name,
      c.secret_name,
      c.show_secret_name,
      c.secret_color,
      c.is_gendered,
      c.is_female,
      c.description,
      c.race_traits,
      c.death_cause,
      c.end_session,
      c.created_at,

      -- Social biography
      soc.appearance AS social_appearance,
      soc.background AS social_background,
      soc.extra_details AS social_extra_details,
      soc.secrets AS social_secrets,

      -- Main gallery image
      gal_main.image_url AS main_image_url,
      gal_main.alt AS main_image_alt,
      gal_main.is_tall AS main_image_tall,

      -- Hover image (optional)
      gal_hover.image_url AS hover_image_url,
      gal_hover.alt AS hover_image_alt,
      gal_hover.is_tall AS hover_image_tall,

      -- Religion (optional)
      rel.religion_id,
      rel.notes AS religion_notes,
      rel.secrets AS religion_secrets,

      -- Titles (optional)
      t.title_id,
      t.title_location,
      t.adjust_ranking,
      t.adjust_value,
      t.has_location,
      t.use_honorific,
      t.received_session,

      -- Class + archetypes
      cls.class_id,
      cls.class_level,
      cls.unknown_name AS class_unknown_name,
      arch.archetype_name,

      -- Achievements (optional)
      ach.achievement_id,
      ach.is_killing_blow,

      -- Scars (optional)
      sc.scar_cause,
      sc.scar_description,
      sc.session_received

    FROM companion_main c

    -- Social biography
    LEFT JOIN companion_social soc
      ON soc.companion_id = c.id

    -- Main gallery image
    LEFT JOIN companion_gallery gal_main
      ON gal_main.companion_id = c.id
      AND gal_main.is_main = TRUE

    -- Hover image
    LEFT JOIN companion_gallery gal_hover
      ON gal_hover.companion_id = c.id
      AND gal_hover.is_hover = TRUE
      AND gal_hover.hover_visible = TRUE

    -- Religion
    LEFT JOIN companion_religion rel
      ON rel.companion_id = c.id

    -- Titles
    LEFT JOIN companion_titles t
      ON t.companion_id = c.id

    -- Classes
    LEFT JOIN companion_class cls
      ON cls.companion_id = c.id

    -- Archetypes
    LEFT JOIN companion_class_archetype arch
      ON arch.companion_class_id = cls.id

    -- Achievements
    LEFT JOIN companion_achievements ach
      ON ach.companion_id = c.id

    -- Scars
    LEFT JOIN companion_scars sc
      ON sc.companion_id = c.id

    ${whereClause}

    ORDER BY c.companion_name ASC;
  `;

	const { rows } = await db.query(query, params);
	return rows;
};

/**
 * Get all NPCs for a campaign.
 *
 * @param {Object} filters
 * @param {number|null} filters.campaignId - Filter by campaign
 *
 * If campaignId is null → return ALL NPCs (GM tools).
 */
const getNPCs = async ({ campaignId = null } = {}) => {
	const params = [];
	const conditions = [];

	// Filter by campaign
	if (campaignId) {
		params.push(campaignId);
		conditions.push(`n.campaign_id = $${params.length}`);
	}

	// WHERE clause (optional)
	const whereClause = conditions.length > 0
		? `WHERE ${conditions.join(" AND ")}`
		: "";

	const query = `
    SELECT
      n.id,
      n.campaign_id,
      n.active_status_id,
      n.race_id,
      n.npc_name,
      n.unknown_name,
      n.is_identified,
      n.secret_name,
      n.show_secret_name,
      n.secret_color,
      n.is_gendered,
      n.is_female,
      n.description,
      n.secrets AS npc_secrets,
      n.pinned,
      n.death_cause,
      n.retired_reason,
      n.start_session,
      n.end_session,
      n.created_at,

      -- Social biography
      soc.appearance AS social_appearance,
      soc.background AS social_background,
      soc.extra_details AS social_extra_details,
      soc.hidden_details AS social_hidden_details,
      soc.reveal_hidden_details AS social_reveal_hidden,
      soc.secrets AS social_secrets,

      -- Main gallery image
      gal_main.image_url AS main_image_url,
      gal_main.alt AS main_image_alt,
      gal_main.is_tall AS main_image_tall,

      -- Hover image (optional)
      gal_hover.image_url AS hover_image_url,
      gal_hover.alt AS hover_image_alt,
      gal_hover.is_tall AS hover_image_tall,

      -- Religion (optional)
      rel.religion_id,
      rel.notes AS religion_notes,
      rel.secrets AS religion_secrets,

      -- Titles (optional)
      t.title_id,
      t.title_location,
      t.adjust_ranking,
      t.adjust_value,
      t.has_location,
      t.use_honorific,
      t.received_session,

      -- Attitude (optional)
      att.attitude_id,
      att.favored_pc,
      att.allies,
      att.allies_visible,
      att.enemies,
      att.enemies_visible,
      att.influence_skills,
      att.skills_visible,
      att.influence_notes,
      att.notes_visible,
      att.progress_made,
      att.progress_threshold,
      att.hostile_boon,
      att.unfriendly_boon,
      att.friendly_boon,
      att.helpful_boon,
      att.notes AS attitude_notes,
      att.secrets AS attitude_secrets,

      -- Quests (optional)
      q.quest_id,

      -- Languages (optional)
      lang.language_id

    FROM npc_main n

    -- Social biography
    LEFT JOIN npc_social soc
      ON soc.npc_id = n.id

    -- Main gallery image
    LEFT JOIN npc_gallery gal_main
      ON gal_main.npc_id = n.id
      AND gal_main.is_main = TRUE

    -- Hover image
    LEFT JOIN npc_gallery gal_hover
      ON gal_hover.npc_id = n.id
      AND gal_hover.is_hover = TRUE
      AND gal_hover.show_hover = TRUE

    -- Religion
    LEFT JOIN npc_religion rel
      ON rel.npc_id = n.id

    -- Titles
    LEFT JOIN npc_titles t
      ON t.npc_id = n.id

    -- Attitude
    LEFT JOIN npc_attitude att
      ON att.npc_id = n.id

    -- Quests
    LEFT JOIN npc_quests q
      ON q.npc_id = n.id

    -- Languages
    LEFT JOIN npc_language lang
      ON lang.npc_id = n.id

    ${whereClause}

    ORDER BY n.npc_name ASC;
  `;

	const { rows } = await db.query(query, params);
	return rows;
};

/**
 * Get all factions for a campaign.
 *
 * @param {Object} filters
 * @param {number|null} filters.campaignId - Filter by campaign
 *
 * If campaignId is null → return ALL factions (GM tools).
 */
const getFactions = async ({ campaignId = null } = {}) => {
	const params = [];
	const conditions = [];

	// Filter by campaign
	if (campaignId) {
		params.push(campaignId);
		conditions.push(`f.campaign_id = $${params.length}`);
	}

	// WHERE clause (optional)
	const whereClause = conditions.length > 0
		? `WHERE ${conditions.join(" AND ")}`
		: "";

	const query = `
    SELECT
      f.id,
      f.campaign_id,
      f.active_status_id,
      f.faction_name,
      f.unknown_name,
      f.is_identified,
      f.secret_name,
      f.show_secret_name,
      f.secret_color,
      f.faction_type,
      f.description,
      f.secrets AS faction_secrets,
      f.pinned,
      f.progress_able,
      f.progress_made,
      f.progress_threshold,
      f.death_cause,
      f.retired_reason,
      f.start_session,
      f.end_session,
      f.created_at,

      -- Social biography
      soc.appearance AS social_appearance,
      soc.background AS social_background,
      soc.extra_details AS social_extra_details,
      soc.hidden_details AS social_hidden_details,
      soc.reveal_hidden_details AS social_reveal_hidden,
      soc.secrets AS social_secrets,

      -- Main gallery image
      gal_main.image_url AS main_image_url,
      gal_main.alt AS main_image_alt,
      gal_main.is_tall AS main_image_tall,

      -- Hover image (optional)
      gal_hover.image_url AS hover_image_url,
      gal_hover.alt AS hover_image_alt,
      gal_hover.is_tall AS hover_image_tall,

      -- Attitude (optional)
      att.attitude_id,
      att.favored_pc,
      att.allies,
      att.allies_visible,
      att.enemies,
      att.enemies_visible,
      att.influence_skills,
      att.skills_visible,
      att.influence_notes,
      att.notes_visible,
      att.progress_made AS attitude_progress_made,
      att.progress_threshold AS attitude_progress_threshold,
      att.hostile_boon,
      att.unfriendly_boon,
      att.neutral_boon,
      att.friendly_boon,
      att.helpful_boon,
      att.notes AS attitude_notes,
      att.secrets AS attitude_secrets,

      -- Quests (optional)
      q.quest_id

    FROM factions f

    -- Social biography
    LEFT JOIN faction_social soc
      ON soc.faction_id = f.id

    -- Main gallery image
    LEFT JOIN faction_gallery gal_main
      ON gal_main.faction_id = f.id
      AND gal_main.is_main = TRUE

    -- Hover image
    LEFT JOIN faction_gallery gal_hover
      ON gal_hover.faction_id = f.id
      AND gal_hover.is_hover = TRUE
      AND gal_hover.hover_visible = TRUE

    -- Attitude
    LEFT JOIN faction_attitude att
      ON att.faction_id = f.id

    -- Quests
    LEFT JOIN faction_quests q
      ON q.faction_id = f.id

    ${whereClause}

    ORDER BY f.faction_name ASC;
  `;

	const { rows } = await db.query(query, params);
	return rows;
};

// Exports
export { getPCs, getCompanions, getNPCs, getFactions };