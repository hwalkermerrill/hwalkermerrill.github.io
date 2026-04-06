-- Database table structure
-- First, Create the tables if they don't exist,

-- Roles table for role-based access control
CREATE TABLE IF NOT EXISTS roles (
  id SERIAL PRIMARY KEY,
  role_name VARCHAR(50) UNIQUE NOT NULL, -- e.g., 'gm_admin', 'user'
  role_description TEXT
);

-- Users table for registration system
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  role_id INTEGER NOT NULL
    REFERENCES roles (id)
    ON UPDATE CASCADE
    ON DELETE SET DEFAULT,
  full_name VARCHAR(255) NOT NULL,
  username VARCHAR(50) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for organizing data by campaigns. Multiple users per campaign and vice versa, and campaigns are optional to allow for one-offs.
-- PCs can be associated with any campaign, or none, but only one at a time.
CREATE TABLE IF NOT EXISTS campaigns (
  id SERIAL PRIMARY KEY,
  campaign_name VARCHAR(255) NOT NULL,
  description TEXT,
  start_date DATE,
  end_date DATE DEFAULT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  archived BOOLEAN NOT NULL DEFAULT FALSE
);

-- General notes for players and GMs, one-to-many as each note is separate but each user may have multiple notes.
CREATE TABLE IF NOT EXISTS campaign_notes (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL
    REFERENCES users (id)
    ON DELETE CASCADE,
  campaign_id INTEGER
    REFERENCES campaigns (id)
    ON DELETE SET NULL,
  note_title VARCHAR(255) NOT NULL,
  note_content TEXT NOT NULL,
  pinned BOOLEAN NOT NULL DEFAULT FALSE,
  UNIQUE (user_id, campaign_id, note_title),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- General table for tracking active and past quests, one-to-many as each quest is separate but campaigns may have multiple quests.
CREATE TABLE IF NOT EXISTS quests (
  id SERIAL PRIMARY KEY,
  campaign_id INTEGER NOT NULL
    REFERENCES campaigns (id)
    ON DELETE CASCADE,
  quest_name VARCHAR(255) NOT NULL,
  description TEXT,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  completed BOOLEAN NOT NULL DEFAULT FALSE,
  CHECK (NOT (active AND completed)),
  UNIQUE (campaign_id, quest_name),
  session_received INTEGER NOT NULL DEFAULT 1
);

-- START GLOBAL LOOKUP TABLES BLOCK for references, one-to-many.
CREATE TABLE IF NOT EXISTS active_status (
  id SERIAL PRIMARY KEY,
  active_status_name VARCHAR(50) UNIQUE NOT NULL -- Pending, Active, Retired, Deceased, etc.
);
CREATE TABLE IF NOT EXISTS attitude (
  id SERIAL PRIMARY KEY,
  attitude_name VARCHAR(50) UNIQUE NOT NULL -- Hostile, Unfriendly, Neutral, Friendly, Helpful, Indifferent
);
CREATE TABLE IF NOT EXISTS speed (
  id SERIAL PRIMARY KEY,
  speed_name VARCHAR(50) UNIQUE NOT NULL -- Base, Fly, Swim, Climb, Burrow, etc.
);
CREATE TABLE IF NOT EXISTS classes (
  id SERIAL PRIMARY KEY,
  class_name VARCHAR(50) UNIQUE NOT NULL,
  source VARCHAR(50), -- Core, APG, Hybrid, NPC, Prestige, etc.
  class_type VARCHAR(50) DEFAULT NULL, -- Martial, Skill, Magic, Hybrid(s), Hybrid(m), Hybrid(3), Prestige
  magic_type VARCHAR(50) DEFAULT NULL, -- Alchemical, Arcane, Divine, Primal, Occult, Null
  caster_spontaneous BOOLEAN NOT NULL DEFAULT FALSE,
  has_companion BOOLEAN NOT NULL DEFAULT FALSE,
  is_recommended BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TABLE IF NOT EXISTS race (
  id SERIAL PRIMARY KEY,
  race_name VARCHAR(50) UNIQUE NOT NULL,
  limited BOOLEAN NOT NULL DEFAULT TRUE,
  remaining INTEGER NOT NULL DEFAULT 1,
  prejudiced BOOLEAN NOT NULL DEFAULT FALSE,
  is_recommended BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TABLE IF NOT EXISTS religions (
  id SERIAL PRIMARY KEY,
  religion_name VARCHAR(50) UNIQUE NOT NULL,
  obscurity VARCHAR(50) NOT NULL DEFAULT 'Common', -- Common, Uncommon, Racial, Regional, Obscure, Lost
  is_restricted BOOLEAN NOT NULL DEFAULT FALSE,
  is_recommended BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TABLE IF NOT EXISTS languages (
  id SERIAL PRIMARY KEY,
  language_name VARCHAR(50) UNIQUE NOT NULL,
  is_recommended BOOLEAN NOT NULL DEFAULT FALSE,
  is_dialect BOOLEAN NOT NULL DEFAULT FALSE,
  is_ancient BOOLEAN NOT NULL DEFAULT FALSE,
  is_secret BOOLEAN NOT NULL DEFAULT FALSE
);
-- END GLOBAL TABLES BLOCK

-- START ACHIEVEMENTS AND TITLES TABLES BLOCK
CREATE TABLE IF NOT EXISTS achievements (
  id SERIAL PRIMARY KEY,
  campaign_id INTEGER
    REFERENCES campaigns (id)
    ON DELETE SET NULL,
  achievement_name VARCHAR(255) NOT NULL,
  category VARCHAR(50) NOT NULL,
  description TEXT,
  UNIQUE (achievement_name, campaign_id),
  session_received INTEGER NOT NULL DEFAULT 1
);
CREATE TABLE IF NOT EXISTS titles (
  id SERIAL PRIMARY KEY,
  rank_id INTEGER
    REFERENCES title_ranks (id)
    ON DELETE SET NULL,
  title_name VARCHAR(255) UNIQUE NOT NULL,
  name_feminine VARCHAR(255) DEFAULT NULL,
  honorific_masculine VARCHAR(255) DEFAULT NULL,
  honorific_feminine VARCHAR(255) DEFAULT NULL,
  prefix_masculine VARCHAR(255) DEFAULT NULL,
  prefix_feminine VARCHAR(255) DEFAULT NULL,
  description TEXT
);
CREATE TABLE IF NOT EXISTS title_ranks (
  id SERIAL PRIMARY KEY,
  title_rank_name VARCHAR(50) UNIQUE NOT NULL, -- 'empire', 'kingdom', 'duchy', etc.
  sort_order INTEGER NOT NULL       -- 1 = highest, etc.
);

-- END ACHIEVEMENTS AND TITLES TABLES BLOCK

-- START PC TABLES BLOCK 
-- Table for player characters (PCs), each player may build multiple, but may only have one active at a time.
-- All other PC-related tables reference this one via pc_main(id).
CREATE TABLE IF NOT EXISTS pc_main (
  id SERIAL PRIMARY KEY,
  user_id INTEGER
    REFERENCES users (id)
    ON DELETE SET NULL,
  campaign_id INTEGER
    REFERENCES campaigns (id)
    ON DELETE SET NULL,
  active_status_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Pending' status
    REFERENCES active_status (id)
    ON DELETE RESTRICT,
  race_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Unknown'
    REFERENCES race (id)
    ON DELETE RESTRICT,
  unknown_name VARCHAR(50) DEFAULT 'Unknown',
  pc_name VARCHAR(255) NOT NULL,
  is_gendered BOOLEAN NOT NULL DEFAULT TRUE,
  is_female BOOLEAN NOT NULL DEFAULT FALSE,
  description TEXT,
  race_traits TEXT,
  retired_reason TEXT,
  death_cause TEXT,
  end_session INTEGER DEFAULT NULL,
  UNIQUE (user_id, campaign_id, pc_name),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Social Biography table for roleplaying, all details public except secrets.
CREATE TABLE IF NOT EXISTS pc_social (
  id SERIAL PRIMARY KEY,
  pc_id INTEGER NOT NULL
    REFERENCES pc_main (id)
    ON DELETE CASCADE,
  appearance TEXT,
  background TEXT,
  associates TEXT,
  rumors TEXT,
  aspirations TEXT,
  anathema TEXT,
  phobias TEXT,
  quirks TEXT,
  flaws TEXT,
  secrets TEXT,
  UNIQUE (pc_id)
);

-- Gallery for character art, one to many as each image is separate but PCs may choose to have multiple images for their characters.
-- PCs can only have one main or hover image at a time. Imported is for backend so I know if the image is stored locally or is an external URL.
CREATE TABLE IF NOT EXISTS pc_gallery (
  id SERIAL PRIMARY KEY,
  pc_id INTEGER NOT NULL
    REFERENCES pc_main (id)
    ON DELETE CASCADE,
  image_url TEXT DEFAULT NULL,
  alt VARCHAR(255) NOT NULL DEFAULT 'Character Image',
  is_imported BOOLEAN NOT NULL DEFAULT FALSE,
  is_main BOOLEAN NOT NULL DEFAULT FALSE,
  is_hover BOOLEAN NOT NULL DEFAULT FALSE,
  is_tall BOOLEAN NOT NULL DEFAULT FALSE
);

-- PC tables that interact with global tables, one-to-many as each entry is separate but PCs may have multiple entries (multiple classes, religions, languages, etc.)
CREATE TABLE IF NOT EXISTS pc_class (
  id SERIAL PRIMARY KEY,
  pc_id INTEGER NOT NULL
    REFERENCES pc_main (id)
    ON DELETE CASCADE,
  class_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Unknown'
    REFERENCES classes (id)
    ON DELETE RESTRICT,
  unknown_name VARCHAR(50) DEFAULT 'Unknown',
  class_level INTEGER NOT NULL DEFAULT 1,
  UNIQUE (pc_id, class_id)
);
CREATE TABLE IF NOT EXISTS pc_class_archetype (
  id SERIAL PRIMARY KEY,
  pc_class_id INTEGER NOT NULL
    REFERENCES pc_class (id)
    ON DELETE CASCADE,
  archetype_name VARCHAR(255) NOT NULL,
  UNIQUE (pc_class_id, archetype_name)
);
CREATE TABLE IF NOT EXISTS pc_religion (
  id SERIAL PRIMARY KEY,
  pc_id INTEGER NOT NULL
    REFERENCES pc_main (id)
    ON DELETE CASCADE,
  religion_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Unknown'
    REFERENCES religions (id)
    ON DELETE RESTRICT,
  notes TEXT,
  secrets TEXT DEFAULT NULL,
  UNIQUE (pc_id, religion_id)
);
CREATE TABLE IF NOT EXISTS pc_language (
  id SERIAL PRIMARY KEY,
  pc_id INTEGER NOT NULL
    REFERENCES pc_main (id)
    ON DELETE CASCADE,
  language_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Common'
    REFERENCES languages (id)
    ON DELETE RESTRICT,
  UNIQUE (pc_id, language_id)
);
CREATE TABLE IF NOT EXISTS pc_speed (
  id SERIAL PRIMARY KEY,
  pc_id INTEGER NOT NULL
    REFERENCES pc_main (id)
    ON DELETE CASCADE,
  speed_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Base'
    REFERENCES speed (id)
    ON DELETE RESTRICT,
  speed_value INTEGER NOT NULL DEFAULT 30,
  UNIQUE (pc_id, speed_id)
);
CREATE TABLE IF NOT EXISTS pc_achievements (
  id SERIAL PRIMARY KEY,
  pc_id INTEGER NOT NULL
    REFERENCES pc_main (id)
    ON DELETE CASCADE,
  achievement_id INTEGER NOT NULL
    REFERENCES achievements (id)
    ON DELETE CASCADE,
  is_killing_blow BOOLEAN NOT NULL DEFAULT FALSE,
  UNIQUE (pc_id, achievement_id)
);
CREATE TABLE IF NOT EXISTS pc_titles (
  id SERIAL PRIMARY KEY,
  pc_id INTEGER NOT NULL
    REFERENCES pc_main (id)
    ON DELETE CASCADE,
  title_id INTEGER NOT NULL
    REFERENCES titles (id)
    ON DELETE RESTRICT,
  title_location VARCHAR(255) DEFAULT NULL,
  adjust_ranking VARCHAR(10) DEFAULT NULL, -- Up, Down, or Null
  adjust_value INTEGER DEFAULT NULL, -- Amount adjusted
  has_location BOOLEAN DEFAULT FALSE,
  use_honorific BOOLEAN DEFAULT TRUE,
  UNIQUE (pc_id, title_id, title_location),
  received_session INTEGER NOT NULL DEFAULT 1
);

-- Tables for quick reference of core stats, one-to-one relationships with pc_main, enforced by UNIQUE constraint on pc_id.
CREATE TABLE IF NOT EXISTS pc_attributes (
  id SERIAL PRIMARY KEY,
  pc_id INTEGER NOT NULL
    REFERENCES pc_main (id)
    ON DELETE CASCADE,
  alignment VARCHAR(50) NOT NULL DEFAULT 'Neutral',
  strength INTEGER NOT NULL DEFAULT 10,
  dexterity INTEGER NOT NULL DEFAULT 10,
  constitution INTEGER NOT NULL DEFAULT 10,
  intelligence INTEGER NOT NULL DEFAULT 10,
  wisdom INTEGER NOT NULL DEFAULT 10,
  charisma INTEGER NOT NULL DEFAULT 10,
  notes TEXT,
  UNIQUE (pc_id)
);
CREATE TABLE IF NOT EXISTS pc_stats (
  id SERIAL PRIMARY KEY,
  pc_id INTEGER NOT NULL
    REFERENCES pc_main (id)
    ON DELETE CASCADE,
  main_ac INTEGER NOT NULL DEFAULT 10,
  flat_ac INTEGER NOT NULL DEFAULT 10,
  touch_ac INTEGER NOT NULL DEFAULT 10,
  cmd INTEGER NOT NULL DEFAULT 10,
  max_hp INTEGER NOT NULL DEFAULT 10,
  notes TEXT,
  UNIQUE (pc_id)
);
CREATE TABLE IF NOT EXISTS pc_skills (
  id SERIAL PRIMARY KEY,
  pc_id INTEGER NOT NULL
    REFERENCES pc_main (id)
    ON DELETE CASCADE,
  initiative INTEGER NOT NULL DEFAULT 0,
  perception INTEGER NOT NULL DEFAULT 0,
  sense_motive INTEGER NOT NULL DEFAULT 0,
  disguise INTEGER NOT NULL DEFAULT 0,
  stealth INTEGER NOT NULL DEFAULT 0,
  disable_device INTEGER NOT NULL DEFAULT 0,
  reflex INTEGER NOT NULL DEFAULT 0,
  fortitude INTEGER NOT NULL DEFAULT 0,
  will INTEGER NOT NULL DEFAULT 0,
  rerolls TEXT,
  notes TEXT,
  UNIQUE (pc_id)
);

-- Scars for social reference, scars are earned from receiving critical hits or taking too much damage from one encounter, and are a record of past combats. One to many.
CREATE TABLE IF NOT EXISTS pc_scars (
  id SERIAL PRIMARY KEY,
  pc_id INTEGER NOT NULL
    REFERENCES pc_main (id)
    ON DELETE CASCADE,
  scar_cause TEXT NOT NULL DEFAULT 'Unknown',
  scar_description TEXT,
  session_received INTEGER NOT NULL DEFAULT 1
);
-- END PC TABLES BLOCK

-- START COMPANION TABLES BLOCK
-- Companions are NPCs that are closely associated with a PC, such as a familiar or animal companion.
CREATE TABLE IF NOT EXISTS companion_main (
  id SERIAL PRIMARY KEY,
  user_id INTEGER
    REFERENCES users (id)
    ON DELETE SET NULL,
  pc_id INTEGER
    REFERENCES pc_main (id)
    ON DELETE SET NULL,
  campaign_id INTEGER
    REFERENCES campaigns (id)
    ON DELETE SET NULL,
  active_status_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Pending' status
    REFERENCES active_status (id)
    ON DELETE RESTRICT,
  race_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Unknown'
    REFERENCES race (id)
    ON DELETE RESTRICT,
  unknown_name VARCHAR(50) DEFAULT 'Unknown',
  companion_name VARCHAR(255) NOT NULL,
  is_gendered BOOLEAN NOT NULL DEFAULT TRUE,
  is_female BOOLEAN NOT NULL DEFAULT FALSE,
  description TEXT,
  race_traits TEXT,
  death_cause TEXT,
  end_session INTEGER DEFAULT NULL,
  UNIQUE (pc_id, companion_name),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS companion_class (
  id SERIAL PRIMARY KEY,
  companion_id INTEGER NOT NULL
    REFERENCES companion_main (id)
    ON DELETE CASCADE,
  class_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Unknown'
    REFERENCES classes (id)
    ON DELETE RESTRICT,
  unknown_name VARCHAR(50) DEFAULT 'Unknown',
  class_level INTEGER NOT NULL DEFAULT 1,
  UNIQUE (companion_id, class_id)
);
CREATE TABLE IF NOT EXISTS companion_class_archetype (
  id SERIAL PRIMARY KEY,
  companion_class_id INTEGER NOT NULL
    REFERENCES companion_class (id)
    ON DELETE CASCADE,
  archetype_name VARCHAR(255) NOT NULL,
  UNIQUE (companion_class_id, archetype_name)
);
CREATE TABLE IF NOT EXISTS companion_social (
  id SERIAL PRIMARY KEY,
  companion_id INTEGER NOT NULL
    REFERENCES companion_main (id)
    ON DELETE CASCADE,
  appearance TEXT,
  background TEXT,
  extra_details TEXT,
  secrets TEXT,
  UNIQUE (companion_id)
);
CREATE TABLE IF NOT EXISTS companion_gallery (
  id SERIAL PRIMARY KEY,
  companion_id INTEGER NOT NULL
    REFERENCES companion_main (id)
    ON DELETE CASCADE,
  image_url TEXT DEFAULT NULL,
  alt VARCHAR(255) NOT NULL DEFAULT 'Companion Portrait',
  is_imported BOOLEAN NOT NULL DEFAULT FALSE,
  is_main BOOLEAN NOT NULL DEFAULT FALSE,
  is_hover BOOLEAN NOT NULL DEFAULT FALSE,
  is_tall BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TABLE IF NOT EXISTS companion_speed (
  id SERIAL PRIMARY KEY,
  companion_id INTEGER NOT NULL
    REFERENCES companion_main (id)
    ON DELETE CASCADE,
  speed_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Base'
    REFERENCES speed (id)
    ON DELETE RESTRICT,
  speed_value INTEGER NOT NULL DEFAULT 30,
  UNIQUE (companion_id, speed_id)
);
CREATE TABLE IF NOT EXISTS companion_religion (
  id SERIAL PRIMARY KEY,
  companion_id INTEGER NOT NULL
    REFERENCES companion_main (id)
    ON DELETE CASCADE,
  religion_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Unknown'
    REFERENCES religions (id)
    ON DELETE RESTRICT,
  notes TEXT,
  secrets TEXT DEFAULT NULL,
  UNIQUE (companion_id, religion_id)
);
CREATE TABLE IF NOT EXISTS companion_language (
  id SERIAL PRIMARY KEY,
  companion_id INTEGER NOT NULL
    REFERENCES companion_main (id)
    ON DELETE CASCADE,
  language_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Common'
    REFERENCES languages (id)
    ON DELETE RESTRICT,
  UNIQUE (companion_id, language_id)
);
CREATE TABLE IF NOT EXISTS companion_achievements (
  id SERIAL PRIMARY KEY,
  companion_id INTEGER NOT NULL
    REFERENCES companion_main (id)
    ON DELETE CASCADE,
  achievement_id INTEGER NOT NULL
    REFERENCES achievements (id)
    ON DELETE CASCADE,
  is_killing_blow BOOLEAN NOT NULL DEFAULT FALSE,
  UNIQUE (companion_id, achievement_id)
);
CREATE TABLE IF NOT EXISTS companion_titles (
  id SERIAL PRIMARY KEY,
  companion_id INTEGER NOT NULL
    REFERENCES companion_main (id)
    ON DELETE CASCADE,
  title_id INTEGER NOT NULL
    REFERENCES titles (id)
    ON DELETE RESTRICT,
  title_location VARCHAR(255) DEFAULT NULL,
  adjust_ranking VARCHAR(10) DEFAULT NULL, -- Up, Down, or Null
  adjust_value INTEGER DEFAULT NULL, -- Amount adjusted
  has_location BOOLEAN DEFAULT FALSE,
  use_honorific BOOLEAN DEFAULT TRUE,
  UNIQUE (companion_id, title_id, title_location),
  received_session INTEGER NOT NULL DEFAULT 1
);
CREATE TABLE IF NOT EXISTS companion_scars (
  id SERIAL PRIMARY KEY,
  companion_id INTEGER NOT NULL
    REFERENCES companion_main (id)
    ON DELETE CASCADE,
  scar_cause TEXT NOT NULL DEFAULT 'Unknown',
  scar_description TEXT,
  session_received INTEGER NOT NULL DEFAULT 1
);
CREATE TABLE IF NOT EXISTS companion_attributes (
  id SERIAL PRIMARY KEY,
  companion_id INTEGER NOT NULL
    REFERENCES companion_main (id)
    ON DELETE CASCADE,
  alignment VARCHAR(50) NOT NULL DEFAULT 'Neutral',
  strength INTEGER NOT NULL DEFAULT 10,
  dexterity INTEGER NOT NULL DEFAULT 10,
  constitution INTEGER NOT NULL DEFAULT 10,
  intelligence INTEGER NOT NULL DEFAULT 10,
  wisdom INTEGER NOT NULL DEFAULT 10,
  charisma INTEGER NOT NULL DEFAULT 10,
  notes TEXT,
  UNIQUE (companion_id)
);
CREATE TABLE IF NOT EXISTS companion_stats (
  id SERIAL PRIMARY KEY,
  companion_id INTEGER NOT NULL
    REFERENCES companion_main (id)
    ON DELETE CASCADE,
  main_ac INTEGER NOT NULL DEFAULT 10,
  flat_ac INTEGER NOT NULL DEFAULT 10,
  touch_ac INTEGER NOT NULL DEFAULT 10,
  cmd INTEGER NOT NULL DEFAULT 10,
  max_hp INTEGER NOT NULL DEFAULT 10,
  notes TEXT,
  UNIQUE (companion_id)
);
CREATE TABLE IF NOT EXISTS companion_skills (
  id SERIAL PRIMARY KEY,
  companion_id INTEGER NOT NULL
    REFERENCES companion_main (id)
    ON DELETE CASCADE,
  initiative INTEGER NOT NULL DEFAULT 0,
  perception INTEGER NOT NULL DEFAULT 0,
  sense_motive INTEGER NOT NULL DEFAULT 0,
  disguise INTEGER NOT NULL DEFAULT 0,
  stealth INTEGER NOT NULL DEFAULT 0,
  disable_device INTEGER NOT NULL DEFAULT 0,
  reflex INTEGER NOT NULL DEFAULT 0,
  fortitude INTEGER NOT NULL DEFAULT 0,
  will INTEGER NOT NULL DEFAULT 0,
  rerolls TEXT,
  notes TEXT,
  UNIQUE (companion_id)
);
-- END COMPANION TABLES BLOCK

-- START NPC TABLES BLOCK
-- NPCs are non-player characters that are not closely associated with a PC, such as quest givers or shopkeepers.
CREATE TABLE IF NOT EXISTS npc_main (
  id SERIAL PRIMARY KEY,
  campaign_id INTEGER
    REFERENCES campaigns (id)
    ON DELETE SET NULL,
  active_status_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Pending' status
    REFERENCES active_status (id)
    ON DELETE RESTRICT,
  race_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Unknown'
    REFERENCES race (id)
    ON DELETE RESTRICT,
  unknown_name VARCHAR(50) DEFAULT 'Unknown',
  is_identified BOOLEAN NOT NULL DEFAULT FALSE,
  npc_name VARCHAR(255) NOT NULL,
  is_gendered BOOLEAN NOT NULL DEFAULT TRUE,
  is_female BOOLEAN NOT NULL DEFAULT FALSE,
  description TEXT,
  secrets TEXT,
  pinned BOOLEAN NOT NULL DEFAULT FALSE,
  death_cause TEXT,
  retired_reason TEXT,
  start_session INTEGER NOT NULL DEFAULT 1,
  end_session INTEGER DEFAULT NULL,
  UNIQUE (campaign_id, npc_name),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS npc_religion (
  id SERIAL PRIMARY KEY,
  npc_id INTEGER NOT NULL
    REFERENCES npc_main (id)
    ON DELETE CASCADE,
  religion_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Unknown'
    REFERENCES religions (id)
    ON DELETE RESTRICT,
  notes TEXT,
  secrets TEXT DEFAULT NULL,
  UNIQUE (npc_id, religion_id)
);
CREATE TABLE IF NOT EXISTS npc_titles (
  id SERIAL PRIMARY KEY,
  npc_id INTEGER NOT NULL
    REFERENCES npc_main (id)
    ON DELETE CASCADE,
  title_id INTEGER NOT NULL
    REFERENCES titles (id)
    ON DELETE RESTRICT,
  title_location VARCHAR(255) DEFAULT NULL,
  adjust_ranking VARCHAR(10) DEFAULT NULL, -- Up, Down, or Null
  adjust_value INTEGER DEFAULT NULL, -- Amount adjusted
  has_location BOOLEAN DEFAULT FALSE,
  use_honorific BOOLEAN DEFAULT TRUE,
  UNIQUE (npc_id, title_id, title_location),
  received_session INTEGER NOT NULL DEFAULT 1
);
-- NPC's have changing attitudes towards the PC's which can be tracked here. Each NPC can only have one attitude at a time.
CREATE TABLE IF NOT EXISTS npc_attitude (
  id SERIAL PRIMARY KEY,
  npc_id INTEGER NOT NULL
    REFERENCES npc_main (id)
    ON DELETE CASCADE,
  attitude_id INTEGER NOT NULL DEFAULT 3 -- Default to 'Neutral'
    REFERENCES attitude (id)
    ON DELETE RESTRICT,
  favored_pc INTEGER
    REFERENCES pc_main (id)
    ON DELETE SET NULL,
  allies TEXT,
  allies_visible BOOLEAN NOT NULL DEFAULT FALSE,
  enemies TEXT,
  enemies_visible BOOLEAN NOT NULL DEFAULT FALSE,
  influence_skills TEXT,
  skills_visible BOOLEAN NOT NULL DEFAULT FALSE,
  influence_notes TEXT,
  notes_visible BOOLEAN NOT NULL DEFAULT FALSE,
  progress_made INTEGER NOT NULL DEFAULT 0,
  progress_threshold INTEGER NOT NULL DEFAULT 10,
  boon_active BOOLEAN NOT NULL DEFAULT FALSE,
  hostile_boon TEXT,
  unhelpful_boon TEXT,
  neutral_boon TEXT,
  friendly_boon TEXT,
  helpful_boon TEXT,
  notes TEXT,
  secrets TEXT,
  UNIQUE (npc_id)
);
CREATE TABLE IF NOT EXISTS npc_social (
  id SERIAL PRIMARY KEY,
  npc_id INTEGER NOT NULL
    REFERENCES npc_main (id)
    ON DELETE CASCADE,
  appearance TEXT,
  background TEXT,
  extra_details TEXT,
  hidden_details TEXT,
  reveal_hidden_details BOOLEAN NOT NULL DEFAULT FALSE,
  secrets TEXT,
  UNIQUE (npc_id)
);
CREATE TABLE IF NOT EXISTS npc_quests (
  id SERIAL PRIMARY KEY,
  npc_id INTEGER NOT NULL
    REFERENCES npc_main (id)
    ON DELETE CASCADE,
  quest_id INTEGER NOT NULL
    REFERENCES quests (id)
    ON DELETE CASCADE,
  UNIQUE (npc_id, quest_id)
);
CREATE TABLE IF NOT EXISTS npc_gallery (
  id SERIAL PRIMARY KEY,
  npc_id INTEGER NOT NULL
    REFERENCES npc_main (id)
    ON DELETE CASCADE,
  image_url TEXT DEFAULT NULL,
  alt VARCHAR(255) NOT NULL DEFAULT 'NPC Portrait',
  is_imported BOOLEAN NOT NULL DEFAULT FALSE,
  is_main BOOLEAN NOT NULL DEFAULT FALSE,
  is_hover BOOLEAN NOT NULL DEFAULT FALSE,
  is_tall BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TABLE IF NOT EXISTS npc_language (
  id SERIAL PRIMARY KEY,
  npc_id INTEGER NOT NULL
    REFERENCES npc_main (id)
    ON DELETE CASCADE,
  language_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Common'
    REFERENCES languages (id)
    ON DELETE RESTRICT,
  UNIQUE (npc_id, language_id)
);
CREATE TABLE IF NOT EXISTS npc_stats (
  id SERIAL PRIMARY KEY,
  npc_id INTEGER NOT NULL
    REFERENCES npc_main (id)
    ON DELETE CASCADE,
  main_ac INTEGER NOT NULL DEFAULT 10,
  max_hp INTEGER NOT NULL DEFAULT 10,
  perception INTEGER NOT NULL DEFAULT 0,
  sense_motive INTEGER NOT NULL DEFAULT 0,
  will INTEGER NOT NULL DEFAULT 0,
  reflex INTEGER NOT NULL DEFAULT 0,
  fortitude INTEGER NOT NULL DEFAULT 0,
  notes TEXT,
  UNIQUE (npc_id)
);
-- END NPC TABLES BLOCK

-- START FACTIONS TABLES BLOCK
-- Factions are groups that NPCs and PCs can be associated with, such as a thieves guild or a religious order.
-- Factions can have quests and boons, and multiple NPCs can be members of multiple factions.
CREATE TABLE IF NOT EXISTS factions (
  id SERIAL PRIMARY KEY,
  campaign_id INTEGER
    REFERENCES campaigns (id)
    ON DELETE SET NULL,
  active_status_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Pending' status
    REFERENCES active_status (id)
    ON DELETE RESTRICT,
  is_identified BOOLEAN NOT NULL DEFAULT FALSE,
  faction_name VARCHAR(255) NOT NULL,
  faction_type VARCHAR(50) NOT NULL,
  description TEXT,
  secrets TEXT,
  pinned BOOLEAN NOT NULL DEFAULT FALSE,
  progress_able BOOLEAN NOT NULL DEFAULT FALSE,
  progress_made INTEGER NOT NULL DEFAULT 0,
  progress_threshold INTEGER NOT NULL DEFAULT 10,
  death_cause TEXT,
  retired_reason TEXT,
  start_session INTEGER NOT NULL DEFAULT 1,
  end_session INTEGER DEFAULT NULL,
  UNIQUE (campaign_id, faction_name)
);
CREATE TABLE IF NOT EXISTS faction_social (
  id SERIAL PRIMARY KEY,
  faction_id INTEGER NOT NULL
    REFERENCES factions (id)
    ON DELETE CASCADE,
  appearance TEXT,
  background TEXT,
  extra_details TEXT,
  hidden_details TEXT,
  reveal_hidden_details BOOLEAN NOT NULL DEFAULT FALSE,
  secrets TEXT,
  UNIQUE (faction_id)
);
CREATE TABLE IF NOT EXISTS faction_attitude (
  id SERIAL PRIMARY KEY,
  faction_id INTEGER NOT NULL
    REFERENCES factions (id)
    ON DELETE CASCADE,
  attitude_id INTEGER NOT NULL DEFAULT 3 -- Default to 'Neutral'
    REFERENCES attitude (id)
    ON DELETE RESTRICT,
  favored_pc INTEGER
    REFERENCES pc_main (id)
    ON DELETE SET NULL,
  allies TEXT,
  allies_visible BOOLEAN NOT NULL DEFAULT FALSE,
  enemies TEXT,
  enemies_visible BOOLEAN NOT NULL DEFAULT FALSE,
  influence_skills TEXT,
  skills_visible BOOLEAN NOT NULL DEFAULT FALSE,
  influence_notes TEXT,
  notes_visible BOOLEAN NOT NULL DEFAULT FALSE,
  progress_made INTEGER NOT NULL DEFAULT 0,
  progress_threshold INTEGER NOT NULL DEFAULT 10,
  boon_active BOOLEAN NOT NULL DEFAULT FALSE,
  hostile_boon TEXT,
  unhelpful_boon TEXT,
  neutral_boon TEXT,
  friendly_boon TEXT,
  helpful_boon TEXT,
  notes TEXT,
  secrets TEXT,
  UNIQUE (faction_id)
);
CREATE TABLE IF NOT EXISTS faction_quests (
  id SERIAL PRIMARY KEY,
  faction_id INTEGER NOT NULL
    REFERENCES factions (id)
    ON DELETE CASCADE,
  quest_id INTEGER NOT NULL
    REFERENCES quests (id)
    ON DELETE CASCADE,
  UNIQUE (faction_id, quest_id)
);
CREATE TABLE IF NOT EXISTS faction_gallery (
  id SERIAL PRIMARY KEY,
  faction_id INTEGER NOT NULL
    REFERENCES factions (id)
    ON DELETE CASCADE,
  image_url TEXT DEFAULT NULL,
  alt VARCHAR(255) NOT NULL DEFAULT 'Faction Logo',
  is_imported BOOLEAN NOT NULL DEFAULT FALSE,
  is_main BOOLEAN NOT NULL DEFAULT FALSE,
  is_hover BOOLEAN NOT NULL DEFAULT FALSE,
  is_tall BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TABLE IF NOT EXISTS faction_npcs (
  id SERIAL PRIMARY KEY,
  faction_id INTEGER NOT NULL
    REFERENCES factions (id)
    ON DELETE CASCADE,
  npc_id INTEGER NOT NULL
    REFERENCES npc_main (id)
    ON DELETE CASCADE,
  UNIQUE (faction_id, npc_id)
);
CREATE TABLE IF NOT EXISTS faction_pcs (
  id SERIAL PRIMARY KEY,
  faction_id INTEGER NOT NULL
    REFERENCES factions (id)
    ON DELETE CASCADE,
  pc_id INTEGER NOT NULL
    REFERENCES pc_main (id)
    ON DELETE CASCADE,
  UNIQUE (faction_id, pc_id)
);
CREATE TABLE IF NOT EXISTS faction_companions (
  id SERIAL PRIMARY KEY,
  faction_id INTEGER NOT NULL
    REFERENCES factions (id)
    ON DELETE CASCADE,
  companion_id INTEGER NOT NULL
    REFERENCES companion_main (id)
    ON DELETE CASCADE,
  UNIQUE (faction_id, companion_id)
);
-- END FACTIONS TABLES BLOCK

-- START POLYMORPHIC MERCHANTS TABLE BLOCK
-- Both NPCs and Factions can be merchants, so this table uses a polymorphic association to link to either one. Each merchant can have multiple items for sale.
CREATE TABLE IF NOT EXISTS merchants (
  id SERIAL PRIMARY KEY,
  npc_id INTEGER
    REFERENCES npc_main (id)
    ON DELETE CASCADE,
  faction_id INTEGER
    REFERENCES factions (id)
    ON DELETE CASCADE,
  active_status_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Pending' status
    REFERENCES active_status (id)
    ON DELETE RESTRICT,
  UNIQUE (npc_id),
  UNIQUE (faction_id),
  CHECK (
    (npc_id IS NOT NULL AND faction_id IS NULL)
    OR (npc_id IS NULL AND faction_id IS NOT NULL)
  )
);
-- Merchant details, including the types of things they sell, how much they can carry, ect. One to one relationship with merchants.
CREATE TABLE IF NOT EXISTS merchant_details (
  id SERIAL PRIMARY KEY,
  merchant_id INTEGER NOT NULL
    REFERENCES merchants (id)
    ON DELETE CASCADE,
  merchant_type VARCHAR(50) NOT NULL,
  size VARCHAR(50),
  base_value INTEGER NOT NULL DEFAULT 50,
  purchase_limit INTEGER NOT NULL DEFAULT 500,
  minor_items INTEGER NOT NULL DEFAULT 0,
  moderate_items INTEGER NOT NULL DEFAULT 0,
  major_items INTEGER NOT NULL DEFAULT 0,
  spellcasting_limit INTEGER NOT NULL DEFAULT 0,
  notes TEXT,
  secrets TEXT,
  UNIQUE (merchant_id)
);
-- END POLYMORPHIC MERCHANTS TABLE BLOCK

-- START ITEMS TABLES BLOCK
-- These are objects the PCs can acquire, either from merchants or as loot. They can be associated with a PC, Companion, NPC, or Faction, but only one at a time.
-- This includes both unique items and lore-related items, such as a powerful artifact, a spellbook in a library, or a note found on an enemy.
-- This allows for tracking of important or unique items and their lore, as well as who currently possesses them.
CREATE TABLE IF NOT EXISTS items (
  id SERIAL PRIMARY KEY,
  campaign_id INTEGER
    REFERENCES campaigns (id)
    ON DELETE SET NULL,
  active_status_id INTEGER NOT NULL DEFAULT 1 -- Default to 'Pending' status
    REFERENCES active_status (id)
    ON DELETE RESTRICT,
  is_identified BOOLEAN NOT NULL DEFAULT FALSE,
  item_type VARCHAR(50) NOT NULL, -- magic, relic, artifact, note, journal, spellbook, etc.
  item_name VARCHAR(255) NOT NULL,
  caster_level INTEGER DEFAULT NULL,
  description TEXT,
  ability TEXT,
  unlocked_boons TEXT,
  destruction_method TEXT,
  secrets TEXT,
  boons_visible BOOLEAN NOT NULL DEFAULT FALSE,
  pinned BOOLEAN NOT NULL DEFAULT FALSE,
  unique_destruction BOOLEAN NOT NULL DEFAULT FALSE,
  UNIQUE (campaign_id, item_name)
);
-- For unique or table-generated item inventories, one to many relationship with merchants.
-- This merchant table is generated after the item table to avoid issues.
CREATE TABLE IF NOT EXISTS merchant_inventory (
  id SERIAL PRIMARY KEY,
  merchant_id INTEGER NOT NULL
    REFERENCES merchants (id)
    ON DELETE CASCADE,
  item_id INTEGER
    REFERENCES items (id)
    ON DELETE CASCADE,
  item_name VARCHAR(255) NOT NULL,
  item_description TEXT,
  item_price INTEGER NOT NULL DEFAULT 50,
  item_quantity INTEGER NOT NULL DEFAULT 1,
  UNIQUE (merchant_id, item_name)
);
CREATE TABLE IF NOT EXISTS item_owners (
  id SERIAL PRIMARY KEY,
  item_id INTEGER NOT NULL
    REFERENCES items (id)
    ON DELETE CASCADE,
  pc_id INTEGER
    REFERENCES pc_main (id)
    ON DELETE SET NULL,
  companion_id INTEGER
    REFERENCES companion_main (id)
    ON DELETE SET NULL,
  npc_id INTEGER
    REFERENCES npc_main (id)
    ON DELETE SET NULL,
  faction_id INTEGER
    REFERENCES factions (id)
    ON DELETE SET NULL,
  UNIQUE (item_id),
  CHECK (
    (pc_id IS NOT NULL AND companion_id IS NULL AND npc_id IS NULL AND faction_id IS NULL)
    OR (pc_id IS NULL AND companion_id IS NOT NULL AND npc_id IS NULL AND faction_id IS NULL)
    OR (pc_id IS NULL AND companion_id IS NULL AND npc_id IS NOT NULL AND faction_id IS NULL)
    OR (pc_id IS NULL AND companion_id IS NULL AND npc_id IS NULL AND faction_id IS NOT NULL)
    OR (pc_id IS NULL AND companion_id IS NULL AND npc_id IS NULL AND faction_id IS NULL)
  )
);
CREATE TABLE IF NOT EXISTS item_quests (
  id SERIAL PRIMARY KEY,
  item_id INTEGER NOT NULL
    REFERENCES items (id)
    ON DELETE CASCADE,
  quest_id INTEGER NOT NULL
    REFERENCES quests (id)
    ON DELETE CASCADE,
  UNIQUE (item_id, quest_id)
);
CREATE TABLE IF NOT EXISTS item_gallery (
  id SERIAL PRIMARY KEY,
  item_id INTEGER NOT NULL
    REFERENCES items (id)
    ON DELETE CASCADE,
  image_url TEXT DEFAULT NULL,
  alt VARCHAR(255) NOT NULL DEFAULT 'Item Placeholder Image',
  is_imported BOOLEAN NOT NULL DEFAULT FALSE,
  is_main BOOLEAN NOT NULL DEFAULT FALSE,
  is_hover BOOLEAN NOT NULL DEFAULT FALSE,
  is_tall BOOLEAN NOT NULL DEFAULT FALSE
);
-- END ITEMS TABLES BLOCK

-- START SESSION LOGS TABLE BLOCK
-- This table is for tracking what happens in each session. This allows the tracking of important events, and being fun to reread/recall past adventures.
CREATE TABLE IF NOT EXISTS session_logs (
  id SERIAL PRIMARY KEY,
  campaign_id INTEGER NOT NULL
    REFERENCES campaigns (id)
    ON DELETE RESTRICT,
  book_number INTEGER NOT NULL DEFAULT 1,
  log_type VARCHAR(50) NOT NULL DEFAULT 'Session Summary', -- session summary, quest recap, npc spotlight, etc.
  session_number INTEGER NOT NULL,
  title VARCHAR(255) NOT NULL,
  time_span VARCHAR(255),
  session_date DATE,
  session_summary TEXT,
  pinned BOOLEAN NOT NULL DEFAULT FALSE,
  UNIQUE (campaign_id, book_number, session_number)
);
CREATE TABLE IF NOT EXISTS session_log_paragraphs (
  id SERIAL PRIMARY KEY,
  session_log_id INTEGER NOT NULL
    REFERENCES session_logs (id)
    ON DELETE CASCADE,
  user_id INTEGER
    REFERENCES users (id)
    ON DELETE SET NULL,
  paragraph_order INTEGER NOT NULL,
  paragraph_text TEXT NOT NULL,
  UNIQUE (session_log_id, paragraph_order)
);
CREATE TABLE IF NOT EXISTS session_log_gallery (
  id SERIAL PRIMARY KEY,
  session_log_id INTEGER NOT NULL
    REFERENCES session_logs (id)
    ON DELETE CASCADE,
  image_url TEXT DEFAULT NULL,
  alt VARCHAR(255) NOT NULL DEFAULT 'Session Image',
  is_imported BOOLEAN NOT NULL DEFAULT FALSE,
  is_main BOOLEAN NOT NULL DEFAULT FALSE,
  is_hover BOOLEAN NOT NULL DEFAULT FALSE,
  is_tall BOOLEAN NOT NULL DEFAULT FALSE
);
-- END SESSION LOGS TABLE BLOCK

-- Seed roles (idempotent - safe to run multiple times)
INSERT INTO roles (role_name, role_description)
VALUES
('user', 'Player or user with basic access'),
('gm_admin', 'Game Master or site admin with full system access')
ON CONFLICT (role_name) DO NOTHING;

-- Set the default value of role_id to the 'user' role so new inserts without role_id are handled automatically
DO $$
DECLARE
    user_role_id INTEGER;
BEGIN
    SELECT id INTO user_role_id FROM roles WHERE role_name = 'user';
    IF user_role_id IS NOT NULL THEN
        EXECUTE format(
            'ALTER TABLE users ALTER COLUMN role_id SET DEFAULT %s',
            user_role_id
        );
    END IF;
END $$;

-- Update existing users without a role to default 'user' role
DO $$
DECLARE
    user_role_id INTEGER;
BEGIN
    SELECT id INTO user_role_id FROM roles WHERE role_name = 'user';
    IF user_role_id IS NOT NULL THEN
        UPDATE users 
        SET role_id = user_role_id 
        WHERE role_id IS NULL;
    END IF;
END $$;

-- START INDEX BLOCK
-- INDEXES FOR ROLES / USERS
CREATE INDEX idx_users_role_id ON users (role_id);

-- INDEXES FOR CAMPAIGN NOTES
CREATE INDEX idx_campaign_notes_user_id ON campaign_notes (user_id);
CREATE INDEX idx_campaign_notes_campaign_id ON campaign_notes (campaign_id);

-- INDEXES FOR PCs, NPCs, COMPANIONS, Factions, Etc.
-- INDEXES FOR PC MAIN
CREATE INDEX idx_pc_user_id ON pc_main (id);
CREATE INDEX idx_pc_main_campaign_id ON pc_main (campaign_id);
CREATE INDEX idx_pc_main_active_status_id ON pc_main (active_status_id);
CREATE INDEX idx_pc_main_race_id ON pc_main (race_id);
-- COMPANION MAIN
CREATE INDEX idx_companion_main_user_id ON companion_main (user_id);
CREATE INDEX idx_companion_main_pc_id ON companion_main (pc_id);
CREATE INDEX idx_companion_main_campaign_id ON companion_main (campaign_id);
CREATE INDEX idx_companion_main_active_status_id ON companion_main (active_status_id);
CREATE INDEX idx_companion_main_race_id ON companion_main (race_id);
-- NPC MAIN
CREATE INDEX idx_npc_main_campaign_id ON npc_main (campaign_id);
CREATE INDEX idx_npc_main_active_status_id ON npc_main (active_status_id);
CREATE INDEX idx_npc_main_race_id ON npc_main (race_id);
-- FACTIONS
CREATE INDEX idx_factions_campaign_id ON factions (campaign_id);
CREATE INDEX idx_factions_active_status_id ON factions (active_status_id);

-- INDEXES FOR QUESTS
CREATE INDEX idx_quests_campaign_id ON quests (campaign_id);
CREATE INDEX idx_quests_active ON quests (active);
CREATE INDEX idx_quests_completed ON quests (completed);
CREATE INDEX idx_npc_quests_npc_id ON npc_quests (npc_id);
CREATE INDEX idx_npc_quests_quest_id ON npc_quests (quest_id);
CREATE INDEX idx_faction_quests_faction_id ON faction_quests (faction_id);
CREATE INDEX idx_faction_quests_quest_id ON faction_quests (quest_id);
CREATE INDEX idx_item_quests_item_id ON item_quests (item_id);
CREATE INDEX idx_item_quests_quest_id ON item_quests (quest_id);

-- INDEXES FOR ACHIEVEMENTS
CREATE INDEX idx_achievements_campaign_id ON achievements (campaign_id);
CREATE INDEX idx_achievements_category ON achievements (category);
CREATE INDEX idx_pc_achievements_pc_id ON pc_achievements (pc_id);
CREATE INDEX idx_pc_achievements_achievement_id ON pc_achievements (achievement_id);
CREATE INDEX idx_companion_achievements_companion_id ON companion_achievements (companion_id);
CREATE INDEX idx_companion_achievements_achievement_id ON companion_achievements (achievement_id);

-- INDEXES FOR TITLES
CREATE INDEX idx_titles_rank_id ON titles (rank_id);
CREATE INDEX idx_pc_titles_pc_id ON pc_titles (pc_id);
CREATE INDEX idx_pc_titles_title_id ON pc_titles (title_id);
CREATE INDEX idx_companion_titles_companion_id ON companion_titles (companion_id);
CREATE INDEX idx_companion_titles_title_id ON companion_titles (title_id);
CREATE INDEX idx_npc_titles_npc_id ON npc_titles (npc_id);
CREATE INDEX idx_npc_titles_title_id ON npc_titles (title_id);
CREATE INDEX idx_pc_titles_location ON pc_titles (title_location);
CREATE INDEX idx_npc_titles_location ON npc_titles (title_location);
CREATE INDEX idx_companion_titles_location ON companion_titles (title_location);


-- INDEXES FOR SOCIAL
CREATE INDEX idx_pc_social_pc_id ON pc_social (pc_id);
CREATE INDEX idx_companion_social_companion_id ON companion_social (companion_id);
CREATE INDEX idx_npc_social_npc_id ON npc_social (npc_id);
CREATE INDEX idx_faction_social_faction_id ON faction_social (faction_id);

-- INDEXES FOR GALLERIES
CREATE INDEX idx_pc_gallery_pc_id ON pc_gallery (pc_id);
CREATE INDEX idx_companion_gallery_companion_id ON companion_gallery (companion_id);
CREATE INDEX idx_npc_gallery_npc_id ON npc_gallery (npc_id);
CREATE INDEX idx_faction_gallery_faction_id ON faction_gallery (faction_id);
CREATE INDEX idx_item_gallery_item_id ON item_gallery (item_id);
CREATE INDEX idx_session_log_gallery_log_id ON session_log_gallery (session_log_id);

-- INDEXES FOR CLASSES
CREATE INDEX idx_pc_class_pc_id ON pc_class (pc_id);
CREATE INDEX idx_pc_class_class_id ON pc_class (class_id);
CREATE INDEX idx_pc_class_archetype_pc_class_id ON pc_class_archetype (pc_class_id);
CREATE INDEX idx_companion_class_companion_id ON companion_class (companion_id);
CREATE INDEX idx_companion_class_class_id ON companion_class (class_id);
CREATE INDEX idx_companion_class_archetype_companion_class_id ON companion_class_archetype (companion_class_id);

-- INDEXES FOR RELIGION
CREATE INDEX idx_pc_religion_pc_id ON pc_religion (pc_id);
CREATE INDEX idx_pc_religion_religion_id ON pc_religion (religion_id);
CREATE INDEX idx_companion_religion_companion_id ON companion_religion (companion_id);
CREATE INDEX idx_companion_religion_religion_id ON companion_religion (religion_id);
CREATE INDEX idx_npc_religion_npc_id ON npc_religion (npc_id);
CREATE INDEX idx_npc_religion_religion_id ON npc_religion (religion_id);

-- INDEXES FOR LANGUAGE
CREATE INDEX idx_pc_language_pc_id ON pc_language (pc_id);
CREATE INDEX idx_pc_language_language_id ON pc_language (language_id);
CREATE INDEX idx_companion_language_companion_id ON companion_language (companion_id);
CREATE INDEX idx_companion_language_language_id ON companion_language (language_id);
CREATE INDEX idx_npc_language_npc_id ON npc_language (npc_id);
CREATE INDEX idx_npc_language_language_id ON npc_language (language_id);

-- INDEXES FOR SPEED
CREATE INDEX idx_pc_speed_pc_id ON pc_speed (pc_id);
CREATE INDEX idx_pc_speed_speed_id ON pc_speed (speed_id);
CREATE INDEX idx_companion_speed_companion_id ON companion_speed (companion_id);
CREATE INDEX idx_companion_speed_speed_id ON companion_speed (speed_id);

-- INDEXES FOR ATTRIBUTES
CREATE INDEX idx_pc_attributes_pc_id ON pc_attributes (pc_id);
CREATE INDEX idx_companion_attributes_companion_id ON companion_attributes (companion_id);

-- INDEXES FOR STATS
CREATE INDEX idx_pc_stats_pc_id ON pc_stats (pc_id);
CREATE INDEX idx_companion_stats_companion_id ON companion_stats (companion_id);
CREATE INDEX idx_npc_stats_npc_id ON npc_stats (npc_id);

-- INDEXES FOR SKILLS
CREATE INDEX idx_pc_skills_pc_id ON pc_skills (pc_id);
CREATE INDEX idx_companion_skills_companion_id ON companion_skills (companion_id);

-- INDEXES FOR SCARS
CREATE INDEX idx_pc_scars_pc_id ON pc_scars (pc_id);
CREATE INDEX idx_companion_scars_companion_id ON companion_scars (companion_id);

-- INDEXES FOR ATTITUDE
CREATE INDEX idx_npc_attitude_npc_id ON npc_attitude (npc_id);
CREATE INDEX idx_npc_attitude_attitude_id ON npc_attitude (attitude_id);
CREATE INDEX idx_faction_attitude_faction_id ON faction_attitude (faction_id);
CREATE INDEX idx_faction_attitude_attitude_id ON faction_attitude (attitude_id);

-- FACTION MEMBERSHIP INDEXES
CREATE INDEX idx_faction_npcs_faction_id ON faction_npcs (faction_id);
CREATE INDEX idx_faction_npcs_npc_id ON faction_npcs (npc_id);
CREATE INDEX idx_faction_pcs_faction_id ON faction_pcs (faction_id);
CREATE INDEX idx_faction_pcs_pc_id ON faction_pcs (pc_id);
CREATE INDEX idx_faction_companions_faction_id ON faction_companions (faction_id);
CREATE INDEX idx_faction_companions_companion_id ON faction_companions (companion_id);

-- MERCHANT INDEXES
CREATE INDEX idx_merchants_npc_id ON merchants (npc_id);
CREATE INDEX idx_merchants_faction_id ON merchants (faction_id);
CREATE INDEX idx_merchants_active_status_id ON merchants (active_status_id);
CREATE INDEX idx_merchant_details_merchant_id ON merchant_details (merchant_id);
CREATE INDEX idx_merchant_inventory_merchant_id ON merchant_inventory (merchant_id);
CREATE INDEX idx_merchant_inventory_item_id ON merchant_inventory (item_id);

-- ITEM INDEXES
CREATE INDEX idx_items_campaign_id ON items (campaign_id);
CREATE INDEX idx_items_active_status_id ON items (active_status_id);
CREATE INDEX idx_items_type ON items (item_type);

-- ITEM OWNERSHIP INDEXES
CREATE INDEX idx_item_owners_item_id ON item_owners (item_id);
CREATE INDEX idx_item_owners_pc_id ON item_owners (pc_id);
CREATE INDEX idx_item_owners_companion_id ON item_owners (companion_id);
CREATE INDEX idx_item_owners_npc_id ON item_owners (npc_id);
CREATE INDEX idx_item_owners_faction_id ON item_owners (faction_id);

-- SESSION INDEXES
CREATE INDEX idx_session_logs_campaign_id ON session_logs (campaign_id);
CREATE INDEX idx_session_logs_book_session ON session_logs (book_number, session_number);
CREATE INDEX idx_session_log_paragraphs_log_id ON session_log_paragraphs (session_log_id);
CREATE INDEX idx_session_log_paragraphs_user_id ON session_log_paragraphs (user_id);
-- END INDEX BLOCK
