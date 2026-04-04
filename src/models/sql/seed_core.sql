-- Database seed file for existing data and initial setup

BEGIN;

-- SEED GLOBAL LOOKUP TABLES
-- Seed active_status (idempotent - safe to run multiple times)
INSERT INTO active_status (id, name)
  VALUES
    (1, 'PENDING')
  ON CONFLICT (id) DO NOTHING;
INSERT INTO active_status (name)
  VALUES
    ('Active'),
    ('Retired'),
    ('Deceased')
  ON CONFLICT (name) DO NOTHING;

-- Seed attitude (idempotent - safe to run multiple times)
INSERT INTO attitude (id, name)
  VALUES
    (1, 'Hostile'),
    (2, 'Unfriendly'),
    (3, 'Neutral'),
    (4, 'Friendly'),
    (5, 'Helpful'),
    (6, 'Indifferent')
  ON CONFLICT (id) DO NOTHING;

-- Seed speeds (idempotent - safe to run multiple times)
INSERT INTO speed (id, name)
  VALUES
    (1, 'Base')
  ON CONFLICT (id) DO NOTHING;
INSERT INTO speed (name)
  VALUES
    ('Climb'),
    ('Swim'),
    ('Fly'),
    ('Burrow')
  ON CONFLICT (name) DO NOTHING;

-- Seed classes, Reserve ID 1 for Unknown
INSERT INTO classes (id, name, source)
  VALUES
    (1, 'Unknown', 'Core')
  ON CONFLICT (id) DO NOTHING;
-- Core Rulebook classes
INSERT INTO classes (name, source, class_type, magic_type, caster_spontaneous, has_companion)
  VALUES
    ('Barbarian', 'Core', 'Martial', NULL, FALSE, FALSE),
    ('Bard', 'Core', 'Hybrid(s)', 'Arcane', TRUE, FALSE),
    ('Cleric', 'Core', 'Magic', 'Divine', FALSE, FALSE),
    ('Druid', 'Core', 'Magic', 'Primal', FALSE, TRUE),
    ('Fighter', 'Core', 'Martial', NULL, FALSE, FALSE),
    ('Monk', 'Core', 'Martial', NULL, FALSE, FALSE),
    ('Paladin', 'Core', 'Hybrid(m)', 'Divine', FALSE, TRUE),
    ('Ranger', 'Core', 'Hybrid(m)', 'Divine', FALSE, TRUE),
    ('Rogue', 'Core', 'Skill', NULL, FALSE, FALSE),
    ('Sorcerer', 'Core', 'Magic', 'Arcane', TRUE, FALSE),
    ('Wizard', 'Core', 'Magic', 'Arcane', FALSE, TRUE)
  ON CONFLICT (name) DO NOTHING;
-- APG classes
INSERT INTO classes (name, source, class_type, magic_type, caster_spontaneous, has_companion)
  VALUES
    ('Alchemist', 'APG', 'Hybrid(s)', 'Alchemical', FALSE, FALSE),
    ('Cavalier', 'APG', 'Martial', NULL, FALSE, TRUE),
    ('Gunslinger', 'APG', 'Martial', NULL, FALSE, FALSE),
    ('Inquisitor', 'APG', 'Hybrid(m)', 'Divine', TRUE, FALSE),
    ('Magus', 'APG', 'Hybrid(m)', 'Arcane', FALSE, FALSE),
    ('Oracle', 'APG', 'Magic', 'Divine', TRUE, FALSE),
    ('Summoner', 'APG', 'Magic', 'Arcane', TRUE, TRUE),
    ('Witch', 'APG', 'Magic', 'Occult', FALSE, TRUE),
    ('Vigilante', 'APG', 'Hybrid(s)', NULL, FALSE, FALSE)
  ON CONFLICT (name) DO NOTHING;
-- Hybrid classes
INSERT INTO classes (name, source, class_type, magic_type, caster_spontaneous, has_companion)
  VALUES
    ('Arcanist', 'ACG', 'Magic', 'Arcane', TRUE, FALSE),
    ('Bloodrager', 'ACG', 'Hybrid(m)', 'Arcane', TRUE, FALSE),
    ('Brawler', 'ACG', 'Martial', NULL, FALSE, FALSE),
    ('Hunter', 'ACG', 'Hybrid(m)', 'Primal', TRUE, TRUE),
    ('Investigator', 'ACG', 'Hybrid(s)', 'Alchemical', FALSE, FALSE),
    ('Shaman', 'ACG', 'Magic', 'Primal', FALSE, TRUE),
    ('Skald', 'ACG', 'Hybrid(3)', 'Arcane', TRUE, FALSE),
    ('Slayer', 'ACG', 'Hybrid(s)', NULL, FALSE, FALSE),
    ('Swashbuckler', 'ACG', 'Martial', NULL, FALSE, FALSE),
    ('Warpriest', 'ACG', 'Hybrid(m)', 'Divine', FALSE, FALSE)
  ON CONFLICT (name) DO NOTHING;
-- Occult classes
INSERT INTO classes (name, source, class_type, magic_type, caster_spontaneous, has_companion)
  VALUES
    ('Kineticist', 'Occult', 'Magic', 'Occult', FALSE, FALSE),
    ('Medium', 'Occult', 'Hybrid(3)', 'Occult', TRUE, FALSE),
    ('Mesmerist', 'Occult', 'Hybrid(s)', 'Occult', TRUE, FALSE),
    ('Occultist', 'Occult', 'Hybrid(3)', 'Occult', TRUE, FALSE),
    ('Psychic', 'Occult', 'Magic', 'Occult', TRUE, FALSE),
    ('Spiritualist', 'Occult', 'Magic', 'Occult', TRUE, TRUE)
  ON CONFLICT (name) DO NOTHING;
-- Alternate classes
INSERT INTO classes (name, source, class_type, magic_type, caster_spontaneous, has_companion)
  VALUES
    ('Antipaladin', 'Alt', 'Hybrid(m)', 'Divine', FALSE, TRUE),
    ('Ninja', 'Alt', 'Skill', NULL, FALSE, FALSE),
    ('Samurai', 'Alt', 'Martial', NULL, FALSE, FALSE)
  ON CONFLICT (name) DO NOTHING;
-- NPC classes
INSERT INTO classes (name, source, class_type)
  VALUES
    ('Adept', 'NPC', 'Magic'),
    ('Aristocrat', 'NPC', 'Skill'),
    ('Commoner', 'NPC', 'Martial'),
    ('Expert', 'NPC', 'Skill'),
    ('Warrior', 'NPC', 'Martial')
  ON CONFLICT (name) DO NOTHING;
-- Other base classes
INSERT INTO classes (name, source, class_type, magic_type, caster_spontaneous, has_companion)
  VALUES
    ('Shifter', 'Other', 'Martial', NULL, FALSE, FALSE),
    ('Vampire Hunter', 'Other', 'Hybrid(3)', 'DIVINE', TRUE, TRUE)
  ON CONFLICT (name) DO NOTHING;
-- Prestige Classes
WITH prestige(name) AS (
  Values
    ('Agent of the Grave'),
    ('Aldori Swordlord'),
    ('Arcane Archer'),
    ('Arcane Trickster'),
    ('Archlord of Nex'),
    ('Argent Dramaturge'),
    ('Asavir'),
    ('Ashavic Dancer'),
    ('Aspis Agent'),
    ('Assassin'),
    ('Balanced Scale of Abadar'),
    ('Battle Herald'),
    ('Bellflower Tiller'),
    ('Blackfire Adept'),
    ('Bloatmage'),
    ('Brewkeeper'),
    ('Brightness Seeker'),
    ('Brother of the Seal'),
    ('Champion of Irori'),
    ('Chernasardo Warden'),
    ('Chevalier'),
    ('Crimson Templar'),
    ('Cyphermage'),
    ('Daggermark Poisoner'),
    ('Daivrat'),
    ('Darechaser'),
    ('Dawnflower Anchorite'),
    ('Dawnflower Dissident'),
    ('Death Slayer'),
    ('Demoniac'),
    ('Devoted Muse'),
    ('Diabolist'),
    ('Divine Scion'),
    ('Dragon Disciple'),
    ('Duelist'),
    ('Eldritch Knight'),
    ('Enchanting Courtesan'),
    ('Envoy of Balance'),
    ('Esoteric Knight'),
    ('Evangelist'),
    ('Exalted'),
    ('Feysworn'),
    ('Genie Binder'),
    ('Golden Legionnaire'),
    ('Gray Corsair'),
    ('Gray Gardener'),
    ('Green Faith Acolyte'),
    ('Halfling Opportunist'),
    ('Harrower'),
    ('Hellknight'),
    ('Hellknight Signifier'),
    ('Heritor Knight'),
    ('Hinterlander'),
    ('Holy Vindicator'),
    ('Horizon Walker'),
    ('Inheritors Crusader'),
    ('Inner Sea Pirate'),
    ('Justicar'),
    ('Knight of Ozem'),
    ('Lantern Bearer'),
    ('Liberator'),
    ('Lion Blade'),
    ('Living Monolith'),
    ('Loremaster'),
    ('Low Templar'),
    ('Magaambyan Arcanist'),
    ('Mammoth Rider'),
    ('Master Chymist'),
    ('Master Spy'),
    ('Mortal Usher'),
    ('Mystery Cultist'),
    ('Nature Warden'),
    ('Noble Scion'),
    ('Pain Taster'),
    ('Pathfinder Chronicler'),
    ('Pathfinder Delver'),
    ('Pathfinder Field Agent'),
    ('Pathfinder Savant'),
    ('Pit Fighter'),
    ('Proctor'),
    ('Prophet of Kalistrade'),
    ('Pure Legion Enforcer'),
    ('Rage Prophet'),
    ('Razmiran Priest'),
    ('Red Mantis Assassin'),
    ('Riftwarden'),
    ('Ritualist'),
    ('Rivethun Emissary'),
    ('Rose Warden'),
    ('Runeguard'),
    ('Sacred Sentinel'),
    ('Sanguine Angel'),
    ('Scar Seeker'),
    ('Sentinel'),
    ('Shackles Pirate'),
    ('Shadowdancer'),
    ('Shieldmarshal'),
    ('Skyseeker'),
    ('Sleepless Detective'),
    ('Soul Warden'),
    ('Souldrinker'),
    ('Sphere Singer'),
    ('Spherewalker'),
    ('Stalwart Defender'),
    ('Stargazer'),
    ('Steel Falcon'),
    ('Storm Kindler'),
    ('Student of Perfection'),
    ('Student of War'),
    ('Tattooed Mystic'),
    ('Technomancer'),
    ('Thuvian Alchemist'),
    ('Twilight Talon'),
    ('Ulfen Guard'),
    ('Umbral Court Agent'),
    ('Veiled Illusionist'),
    ('Westcrown Devil'),
    ('Winter Witch')
  )
  INSERT INTO classes (name, source, class_type)
  SELECT name, 'Prestige', 'Prestige'
  FROM prestige
  ON CONFLICT (name) DO NOTHING;

-- Seed Races, Reserve 1 for Unknown
INSERT INTO race (id, name)
  VALUES
    (1, 'Unknown')
  ON CONFLICT (id) DO NOTHING;
-- Core Races
INSERT INTO race (name, limited)
  VALUES
    ('Human', FALSE),
    ('Dwarf', FALSE),
    ('Elf', FALSE),
    ('Gnome', FALSE),
    ('Halfling', FALSE),
    ('Half-Elf', FALSE),
    ('Half-Orc', FALSE)
  ON CONFLICT (name) DO NOTHING;
-- Standard Races
INSERT INTO race (name)
  VALUES
    ('Catfolk'),
    ('Duergar'),
    ('Gnoll'),
    ('Grippli'),
    ('Goblin'),
    ('Hobgoblin'),
    ('Ifrit'),
    ('Kobold'),
    ('Lizardfolk'),
    ('Monkey Goblin'),
    ('Orc'),
    ('Oread'),
    ('Ratfolk'),
    ('Skinwalker'),
    ('Sylph'),
    ('Triaxian'),
    ('Undine'),
    ('Vanara')
  ON CONFLICT (name) DO NOTHING;
-- Advanced Races
INSERT INTO race (name)
  VALUES
    ('Aasimar'),
    ('Android'),
    ('Dhampir'),
    ('Drow'),
    ('Fetchling'),
    ('Gathlain'),
    ('Ghoran'),
    ('Kasatha'),
    ('Shabti'),
    ('Syrinx'),
    ('Suli'),
    ('Tengu'),
    ('Tiefling'),
    ('Vishkanya'),
    ('Wyrwood'),
    ('Wyvaran')
  ON CONFLICT (name) DO NOTHING;
-- Other Races
INSERT INTO race (name)
  VALUES
    ('Svirfneblin'),
    ('Drider'),
    ('Gargoyle'),
    ('Trox'),
    ('Aquatic Elf'),
    ('Astomoi'),
    ('Caligni'),
    ('Changeling'),
    ('Deep One Hybrid'),
    ('Ganzi'),
    ('Gillmen'),
    ('Kitsune'),
    ('Kuru'),
    ('Merfolk'),
    ('Munavri'),
    ('Nagaji'),
    ('Orang-Pendak'),
    ('Reptoid'),
    ('Samsaran'),
    ('Strix'),
    ('Wayang')
  ON CONFLICT (name) DO NOTHING;



-- =========================
-- RELIGIONS (Golarion core deities)
-- =========================

INSERT INTO religions (id, name) VALUES
(1, 'Unknown')
ON CONFLICT (id) DO NOTHING;

-- Core 20 deities from Golarion (Pathfinder 1e)
INSERT INTO religions (name) VALUES
('Abadar'),
('Asmodeus'),
('Calistria'),
('Cayden Cailean'),
('Desna'),
('Erastil'),
('Gorum'),
('Gozreh'),
('Iomedae'),
('Irori'),
('Lamashtu'),
('Nethys'),
('Norgorber'),
('Pharasma'),
('Rovagug'),
('Sarenrae'),
('Shelyn'),
('Torag'),
('Urgathoa'),
('Zon-Kuthon')
ON CONFLICT (name) DO NOTHING;



-- =========================
-- LANGUAGES (Pathfinder 1e common list)
-- =========================

INSERT INTO languages (id, name) VALUES
(1, 'Unknown')
ON CONFLICT (id) DO NOTHING;

INSERT INTO languages (name) VALUES
('Common'),
('Dwarven'),
('Elven'),
('Gnome'),
('Halfling'),
('Orc'),
('Goblin'),
('Giant'),
('Draconic'),
('Sylvan'),
('Undercommon'),
('Celestial'),
('Abyssal'),
('Infernal'),
('Aquan'),
('Auran'),
('Ignan'),
('Terran')
ON CONFLICT (name) DO NOTHING;