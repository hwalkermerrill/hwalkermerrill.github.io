// Imports
import db from "../../db.js";

// Get full detail data for a single PC.
const getPCDetails = async (pcId) => {
  const params = [pcId];

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

      -- Gallery (multiple rows)
      gal.id AS gallery_id,
      gal.image_url AS gallery_image_url,
      gal.alt AS gallery_alt,
      gal.is_imported AS gallery_imported,
      gal.is_main AS gallery_is_main,
      gal.is_hover AS gallery_is_hover,
      gal.hover_visible AS gallery_hover_visible,
      gal.is_tall AS gallery_is_tall,

      -- Classes (multiple rows)
      cls.id AS class_entry_id,
      cls.class_id,
      cls.class_level,
      cls.unknown_name AS class_unknown_name,
      arch.archetype_name,

      -- Religion (multiple rows)
      rel.id AS religion_entry_id,
      rel.religion_id,
      rel.notes AS religion_notes,
      rel.secrets AS religion_secrets,

      -- Titles (multiple rows)
      t.id AS title_entry_id,
      t.title_id,
      t.title_location,
      t.adjust_ranking,
      t.adjust_value,
      t.has_location,
      t.use_honorific,
      t.received_session,

      -- Achievements (multiple rows)
      ach.id AS achievement_entry_id,
      ach.achievement_id,
      ach.is_killing_blow,

      -- Scars (multiple rows)
      sc.id AS scar_entry_id,
      sc.scar_cause,
      sc.scar_description,
      sc.session_received,

      -- Attributes (one row)
      attr.alignment,
      attr.strength,
      attr.dexterity,
      attr.constitution,
      attr.intelligence,
      attr.wisdom,
      attr.charisma,
      attr.notes AS attribute_notes,

      -- Stats (one row)
      stats.main_ac,
      stats.flat_ac,
      stats.touch_ac,
      stats.cmd,
      stats.max_hp,
      stats.notes AS stats_notes,

      -- Skills (one row)
      skl.initiative,
      skl.perception,
      skl.sense_motive,
      skl.disguise,
      skl.stealth,
      skl.disable_device,
      skl.reflex,
      skl.fortitude,
      skl.will,
      skl.rerolls,
      skl.notes AS skills_notes,

      -- Languages (multiple rows)
      lang.language_id,

      -- Speed (multiple rows)
      sp.speed_id,
      sp.speed_value,

      -- Faction memberships (multiple rows)
      fp.faction_id,
      fp.association_type AS faction_association_type,
      fp.association_rank AS faction_association_rank,

      -- Linked companions (multiple rows)
      comp.id AS companion_id,
      comp.companion_name AS companion_name,
      comp.is_identified AS companion_identified,
      comp.secret_name AS companion_secret_name,
      comp.show_secret_name AS companion_show_secret,
      comp.secret_color AS companion_secret_color

    FROM pc_main pc

    -- Social biography
    LEFT JOIN pc_social soc
      ON soc.pc_id = pc.id

    -- Gallery
    LEFT JOIN pc_gallery gal
      ON gal.pc_id = pc.id

    -- Classes + archetypes
    LEFT JOIN pc_class cls
      ON cls.pc_id = pc.id
    LEFT JOIN pc_class_archetype arch
      ON arch.pc_class_id = cls.id

    -- Religion
    LEFT JOIN pc_religion rel
      ON rel.pc_id = pc.id

    -- Titles
    LEFT JOIN pc_titles t
      ON t.pc_id = pc.id

    -- Achievements
    LEFT JOIN pc_achievements ach
      ON ach.pc_id = pc.id

    -- Scars
    LEFT JOIN pc_scars sc
      ON sc.pc_id = pc.id

    -- Attributes
    LEFT JOIN pc_attributes attr
      ON attr.pc_id = pc.id

    -- Stats
    LEFT JOIN pc_stats stats
      ON stats.pc_id = pc.id

    -- Skills
    LEFT JOIN pc_skills skl
      ON skl.pc_id = pc.id

    -- Languages
    LEFT JOIN pc_language lang
      ON lang.pc_id = pc.id

    -- Speed
    LEFT JOIN pc_speed sp
      ON sp.pc_id = pc.id

    -- Faction memberships
    LEFT JOIN faction_pcs fp
      ON fp.pc_id = pc.id

    -- Linked companions
    LEFT JOIN companion_main comp
      ON comp.pc_id = pc.id

    WHERE pc.id = $1;
  `;

  const { rows } = await db.query(query, params);
  return rows;
};

// Get full detail data for a single Companion.
const getCompanionDetails = async (companionId) => {
  const params = [companionId];

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

      -- Gallery (multiple rows)
      gal.id AS gallery_id,
      gal.image_url AS gallery_image_url,
      gal.alt AS gallery_alt,
      gal.is_imported AS gallery_imported,
      gal.is_main AS gallery_is_main,
      gal.is_hover AS gallery_is_hover,
      gal.hover_visible AS gallery_hover_visible,
      gal.is_tall AS gallery_is_tall,

      -- Classes (multiple rows)
      cls.id AS class_entry_id,
      cls.class_id,
      cls.class_level,
      cls.unknown_name AS class_unknown_name,
      arch.archetype_name,

      -- Religion (multiple rows)
      rel.id AS religion_entry_id,
      rel.religion_id,
      rel.notes AS religion_notes,
      rel.secrets AS religion_secrets,

      -- Titles (multiple rows)
      t.id AS title_entry_id,
      t.title_id,
      t.title_location,
      t.adjust_ranking,
      t.adjust_value,
      t.has_location,
      t.use_honorific,
      t.received_session,

      -- Achievements (multiple rows)
      ach.id AS achievement_entry_id,
      ach.achievement_id,
      ach.is_killing_blow,

      -- Scars (multiple rows)
      sc.id AS scar_entry_id,
      sc.scar_cause,
      sc.scar_description,
      sc.session_received,

      -- Attributes (one row)
      attr.alignment,
      attr.strength,
      attr.dexterity,
      attr.constitution,
      attr.intelligence,
      attr.wisdom,
      attr.charisma,
      attr.notes AS attribute_notes,

      -- Stats (one row)
      stats.main_ac,
      stats.flat_ac,
      stats.touch_ac,
      stats.cmd,
      stats.max_hp,
      stats.notes AS stats_notes,

      -- Skills (one row)
      skl.initiative,
      skl.perception,
      skl.sense_motive,
      skl.disguise,
      skl.stealth,
      skl.disable_device,
      skl.reflex,
      skl.fortitude,
      skl.will,
      skl.rerolls,
      skl.notes AS skills_notes,

      -- Languages (multiple rows)
      lang.language_id,

      -- Speed (multiple rows)
      sp.speed_id,
      sp.speed_value,

      -- Faction memberships (multiple rows)
      fc.faction_id,
      fc.association_type AS faction_association_type,
      fc.association_rank AS faction_association_rank,

      -- Linked PC (owner)
      pc.pc_name AS linked_pc_name,
      pc.is_identified AS linked_pc_identified,
      pc.secret_name AS linked_pc_secret_name,
      pc.show_secret_name AS linked_pc_show_secret,
      pc.secret_color AS linked_pc_secret_color

    FROM companion_main c

    -- Social biography
    LEFT JOIN companion_social soc
      ON soc.companion_id = c.id

    -- Gallery
    LEFT JOIN companion_gallery gal
      ON gal.companion_id = c.id

    -- Classes + archetypes
    LEFT JOIN companion_class cls
      ON cls.companion_id = c.id
    LEFT JOIN companion_class_archetype arch
      ON arch.companion_class_id = cls.id

    -- Religion
    LEFT JOIN companion_religion rel
      ON rel.companion_id = c.id

    -- Titles
    LEFT JOIN companion_titles t
      ON t.companion_id = c.id

    -- Achievements
    LEFT JOIN companion_achievements ach
      ON ach.companion_id = c.id

    -- Scars
    LEFT JOIN companion_scars sc
      ON sc.companion_id = c.id

    -- Attributes
    LEFT JOIN companion_attributes attr
      ON attr.companion_id = c.id

    -- Stats
    LEFT JOIN companion_stats stats
      ON stats.companion_id = c.id

    -- Skills
    LEFT JOIN companion_skills skl
      ON skl.companion_id = c.id

    -- Languages
    LEFT JOIN companion_language lang
      ON lang.companion_id = c.id

    -- Speed
    LEFT JOIN companion_speed sp
      ON sp.companion_id = c.id

    -- Faction memberships
    LEFT JOIN faction_companions fc
      ON fc.companion_id = c.id

    -- Linked PC
    LEFT JOIN pc_main pc
      ON pc.id = c.pc_id

    WHERE c.id = $1;
  `;

  const { rows } = await db.query(query, params);
  return rows;
};

// Get full detail data for a single NPC.
const getNPCDetails = async (npcId) => {
  const params = [npcId];

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

      -- Gallery (multiple rows)
      gal.id AS gallery_id,
      gal.image_url AS gallery_image_url,
      gal.alt AS gallery_alt,
      gal.is_imported AS gallery_imported,
      gal.is_main AS gallery_is_main,
      gal.is_hover AS gallery_is_hover,
      gal.show_hover AS gallery_hover_visible,
      gal.is_tall AS gallery_is_tall,

      -- Religion (multiple rows)
      rel.id AS religion_entry_id,
      rel.religion_id,
      rel.notes AS religion_notes,
      rel.secrets AS religion_secrets,

      -- Titles (multiple rows)
      t.id AS title_entry_id,
      t.title_id,
      t.title_location,
      t.adjust_ranking,
      t.adjust_value,
      t.has_location,
      t.use_honorific,
      t.received_session,

      -- Attitude (one row)
      att.id AS attitude_entry_id,
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

      -- Quests (multiple rows)
      q.quest_id,

      -- Languages (multiple rows)
      lang.language_id,

      -- Faction memberships (multiple rows)
      fn.faction_id,
      fn.association_type AS faction_association_type,
      fn.association_rank AS faction_association_rank

    FROM npc_main n

    -- Social biography
    LEFT JOIN npc_social soc
      ON soc.npc_id = n.id

    -- Gallery
    LEFT JOIN npc_gallery gal
      ON gal.npc_id = n.id

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

    -- Faction memberships
    LEFT JOIN faction_npcs fn
      ON fn.npc_id = n.id

    WHERE n.id = $1;
  `;

  const { rows } = await db.query(query, params);
  return rows;
};

// Get full detail data for a single Faction.
const getFactionDetails = async (factionId) => {
  const params = [factionId];

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

      -- Gallery (multiple rows)
      gal.id AS gallery_id,
      gal.image_url AS gallery_image_url,
      gal.alt AS gallery_alt,
      gal.is_imported AS gallery_imported,
      gal.is_main AS gallery_is_main,
      gal.is_hover AS gallery_is_hover,
      gal.hover_visible AS gallery_hover_visible,
      gal.is_tall AS gallery_is_tall,

      -- Attitude (one row)
      att.id AS attitude_entry_id,
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

      -- Quests (multiple rows)
      q.quest_id,

      -- PC members
      fp.pc_id AS pc_member_id,
      pc.pc_name AS pc_member_name,
      pc.is_identified AS pc_identified,
      pc.secret_name AS pc_secret_name,
      pc.show_secret_name AS pc_show_secret,
      pc.secret_color AS pc_secret_color,

      -- Companion members
      fc.companion_id AS companion_member_id,
      c.companion_name AS companion_member_name,
      c.is_identified AS companion_identified,
      c.secret_name AS companion_secret_name,
      c.show_secret_name AS companion_show_secret,
      c.secret_color AS companion_secret_color,

      -- NPC members
      fn.npc_id AS npc_member_id,
      n.npc_name AS npc_member_name,
      n.is_identified AS npc_identified,
      n.secret_name AS npc_secret_name,
      n.show_secret_name AS npc_show_secret,
      n.secret_color AS npc_secret_color

    FROM factions f

    -- Social biography
    LEFT JOIN faction_social soc
      ON soc.faction_id = f.id

    -- Gallery
    LEFT JOIN faction_gallery gal
      ON gal.faction_id = f.id

    -- Attitude
    LEFT JOIN faction_attitude att
      ON att.faction_id = f.id

    -- Quests
    LEFT JOIN faction_quests q
      ON q.faction_id = f.id

    -- PC members
    LEFT JOIN faction_pcs fp
      ON fp.faction_id = f.id
    LEFT JOIN pc_main pc
      ON pc.id = fp.pc_id

    -- Companion members
    LEFT JOIN faction_companions fc
      ON fc.faction_id = f.id
    LEFT JOIN companion_main c
      ON c.id = fc.companion_id

    -- NPC members
    LEFT JOIN faction_npcs fn
      ON fn.faction_id = f.id
    LEFT JOIN npc_main n
      ON n.id = fn.npc_id

    WHERE f.id = $1;
  `;

  const { rows } = await db.query(query, params);
  return rows;
};

//Exports
export { getPCDetails, getCompanionDetails, getNPCDetails, getFactionDetails };