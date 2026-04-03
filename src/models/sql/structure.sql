-- Database table structure
-- First, Create the tables if they don't exist,

-- Roles table for role-based access control
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    role_description TEXT
);

-- Users table for registration system
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role_id INTEGER REFERENCES roles(id) ON UPDATE CASCADE ON DELETE SET NULL DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for organizing data by campaigns. Multiple users per campaign and vice versa, and campaigns are optional to allow for one-offs.
-- PCs can be associated with any campaign, or none, but only one at a time.
CREATE TABLE IF NOT EXISTS campaigns (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT
);

-- General notes for players and GMs, one-to-many as each note is separate but each user may have multiple notes.
CREATE TABLE IF NOT EXISTS campaign_notes (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    campaign_id INTEGER REFERENCES campaigns(id) ON DELETE SET NULL,
    note_title VARCHAR(255) NOT NULL,
    note_content TEXT NOT NULL,
    UNIQUE (user_id, campaign_id, note_title),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- General table for tracking active and past quests, one-to-many as each quest is separate but campaigns may have multiple quests.
CREATE TABLE IF NOT EXISTS quests (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER REFERENCES campaigns(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (campaign_id, name),
    session_number INTEGER NOT NULL DEFAULT 1
);

-- START GLOBAL TABLES BLOCK for references, one-to-many.
CREATE TABLE IF NOT EXISTS active_status (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS attitude (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS classes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS race (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS religions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS languages (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS speed (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS achievements (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER REFERENCES campaigns(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT,
    UNIQUE (name, campaign_id),
    session_number INTEGER NOT NULL DEFAULT 1
);
CREATE TABLE IF NOT EXISTS titles (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER REFERENCES campaigns(id) ON DELETE SET NULL,
    name VARCHAR(255) UNIQUE NOT NULL,
    description TEXT
);
-- END GLOBAL TABLES BLOCK

-- START PC TABLES BLOCK 
-- Table for player characters (PCs), each player may build multiple, but may only have one active at a time.
-- All other PC-related tables reference this one via pc_main(id).
CREATE TABLE IF NOT EXISTS pc_main (
    id SERIAL PRIMARY KEY,
    owner INTEGER REFERENCES users(id) ON DELETE SET NULL,
    campaign_id INTEGER REFERENCES campaigns(id) ON DELETE SET NULL,
    active_status_id INTEGER REFERENCES active_status(id) ON DELETE RESTRICT,
    race_id INTEGER REFERENCES race(id) ON DELETE RESTRICT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    race_traits TEXT,
    retired_reason TEXT,
    death_cause TEXT,
    end_session INTEGER DEFAULT NULL,
    UNIQUE (owner, campaign_id, name),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Social Biography table for roleplaying, all details public except secrets.
CREATE TABLE IF NOT EXISTS pc_social (
    id SERIAL PRIMARY KEY,
    pc_id INTEGER REFERENCES pc_main(id) ON DELETE CASCADE,
    appearance TEXT,
    background TEXT,
    family TEXT,
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
    pc_id INTEGER REFERENCES pc_main(id) ON DELETE CASCADE,
    imported BOOLEAN NOT NULL DEFAULT FALSE,
    main BOOLEAN NOT NULL DEFAULT FALSE,
    hover BOOLEAN NOT NULL DEFAULT FALSE,
    image_url TEXT DEFAULT NULL
);

-- PC tables that interact with global tables, one-to-many as each entry is separate but PCs may have multiple entries (multiple classes, religions, languages, etc.)
CREATE TABLE IF NOT EXISTS pc_class (
    id SERIAL PRIMARY KEY,
    pc_id INTEGER REFERENCES pc_main(id) ON DELETE CASCADE,
    class_id INTEGER REFERENCES classes(id) ON DELETE RESTRICT,
    level INTEGER NOT NULL DEFAULT 1,
    UNIQUE (pc_id, class_id)
);
CREATE TABLE IF NOT EXISTS pc_class_archetype (
    id SERIAL PRIMARY KEY,
    pc_class_id INTEGER REFERENCES pc_class(id) ON DELETE CASCADE,
    archetype_name VARCHAR(255) NOT NULL,
    UNIQUE (pc_class_id, archetype_name)
);
CREATE TABLE IF NOT EXISTS pc_religion (
    id SERIAL PRIMARY KEY,
    pc_id INTEGER REFERENCES pc_main(id) ON DELETE CASCADE,
    religion_id INTEGER REFERENCES religions(id) ON DELETE RESTRICT,
    notes TEXT,
    secrets TEXT DEFAULT NULL,
    UNIQUE (pc_id, religion_id)
);
CREATE TABLE IF NOT EXISTS pc_language (
    id SERIAL PRIMARY KEY,
    pc_id INTEGER REFERENCES pc_main(id) ON DELETE CASCADE,
    language_id INTEGER REFERENCES languages(id) ON DELETE RESTRICT,
    UNIQUE (pc_id, language_id)
);
CREATE TABLE IF NOT EXISTS pc_speed (
    id SERIAL PRIMARY KEY,
    pc_id INTEGER REFERENCES pc_main(id) ON DELETE CASCADE,
    speed_id INTEGER REFERENCES speed(id) ON DELETE RESTRICT,
    speed_value INTEGER NOT NULL DEFAULT 30,
    UNIQUE (pc_id, speed_id)
);
CREATE TABLE IF NOT EXISTS pc_achievements (
    id SERIAL PRIMARY KEY,
    pc_id INTEGER REFERENCES pc_main(id) ON DELETE CASCADE,
    achievement_id INTEGER REFERENCES achievements(id) ON DELETE RESTRICT,
    killing_blow BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (pc_id, achievement_id)
);
CREATE TABLE IF NOT EXISTS pc_titles (
    id SERIAL PRIMARY KEY,
    pc_id INTEGER REFERENCES pc_main(id) ON DELETE CASCADE,
    title_id INTEGER REFERENCES titles(id) ON DELETE RESTRICT,
    UNIQUE (pc_id, title_id),
    received_session INTEGER NOT NULL DEFAULT 1
);

-- Tables for quick reference of core stats, one-to-one relationships with pc_main, enforced by UNIQUE constraint on pc_id.
CREATE TABLE IF NOT EXISTS pc_attributes (
    id SERIAL PRIMARY KEY,
    pc_id INTEGER REFERENCES pc_main(id) ON DELETE CASCADE,
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
    pc_id INTEGER REFERENCES pc_main(id) ON DELETE CASCADE,
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
    pc_id INTEGER REFERENCES pc_main(id) ON DELETE CASCADE,
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
    pc_id INTEGER REFERENCES pc_main(id) ON DELETE CASCADE,
    scar_cause TEXT NOT NULL DEFAULT 'Unknown',
    scar_description TEXT,
    UNIQUE (pc_id, scar_description),
    session_number INTEGER NOT NULL DEFAULT 1
);
-- END PC TABLES BLOCK

-- START COMPANION TABLES BLOCK
-- Companions are NPCs that are closely associated with a PC, such as a familiar or animal companion.
CREATE TABLE IF NOT EXISTS companion_main (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    pc_id INTEGER REFERENCES pc_main(id) ON DELETE CASCADE,
    campaign_id INTEGER REFERENCES campaigns(id) ON DELETE SET NULL,
    active_status_id INTEGER REFERENCES active_status(id) ON DELETE RESTRICT,
    race_id INTEGER REFERENCES race(id) ON DELETE RESTRICT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    race_traits TEXT,
    death_cause TEXT,
    end_session INTEGER DEFAULT NULL,
    UNIQUE (pc_id, name),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS companion_class (
    id SERIAL PRIMARY KEY,
    companion_id INTEGER REFERENCES companion_main(id) ON DELETE CASCADE,
    class_id INTEGER REFERENCES classes(id) ON DELETE RESTRICT,
    level INTEGER NOT NULL DEFAULT 1,
    UNIQUE (companion_id, class_id)
);
CREATE TABLE IF NOT EXISTS companion_class_archetype (
    id SERIAL PRIMARY KEY,
    companion_class_id INTEGER REFERENCES companion_class(id) ON DELETE CASCADE,
    archetype_name VARCHAR(255) NOT NULL,
    UNIQUE (companion_class_id, archetype_name)
);
CREATE TABLE IF NOT EXISTS companion_social (
    id SERIAL PRIMARY KEY,
    companion_id INTEGER REFERENCES companion_main(id) ON DELETE CASCADE,
    appearance TEXT,
    background TEXT,
    extra_details TEXT,
    secrets TEXT,
    UNIQUE (companion_id)
);
CREATE TABLE IF NOT EXISTS companion_gallery (
    id SERIAL PRIMARY KEY,
    companion_id INTEGER REFERENCES companion_main(id) ON DELETE CASCADE,
    imported BOOLEAN NOT NULL DEFAULT FALSE,
    main BOOLEAN NOT NULL DEFAULT FALSE,
    hover BOOLEAN NOT NULL DEFAULT FALSE,
    image_url TEXT DEFAULT NULL
);
CREATE TABLE IF NOT EXISTS companion_speed (
    id SERIAL PRIMARY KEY,
    companion_id INTEGER REFERENCES companion_main(id) ON DELETE CASCADE,
    speed_id INTEGER REFERENCES speed(id) ON DELETE RESTRICT,
    speed_value INTEGER NOT NULL DEFAULT 30,
    UNIQUE (companion_id, speed_id)
);
CREATE TABLE IF NOT EXISTS companion_religion (
    id SERIAL PRIMARY KEY,
    companion_id INTEGER REFERENCES companion_main(id) ON DELETE CASCADE,
    religion_id INTEGER REFERENCES religions(id) ON DELETE RESTRICT,
    notes TEXT,
    secrets TEXT DEFAULT NULL,
    UNIQUE (companion_id, religion_id)
);
CREATE TABLE IF NOT EXISTS companion_language (
    id SERIAL PRIMARY KEY,
    companion_id INTEGER REFERENCES companion_main(id) ON DELETE CASCADE,
    language_id INTEGER REFERENCES languages(id) ON DELETE RESTRICT,
    UNIQUE (companion_id, language_id)
);
CREATE TABLE IF NOT EXISTS companion_achievements (
    id SERIAL PRIMARY KEY,
    companion_id INTEGER REFERENCES companion_main(id) ON DELETE CASCADE,
    achievement_id INTEGER REFERENCES achievements(id) ON DELETE RESTRICT,
    killing_blow BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (companion_id, achievement_id)
);
CREATE TABLE IF NOT EXISTS companion_titles (
    id SERIAL PRIMARY KEY,
    companion_id INTEGER REFERENCES companion_main(id) ON DELETE CASCADE,
    title_id INTEGER REFERENCES titles(id) ON DELETE RESTRICT,
    UNIQUE (companion_id, title_id),
    received_session INTEGER NOT NULL DEFAULT 1
);
CREATE TABLE IF NOT EXISTS companion_scars (
    id SERIAL PRIMARY KEY,
    companion_id INTEGER REFERENCES companion_main(id) ON DELETE CASCADE,
    scar_cause TEXT NOT NULL DEFAULT 'Unknown',
    scar_description TEXT,
    UNIQUE (companion_id, scar_description),
    session_number INTEGER NOT NULL DEFAULT 1
);
CREATE TABLE IF NOT EXISTS companion_attributes (
    id SERIAL PRIMARY KEY,
    companion_id INTEGER REFERENCES companion_main(id) ON DELETE CASCADE,
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
    companion_id INTEGER REFERENCES companion_main(id) ON DELETE CASCADE,
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
    companion_id INTEGER REFERENCES companion_main(id) ON DELETE CASCADE,
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
    campaign_id INTEGER REFERENCES campaigns(id) ON DELETE SET NULL,
    active_status_id INTEGER REFERENCES active_status(id) ON DELETE RESTRICT,
    race_id INTEGER REFERENCES race(id) ON DELETE RESTRICT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    secrets TEXT,
    death_cause TEXT,
    retired_reason TEXT,
    start_session INTEGER NOT NULL DEFAULT 1,
    end_session INTEGER DEFAULT NULL,
    UNIQUE (campaign_id, name),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS npc_religion (
    id SERIAL PRIMARY KEY,
    npc_id INTEGER REFERENCES npc_main(id) ON DELETE CASCADE,
    religion_id INTEGER REFERENCES religions(id) ON DELETE RESTRICT,
    notes TEXT,
    secrets TEXT DEFAULT NULL,
    UNIQUE (npc_id, religion_id)
);
CREATE TABLE IF NOT EXISTS npc_titles (
    id SERIAL PRIMARY KEY,
    npc_id INTEGER REFERENCES npc_main(id) ON DELETE CASCADE,
    title_id INTEGER REFERENCES titles(id) ON DELETE RESTRICT,
    UNIQUE (npc_id, title_id),
    received_session INTEGER NOT NULL DEFAULT 1
);
-- NPC's have changing attitudes towards the PC's which can be tracked here. Each NPC can only have one attitude at a time.
CREATE TABLE IF NOT EXISTS npc_attitude (
    id SERIAL PRIMARY KEY,
    npc_id INTEGER REFERENCES npc_main(id) ON DELETE CASCADE,
    attitude_id INTEGER REFERENCES attitude(id) ON DELETE RESTRICT,
    favored_pc INTEGER REFERENCES pc_main(id) ON DELETE SET NULL,
    progress_made INTEGER NOT NULL DEFAULT 0,
    progress_threshold INTEGER NOT NULL DEFAULT 10,
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
    npc_id INTEGER REFERENCES npc_main(id) ON DELETE CASCADE,
    appearance TEXT,
    background TEXT,
    extra_details TEXT,
    secrets TEXT,
    UNIQUE (npc_id)
);
CREATE TABLE IF NOT EXISTS npc_quests (
    id SERIAL PRIMARY KEY,
    npc_id INTEGER REFERENCES npc_main(id) ON DELETE CASCADE,
    quest_id INTEGER REFERENCES quests(id) ON DELETE RESTRICT,
    UNIQUE (npc_id, quest_id)
);
CREATE TABLE IF NOT EXISTS npc_gallery (
    id SERIAL PRIMARY KEY,
    npc_id INTEGER REFERENCES npc_main(id) ON DELETE CASCADE,
    imported BOOLEAN NOT NULL DEFAULT FALSE,
    main BOOLEAN NOT NULL DEFAULT FALSE,
    hover BOOLEAN NOT NULL DEFAULT FALSE,
    image_url TEXT DEFAULT NULL
);
CREATE TABLE IF NOT EXISTS npc_language (
    id SERIAL PRIMARY KEY,
    npc_id INTEGER REFERENCES npc_main(id) ON DELETE CASCADE,
    language_id INTEGER REFERENCES languages(id) ON DELETE RESTRICT,
    UNIQUE (npc_id, language_id)
);
CREATE TABLE IF NOT EXISTS npc_stats (
    id SERIAL PRIMARY KEY,
    npc_id INTEGER REFERENCES npc_main(id) ON DELETE CASCADE,
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
    campaign_id INTEGER REFERENCES campaigns(id) ON DELETE SET NULL,
    active_status_id INTEGER REFERENCES active_status(id) ON DELETE RESTRICT,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL,
    description TEXT,
    secrets TEXT,
    death_cause TEXT,
    retired_reason TEXT,
    start_session INTEGER NOT NULL DEFAULT 1,
    end_session INTEGER DEFAULT NULL,
    UNIQUE (campaign_id, name)
);
CREATE TABLE IF NOT EXISTS faction_social (
    id SERIAL PRIMARY KEY,
    faction_id INTEGER REFERENCES factions(id) ON DELETE CASCADE,
    appearance TEXT,
    background TEXT,
    extra_details TEXT,
    secrets TEXT,
    UNIQUE (faction_id)
);
CREATE TABLE IF NOT EXISTS faction_attitude (
    id SERIAL PRIMARY KEY,
    faction_id INTEGER REFERENCES factions(id) ON DELETE CASCADE,
    attitude_id INTEGER REFERENCES attitude(id) ON DELETE RESTRICT,
    favored_pc INTEGER REFERENCES pc_main(id) ON DELETE SET NULL,
    progress_made INTEGER NOT NULL DEFAULT 0,
    progress_threshold INTEGER NOT NULL DEFAULT 10,
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
    faction_id INTEGER REFERENCES factions(id) ON DELETE CASCADE,
    quest_id INTEGER REFERENCES quests(id) ON DELETE RESTRICT,
    UNIQUE (faction_id, quest_id)
);
CREATE TABLE IF NOT EXISTS faction_gallery (
    id SERIAL PRIMARY KEY,
    faction_id INTEGER REFERENCES factions(id) ON DELETE CASCADE,
    imported BOOLEAN NOT NULL DEFAULT FALSE,
    main BOOLEAN NOT NULL DEFAULT FALSE,
    hover BOOLEAN NOT NULL DEFAULT FALSE,
    image_url TEXT DEFAULT NULL
);
CREATE TABLE IF NOT EXISTS faction_npcs (
    id SERIAL PRIMARY KEY,
    faction_id INTEGER REFERENCES factions(id) ON DELETE CASCADE,
    npc_id INTEGER REFERENCES npc_main(id) ON DELETE CASCADE,
    UNIQUE (faction_id, npc_id)
);
CREATE TABLE IF NOT EXISTS faction_pcs (
    id SERIAL PRIMARY KEY,
    faction_id INTEGER REFERENCES factions(id) ON DELETE CASCADE,
    pc_id INTEGER REFERENCES pc_main(id) ON DELETE CASCADE,
    UNIQUE (faction_id, pc_id)
);
CREATE TABLE IF NOT EXISTS faction_companions (
    id SERIAL PRIMARY KEY,
    faction_id INTEGER REFERENCES factions(id) ON DELETE CASCADE,
    companion_id INTEGER REFERENCES companion_main(id) ON DELETE CASCADE,
    UNIQUE (faction_id, companion_id)
);
-- END FACTIONS TABLES BLOCK

-- START POLYMORPHIC MERCHANTS TABLE BLOCK
-- Both NPCs and Factions can be merchants, so this table uses a polymorphic association to link to either one. Each merchant can have multiple items for sale.
CREATE TABLE IF NOT EXISTS merchants (
    id SERIAL PRIMARY KEY,
    npc_id INTEGER REFERENCES npc_main(id) ON DELETE CASCADE,
    faction_id INTEGER REFERENCES factions(id) ON DELETE CASCADE,
    UNIQUE (npc_id),
    UNIQUE (faction_id),
    CHECK (
        (npc_id IS NOT NULL AND faction_id IS NULL) OR
        (npc_id IS NULL AND faction_id IS NOT NULL)
    )
);
-- Merchant details, including the types of things they sell, how much they can carry, ect. One to one relationship with merchants.
CREATE TABLE IF NOT EXISTS merchant_details (
    id SERIAL PRIMARY KEY,
    merchant_id INTEGER REFERENCES merchants(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,
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
-- For unique or table-generated item inventories, one to many relationship with merchants.
CREATE TABLE IF NOT EXISTS merchant_inventory (
    id SERIAL PRIMARY KEY,
    merchant_id INTEGER REFERENCES merchants(id) ON DELETE CASCADE,
    item_name VARCHAR(255) NOT NULL,
    item_description TEXT,
    item_price INTEGER NOT NULL DEFAULT 50,
    item_quantity INTEGER NOT NULL DEFAULT 1,
    UNIQUE (merchant_id, item_name)
);
-- END POLYMORPHIC MERCHANTS TABLE BLOCK

-- Seed roles (idempotent - safe to run multiple times)
INSERT INTO roles (role_name, role_description) 
VALUES 
    ('gm_admin', 'Game Master or site admin with full system access'),
    ('user', 'Player or user with basic access')
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