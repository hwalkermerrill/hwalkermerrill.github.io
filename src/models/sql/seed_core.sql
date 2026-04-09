-- Database seed file for existing data and initial setup
BEGIN;

-- START GLOBAL LOOKUP TABLES SEED BLOCK
-- Seed Active_Status (idempotent - safe to run multiple times)
INSERT INTO active_status (id, active_status_name)
VALUES 
  (1, 'Pending'),
  (2, 'Active')
ON CONFLICT (id) DO NOTHING;
SELECT setval('active_status_id_seq', (SELECT MAX(id) FROM active_status));

INSERT INTO active_status (active_status_name)
VALUES 
  ('Retired'),
  ('Deceased')
ON CONFLICT (active_status_name) DO NOTHING;
-- End Active_Status Seeds

-- Seed Attitude (idempotent - safe to run multiple times)
INSERT INTO attitude (id, attitude_name)
VALUES 
  (1, 'Hostile'),
  (2, 'Unfriendly'),
  (3, 'Indifferent'),
  (4, 'Friendly'),
  (5, 'Helpful'),
  (6, 'Locked')
ON CONFLICT (id) DO NOTHING;
-- End Attitude Seeds

-- Seed Speeds (idempotent - safe to run multiple times)
INSERT INTO speed (id, speed_name)
VALUES (1, 'Base')
ON CONFLICT (id) DO NOTHING;
SELECT setval('speed_id_seq', (SELECT MAX(id) FROM speed));

INSERT INTO speed (speed_name)
VALUES 
  ('Climb'),
  ('Swim'),
  ('Fly'),
  ('Burrow')
ON CONFLICT (speed_name) DO NOTHING;
-- End Speed Seeds

-- Seed Classes (idempotent - safe to run multiple times)
INSERT INTO classes (id, class_name, source)
VALUES (1, 'Unknown', 'Core')
ON CONFLICT (id) DO NOTHING;
SELECT setval('classes_id_seq', (SELECT MAX(id) FROM classes));

INSERT INTO classes (class_name, source, class_type, magic_type, caster_spontaneous, has_companion)
VALUES
  -- Core Rulebook classes
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
  ('Wizard', 'Core', 'Magic', 'Arcane', FALSE, TRUE),
  -- APG classes
  ('Alchemist', 'APG', 'Hybrid(s)', 'Alchemical', FALSE, FALSE),
  ('Cavalier', 'APG', 'Martial', NULL, FALSE, TRUE),
  ('Gunslinger', 'APG', 'Martial', NULL, FALSE, FALSE),
  ('Inquisitor', 'APG', 'Hybrid(m)', 'Divine', TRUE, FALSE),
  ('Magus', 'APG', 'Hybrid(m)', 'Arcane', FALSE, FALSE),
  ('Oracle', 'APG', 'Magic', 'Divine', TRUE, FALSE),
  ('Summoner', 'APG', 'Magic', 'Arcane', TRUE, TRUE),
  ('Witch', 'APG', 'Magic', 'Occult', FALSE, TRUE),
  ('Vigilante', 'APG', 'Hybrid(s)', NULL, FALSE, FALSE),
  -- Hybrid classes
  ('Arcanist', 'ACG', 'Magic', 'Arcane', TRUE, FALSE),
  ('Bloodrager', 'ACG', 'Hybrid(m)', 'Arcane', TRUE, FALSE),
  ('Brawler', 'ACG', 'Martial', NULL, FALSE, FALSE),
  ('Hunter', 'ACG', 'Hybrid(m)', 'Primal', TRUE, TRUE),
  ('Investigator', 'ACG', 'Hybrid(s)', 'Alchemical', FALSE, FALSE),
  ('Shaman', 'ACG', 'Magic', 'Primal', FALSE, TRUE),
  ('Skald', 'ACG', 'Hybrid(3)', 'Arcane', TRUE, FALSE),
  ('Slayer', 'ACG', 'Hybrid(s)', NULL, FALSE, FALSE),
  ('Swashbuckler', 'ACG', 'Martial', NULL, FALSE, FALSE),
  ('Warpriest', 'ACG', 'Hybrid(m)', 'Divine', FALSE, FALSE),
  -- Occult classes
  ('Kineticist', 'Occult', 'Magic', 'Occult', FALSE, FALSE),
  ('Medium', 'Occult', 'Hybrid(3)', 'Occult', TRUE, FALSE),
  ('Mesmerist', 'Occult', 'Hybrid(s)', 'Occult', TRUE, FALSE),
  ('Occultist', 'Occult', 'Hybrid(3)', 'Occult', TRUE, FALSE),
  ('Psychic', 'Occult', 'Magic', 'Occult', TRUE, FALSE),
  ('Spiritualist', 'Occult', 'Magic', 'Occult', TRUE, TRUE),
  -- Alternate classes
  ('Antipaladin', 'Alt', 'Hybrid(m)', 'Divine', FALSE, TRUE),
  ('Ninja', 'Alt', 'Skill', NULL, FALSE, FALSE),
  ('Samurai', 'Alt', 'Martial', NULL, FALSE, FALSE),
  -- Other base classes
  ('Shifter', 'Other', 'Martial', NULL, FALSE, FALSE),
  ('Vampire Hunter', 'Other', 'Hybrid(3)', 'DIVINE', TRUE, TRUE)
ON CONFLICT (class_name) DO NOTHING;

INSERT INTO classes (class_name, source, class_type)
VALUES
  -- NPC classes
  ('Adept', 'NPC', 'Magic'),
  ('Aristocrat', 'NPC', 'Skill'),
  ('Commoner', 'NPC', 'Martial'),
  ('Expert', 'NPC', 'Skill'),
  ('Warrior', 'NPC', 'Martial')
ON CONFLICT (class_name) DO NOTHING;

INSERT INTO classes (class_name, source, class_type)
VALUES
  -- Prestige Classes
  ('Agent of the Grave', 'Prestige', 'Prestige'),
  ('Aldori Swordlord', 'Prestige', 'Prestige'),
  ('Arcane Archer', 'Prestige', 'Prestige'),
  ('Arcane Trickster', 'Prestige', 'Prestige'),
  ('Archlord of Nex', 'Prestige', 'Prestige'),
  ('Argent Dramaturge', 'Prestige', 'Prestige'),
  ('Asavir', 'Prestige', 'Prestige'),
  ('Ashavic Dancer', 'Prestige', 'Prestige'),
  ('Aspis Agent', 'Prestige', 'Prestige'),
  ('Assassin', 'Prestige', 'Prestige'),
  ('Balanced Scale of Abadar', 'Prestige', 'Prestige'),
  ('Battle Herald', 'Prestige', 'Prestige'),
  ('Bellflower Tiller', 'Prestige', 'Prestige'),
  ('Blackfire Adept', 'Prestige', 'Prestige'),
  ('Bloatmage', 'Prestige', 'Prestige'),
  ('Brewkeeper', 'Prestige', 'Prestige'),
  ('Brightness Seeker', 'Prestige', 'Prestige'),
  ('Brother of the Seal', 'Prestige', 'Prestige'),
  ('Champion of Irori', 'Prestige', 'Prestige'),
  ('Chernasardo Warden', 'Prestige', 'Prestige'),
  ('Chevalier', 'Prestige', 'Prestige'),
  ('Crimson Templar', 'Prestige', 'Prestige'),
  ('Cyphermage', 'Prestige', 'Prestige'),
  ('Daggermark Poisoner', 'Prestige', 'Prestige'),
  ('Daivrat', 'Prestige', 'Prestige'),
  ('Darechaser', 'Prestige', 'Prestige'),
  ('Dawnflower Anchorite', 'Prestige', 'Prestige'),
  ('Dawnflower Dissident', 'Prestige', 'Prestige'),
  ('Death Slayer', 'Prestige', 'Prestige'),
  ('Demoniac', 'Prestige', 'Prestige'),
  ('Devoted Muse', 'Prestige', 'Prestige'),
  ('Diabolist', 'Prestige', 'Prestige'),
  ('Divine Scion', 'Prestige', 'Prestige'),
  ('Dragon Disciple', 'Prestige', 'Prestige'),
  ('Duelist', 'Prestige', 'Prestige'),
  ('Eldritch Knight', 'Prestige', 'Prestige'),
  ('Enchanting Courtesan', 'Prestige', 'Prestige'),
  ('Envoy of Balance', 'Prestige', 'Prestige'),
  ('Esoteric Knight', 'Prestige', 'Prestige'),
  ('Evangelist', 'Prestige', 'Prestige'),
  ('Exalted', 'Prestige', 'Prestige'),
  ('Feysworn', 'Prestige', 'Prestige'),
  ('Genie Binder', 'Prestige', 'Prestige'),
  ('Golden Legionnaire', 'Prestige', 'Prestige'),
  ('Gray Corsair', 'Prestige', 'Prestige'),
  ('Gray Gardener', 'Prestige', 'Prestige'),
  ('Green Faith Acolyte', 'Prestige', 'Prestige'),
  ('Halfling Opportunist', 'Prestige', 'Prestige'),
  ('Harrower', 'Prestige', 'Prestige'),
  ('Hellknight', 'Prestige', 'Prestige'),
  ('Hellknight Signifier', 'Prestige', 'Prestige'),
  ('Heritor Knight', 'Prestige', 'Prestige'),
  ('Hinterlander', 'Prestige', 'Prestige'),
  ('Holy Vindicator', 'Prestige', 'Prestige'),
  ('Horizon Walker', 'Prestige', 'Prestige'),
  ('Inheritors Crusader', 'Prestige', 'Prestige'),
  ('Inner Sea Pirate', 'Prestige', 'Prestige'),
  ('Justicar', 'Prestige', 'Prestige'),
  ('Knight of Ozem', 'Prestige', 'Prestige'),
  ('Lantern Bearer', 'Prestige', 'Prestige'),
  ('Liberator', 'Prestige', 'Prestige'),
  ('Lion Blade', 'Prestige', 'Prestige'),
  ('Living Monolith', 'Prestige', 'Prestige'),
  ('Loremaster', 'Prestige', 'Prestige'),
  ('Low Templar', 'Prestige', 'Prestige'),
  ('Magaambyan Arcanist', 'Prestige', 'Prestige'),
  ('Mammoth Rider', 'Prestige', 'Prestige'),
  ('Master Chymist', 'Prestige', 'Prestige'),
  ('Master Spy', 'Prestige', 'Prestige'),
  ('Mortal Usher', 'Prestige', 'Prestige'),
  ('Mystery Cultist', 'Prestige', 'Prestige'),
  ('Nature Warden', 'Prestige', 'Prestige'),
  ('Noble Scion', 'Prestige', 'Prestige'),
  ('Pain Taster', 'Prestige', 'Prestige'),
  ('Pathfinder Chronicler', 'Prestige', 'Prestige'),
  ('Pathfinder Delver', 'Prestige', 'Prestige'),
  ('Pathfinder Field Agent', 'Prestige', 'Prestige'),
  ('Pathfinder Savant', 'Prestige', 'Prestige'),
  ('Pit Fighter', 'Prestige', 'Prestige'),
  ('Proctor', 'Prestige', 'Prestige'),
  ('Prophet of Kalistrade', 'Prestige', 'Prestige'),
  ('Pure Legion Enforcer', 'Prestige', 'Prestige'),
  ('Rage Prophet', 'Prestige', 'Prestige'),
  ('Razmiran Priest', 'Prestige', 'Prestige'),
  ('Red Mantis Assassin', 'Prestige', 'Prestige'),
  ('Riftwarden', 'Prestige', 'Prestige'),
  ('Ritualist', 'Prestige', 'Prestige'),
  ('Rivethun Emissary', 'Prestige', 'Prestige'),
  ('Rose Warden', 'Prestige', 'Prestige'),
  ('Runeguard', 'Prestige', 'Prestige'),
  ('Sacred Sentinel', 'Prestige', 'Prestige'),
  ('Sanguine Angel', 'Prestige', 'Prestige'),
  ('Scar Seeker', 'Prestige', 'Prestige'),
  ('Sentinel', 'Prestige', 'Prestige'),
  ('Shackles Pirate', 'Prestige', 'Prestige'),
  ('Shadowdancer', 'Prestige', 'Prestige'),
  ('Shieldmarshal', 'Prestige', 'Prestige'),
  ('Skyseeker', 'Prestige', 'Prestige'),
  ('Sleepless Detective', 'Prestige', 'Prestige'),
  ('Soul Warden', 'Prestige', 'Prestige'),
  ('Souldrinker', 'Prestige', 'Prestige'),
  ('Sphere Singer', 'Prestige', 'Prestige'),
  ('Spherewalker', 'Prestige', 'Prestige'),
  ('Stalwart Defender', 'Prestige', 'Prestige'),
  ('Stargazer', 'Prestige', 'Prestige'),
  ('Steel Falcon', 'Prestige', 'Prestige'),
  ('Storm Kindler', 'Prestige', 'Prestige'),
  ('Student of Perfection', 'Prestige', 'Prestige'),
  ('Student of War', 'Prestige', 'Prestige'),
  ('Tattooed Mystic', 'Prestige', 'Prestige'),
  ('Technomancer', 'Prestige', 'Prestige'),
  ('Thuvian Alchemist', 'Prestige', 'Prestige'),
  ('Twilight Talon', 'Prestige', 'Prestige'),
  ('Ulfen Guard', 'Prestige', 'Prestige'),
  ('Umbral Court Agent', 'Prestige', 'Prestige'),
  ('Veiled Illusionist', 'Prestige', 'Prestige'),
  ('Westcrown Devil', 'Prestige', 'Prestige'),
  ('Winter Witch', 'Prestige', 'Prestige')
ON CONFLICT (class_name) DO NOTHING;

-- Seed Races (idempotent - safe to run multiple times)
INSERT INTO race (id, race_name)
VALUES 
  (1, 'Unknown'),
  (2, 'Human')
ON CONFLICT (id) DO NOTHING;
SELECT setval('race_id_seq', (SELECT MAX(id) FROM race));

INSERT INTO race (race_name, limited)
VALUES
  -- Core Races
  ('Dwarf', FALSE),
  ('Elf', FALSE),
  ('Gnome', FALSE),
  ('Halfling', FALSE),
  ('Half-Elf', FALSE),
  ('Half-Orc', FALSE)
ON CONFLICT (race_name) DO NOTHING;

INSERT INTO race (race_name)
VALUES 
  -- Standard Races
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
  ('Vanara'),
  -- Advanced Races
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
  ('Wyvaran'),
  -- Other Races
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
  ('Leshy'),
  ('Merfolk'),
  ('Munavri'),
  ('Nagaji'),
  ('Orang-Pendak'),
  ('Reptoid'),
  ('Samsaran'),
  ('Strix'),
  ('Wayang')
ON CONFLICT (race_name) DO NOTHING;
-- End Race Seeds

-- Seed Religions   (idempotent - safe to run multiple times)
INSERT INTO religions (id, religion_name)
VALUES 
  -- reserve 1 - 5
  (1, 'Unknown'),
  (2, 'Atheist'),
  (3, 'Concept'),
  (4, 'Ancestors'),
  (5, 'Totem Spirits')
ON CONFLICT (id) DO NOTHING;
SELECT setval('religions_id_seq', (SELECT MAX(id) FROM religions));

INSERT INTO religions (religion_name)
VALUES 
  -- Core 20 deities from Golarion (Pathfinder 1e)
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
  ('Sarenrae'),
  ('Shelyn'),
  ('Torag'),
  ('Urgathoa'),
  ('Zon-Kuthon')
ON CONFLICT (religion_name) DO NOTHING;

INSERT INTO religions (religion_name, obscurity)
VALUES 
  -- Major Religious Groups
  ('Green Faith', 'Common'),
  ('Godclaw', 'Uncommon'),
  ('Prophecies of Kalistrade', 'Regional'),
  ('Faith of the Living God', 'Regional'),
  ('Vudran Pantheon', 'Regional'),
  ('Old Sun Gods', 'Regional'),
  ('Empyreal Court', 'Obscure'),
  ('The Eldest', 'Obscure'),
  ('Perfected Man', 'Racial'),
  ('Laws of Mortality', 'Racial'),
  ('Whispering Way', 'Regional'),
  -- Regional Faiths - Mwangi / Arcadia
  ('Angazhan', 'Regional'),
  ('Chamidu', 'Regional'),
  ('Balumbdar', 'Regional'),
  ('Iomedae (Mwangi)', 'Regional'),
  ('Grandmother Spider', 'Regional'),
  ('Old-Mage Jatembe', 'Regional'),
  ('Ragdya', 'Regional'),
  ('Shelyn (Mwangi)', 'Regional'),
  ('Shimye-Magalla', 'Regional'),
  -- Regional Faiths - Osirion
  ('Anubis', 'Regional'),
  ('Bastet', 'Regional'),
  ('Horus', 'Regional'),
  ('Isis', 'Regional'),
  ('Nethys (Osirion)', 'Regional'),
  ('Ra', 'Regional'),
  ('Sobek', 'Regional'),
  ('Thoth', 'Regional'),
  -- Regional Faiths - Tian Xia
  ('Hei Feng', 'Regional'),
  ('Tsukiyo', 'Regional'),
  ('Daikitsu', 'Regional'),
  ('Shizuru', 'Regional'),
  -- Regional Faiths - Vudran (Hindi)
  ('Irori (Vudra)', 'Regional'),
  ('Chohar', 'Regional'),
  ('Gruhastha', 'Regional'),
  ('Lahkgya', 'Regional'),
  ('Nalinivati', 'Regional'),
  ('Vineshvakhi', 'Regional'),
  -- Regional Faiths -City/Nation Patrons
  ('Besmara', 'Regional'),
  ('Walkena', 'Regional'),
  ('Achaekek (Red Mantis)', 'Regional'),
  -- Regional Faiths - Other/ Various
  ('Abadar (Localized)', 'Regional'),
  ('Lost Sun', 'Regional'),
  ('Sandpoint Pantheon', 'Regional'),
  -- Racial Faiths
  ('Findeladlara', 'Racial'),
  ('Ketephys', 'Racial'),
  ('Yuelral', 'Racial'),
  ('Alseta', 'Racial'),
  ('Nivi Rhombodazzle', 'Racial'),
  ('Angradd', 'Racial'),
  ('Bolka', 'Racial'),
  ('Dranngvit', 'Racial'),
  ('Folgrit', 'Racial'),
  ('Grundinnar', 'Racial'),
  ('Kols', 'Racial'),
  ('Magrim', 'Racial'),
  ('Trudd', 'Racial'),
  ('Sezelrian the Butcher', 'Racial'),
  ('Nulgreth', 'Racial'),
  ('Varg', 'Racial'),
  ('Verex', 'Racial'),
  ('Hadregash', 'Racial'),
  ('Venkelvore the Glutton Dark', 'Racial'),
  ('Zarongel', 'Racial'),
  ('Zogmugot', 'Racial'),
  ('Bargrivyek', 'Racial'),
  ('No-mens', 'Racial'),
  ('Chaldira Zuzaristan', 'Racial'),
  ('Minderhal', 'Racial'),
  ('Kelizandri', 'Racial'),
  ('Grandmother Crow', 'Racial'),
  -- Lost/Dead/Imprisoned/Pre-Transformed Gods
  ('Aroden', 'Lost'),
  ('Acavna', 'Lost'),
  ('Amaznen', 'Lost'),
  ('Curchanus', 'Lost'),
  ('Ydersius', 'Lost'),
  ('Rovagug', 'Lost'),
  ('Dou-Bral', 'Lost'),
  ('Kazutal', 'Lost'),
  ('Nocticula (Demon Lord)', 'Lost'),
  ('Lissala', 'Lost'),
  ('Arazni (Herald)', 'Lost'),
  ('Deskari', 'Lost'),
  ('Viriavaxus', 'Lost'),
  ('Ragadahn', 'Lost'),
  ('Mazludeh', 'Lost'),
  -- Recovered (Lost) or Promoted Gods
  ('Nocticula', 'Obscure'),
  ('Easivra', 'Obscure'),
  ('Apsu', 'Racial'),
  ('Dahak', 'Racial'),
  ('Arazni', 'Regional'),
  -- Other Uncommon Dieties
  ('Achaekek', 'Uncommon'),
  ('Black Butterfly', 'Uncommon'),
  ('Brigh', 'Uncommon'),
  ('Ghlaunder', 'Uncommon'),
  ('Gyronna', 'Uncommon'),
  ('Milani', 'Uncommon'),
  ('Pulura', 'Uncommon'),
  ('Ragathiel', 'Uncommon'),
  ('Sivanah', 'Uncommon'),
  ('Vildeis', 'Uncommon'),
  ('Zyphus', 'Uncommon'),
  ('Cihua', 'Uncommon'),
  ('Kurgess', 'Uncommon'),
  -- Empyreal Lords (treated as obscure divine patrons)
  ('Andoletta', 'Obscure'),
  ('Arshea', 'Obscure'),
  ('Ashava', 'Obscure'),
  ('Cernunnos', 'Obscure'),
  ('Dammerich', 'Obscure'),
  ('Falayna', 'Obscure'),
  ('Korada', 'Obscure'),
  ('Soralyon', 'Obscure'),
  ('Szuriel', 'Obscure'),
  -- The Eldest (First World powers)
  ('The Lantern King', 'Obscure'),
  ('Ng', 'Obscure'),
  ('Shyka', 'Obscure'),
  ('Magdh', 'Obscure'),
  ('Imbrex', 'Obscure'),
  ('The Lost Prince', 'Obscure'),
  -- Great Old Ones / Outer Gods (Cthulhu Mythos in PF1)
  ('Azathoth', 'Obscure'),
  ('Nyarlathotep', 'Obscure'),
  ('Yog-Sothoth', 'Obscure'),
  ('Shub-Niggurath', 'Obscure'),
  ('Cthulhu', 'Obscure'),
  ('Hastur', 'Obscure'),
  ('Ghatanothoa', 'Obscure'),
  -- Demon Lords (as obscure religions rather than broad cults)
  ('Dagon', 'Obscure'),
  ('Kostchtchie', 'Obscure'),
  ('Pazuzu', 'Obscure'),
  ('Socothbenoth', 'Obscure'),
  ('Shax', 'Obscure'),
  -- Archdevils (non-Asmodeus)
  ('Mephistopheles', 'Obscure'),
  ('Dispater', 'Obscure'),
  ('Mammon', 'Obscure'),
  ('Belial', 'Obscure'),
  ('Moloch', 'Obscure'),
  ('Geryon', 'Obscure'),
  ('Baalzebul', 'Obscure'),
  -- Other obscure or single-reference PF1 deities
  ('Picoperi', 'Obscure'),
  ('Hanspur', 'Obscure'),
  ('Groetus', 'Obscure')
ON CONFLICT (religion_name) DO NOTHING;
-- End Religion Seeds

-- Seed Languages (idempotent - safe to run multiple times)
INSERT INTO languages (id, language_name, is_recommended)
VALUES
  --reserving 1-2 for common and other
  (1, 'Common', TRUE),
  (2, 'Other', FALSE)
ON CONFLICT (id) DO NOTHING;
SELECT setval('languages_id_seq', (SELECT MAX(id) FROM languages));

INSERT INTO languages (language_name)
VALUES 
  -- Ancestral / racial core
  ('Dwarven'),
  ('Elven'),
  ('Gnome'),
  ('Halfling'),
  ('Orc'),
  ('Goblin'),
  ('Giant'),
  ('Draconic'),
  ('Sylvan'),
  ('Tengu'),
  ('Undercommon'),
  -- Planar / elemental / divine
  ('Celestial'),
  ('Abyssal'),
  ('Infernal'),
  ('Aquan'),
  ('Auran'),
  ('Ignan'),
  ('Terran'),
  ('Leshy'),
  ('Protean'),
  ('Daemonic'),
  ('Div'),
  ('Kyton'),
  ('Qlippothic'),
  ('Shadowtongue'),
  -- Widely referenced “other” tongues
  ('Aklo'),
  ('Alghollthu (Aboleth)'),
  ('Cyclops'),
  ('Dark Folk Cant'),
  ('Drider'),
  ('Ettercap'),
  ('Gnoll'),
  ('Grippli'),
  ('Minotaur'),
  ('Necril'),
  ('Sahuagin'),
  ('Sphinx'),
  ('Treant'),
  ('Troglodyte'),
  ('Vegepygmy'),
  ('Yeti')
ON CONFLICT (language_name) DO NOTHING;

INSERT INTO languages (language_name, is_secret)
VALUES
  -- Secret Languages
  ('Druidic (Wildsong)', TRUE),
  ('Drow Sign Language', TRUE),
  ('Thieves Cant', TRUE),
  ('Lion Blade Codespeak', TRUE),
  ('Hellknight Signifier Cant', TRUE),
  ('Red Mantis Sign Language', TRUE)
ON CONFLICT (language_name) DO NOTHING;

INSERT INTO languages (language_name, is_dialect)
VALUES
  -- Regional Dialects (usually human)
  ('Akitan', TRUE),
  ('Ekujae Shape-Script', TRUE),
  ('Hallit', TRUE),
  ('Kelish', TRUE),
  ('Osiriani', TRUE),
  ('Polyglot', TRUE),
  ('Shoanti', TRUE),
  ('Skald', TRUE),
  ('Tien', TRUE),
  ('Varisian', TRUE),
  ('Vudrani', TRUE)
ON CONFLICT (language_name) DO NOTHING;

INSERT INTO languages (language_name, is_ancient)
VALUES
  -- Ancient / Dead Languages
  ('Ancient Osiriani', TRUE),
  ('Ancient Azlanti', TRUE),
  ('Ancient Thassilonian', TRUE),
  ('Akashic', TRUE),
  ('Jistka', TRUE),
  ('Orvian', TRUE),
  ('Shory', TRUE),
  ('Tekritanin', TRUE)
ON CONFLICT (language_name) DO NOTHING;

INSERT INTO languages (language_name)
VALUES
  -- Other Languages (expansion block space)
  ('Boggard'),
  ('Caligni'),
  ('Kech'),
  ('Sasquatch'),
  ('Syrinx'),
  ('Strix')
ON CONFLICT (language_name) DO NOTHING;
-- End Language Seeds
-- END GLOBAL LOOKUP TABLES SEED BLOCK

-- START GLOBAL TITLES SEED BLOCK (idempotent - safe to run multiple times)
INSERT INTO title_ranks (title_rank_name, sort_order)
VALUES -- Rank order for backend sorting
  -- 1. Imperial Authority
  ('empire', 10),
  ('imperial advisor', 20),
  -- 2. National Authority
  ('kingdom', 30),
  ('national advisor', 40),
  ('high general', 40),
  ('major faith', 40),
  -- 3. Sub‑National Major Authority
  ('grand duchy', 50),
  ('archduchy', 50),
  ('archbishopric', 50),
  ('principality', 60),
  -- 4. Regional Authority
  ('duchy', 70),
  ('bishopric', 70),
  ('march', 80),
  ('landgrave', 80),
  ('major general', 80),
  ('major city', 80),
  ('major guild', 80),
  ('major important', 80),
  -- 5. Sub‑Regional Authority
  ('county', 90),
  ('earldom', 90),
  ('general', 90),
  ('temple', 90),
  ('regional important', 100),
  ('regional faith', 100),
  ('regional guild', 100),
  ('viscounty', 100),
  ('tribune', 100),
  ('colonel', 100),
  -- 6. Local Major Authority
  ('barony', 110),
  ('abbey', 110),
  ('city', 110),
  ('major', 110),
  ('captain', 120),
  ('guildmaster', 120),
  -- 7. Local Minor Authority
  ('baronet', 130),
  ('estate', 130),
  ('magistrate', 130),
  ('master artisan', 130),
  ('master tradesman', 130),
  ('local important', 140),
  ('local faith', 140),
  ('warden', 140),
  ('steward', 140),
  ('castellan', 140),
  ('reeve', 140),
  ('property owner', 140),
  -- 8. Landless Nobility / Officer Class
  ('knight', 150),
  ('lieutenant', 150),
  ('esquire', 160),
  ('gentleman', 160),
  ('ensign', 160),
  ('sergeant', 160),
  -- 9. Wealth‑Based Authority
  ('merchant', 170),
  ('corporal', 170),
  ('artisan', 170),
  ('tradesman', 180),
  ('guard', 180),
  ('private', 180)
ON CONFLICT (title_rank_name) DO NOTHING;

INSERT INTO titles (title_name, honorific_masculine, prefix_masculine)
VALUES 
  -- Gender-Neutral Titles
  ('hero, city', 'Hero', NULL),
  ('hero, regional', 'Hero', NULL),
  ('hero, major', 'Renowned Hero', 'Renowned Hero'),
  ('champion, city', 'Champion', NULL),
  ('champion, regional', 'Champion', NULL),
  ('champion, major', 'Renowned Champion', 'Renowned Champion'),
  ('general', 'General', 'General'),
  ('colonel', 'Colonel', 'Colonel'),
  ('major', 'Major', 'Major'),
  ('captain', 'Captain', 'Captain'),
  ('lieutenant', 'Lieutenant', 'Lt.'),
  ('sergeant', 'Sergeant', 'Sgt.'),
  ('corporal', 'Corporal', 'Cpl.'),
  ('guard', 'Guardsmen', NULL),
  ('private', 'Private', 'Pvt.'),
  ('mayor', 'The Honorable', 'Mayor'),
  ('lord mayor', 'The Most Honorable', 'Lord Mayor'),
  ('guildmaster', 'Guildmaster', 'Guildmaster'),
  ('major guild', 'Guildmaster', 'Guildmaster'),
  ('regional guild', 'Guildmaster', 'Guildmaster'),
  ('regional guildman', 'Guilly', 'Guilly'),
  ('pathfinder', 'Pathfinder', 'Pathfinder'),
  ('asp', 'Asp', 'Asp'),
  ('red mantis', NULL, NULL),
  ('red mantis mistress', 'Mistress', 'Mistress'),
  ('patron', 'Patron', NULL),
  ('venture-lieutenant', 'Venturer', 'Venture Lt.'),
  ('venture-captain', 'Venture-Captain', 'Venture Cpt.'),
  ('decemvirate', NULL, NULL),
  ('magistrate', 'Magistrate', 'Magistrate'),
  ('warden', 'Warden', 'Warden'),
  ('tribune', 'Tribune', 'Tribune'),
  ('merchant', NULL, NULL),
  ('artisan', NULL, NULL),
  ('tradesman', NULL, NULL),
  ('estate', 'Master', 'Master'),
  ('master artisan', 'Master', 'Master'),
  ('master tradesman', 'Master', 'Master'),
  ('property owner', NULL, NULL),
  ('marshal', 'Marshal', 'Marshal'),
  ('field marshal', 'Field Marshal', 'Field Marshal'),
  ('commander', 'Commander', 'Commander'),
  ('high commander', 'High Commander', 'High Commander'),
  ('vizier', 'Vizier', 'Vizier'),
  ('high inquisitor', 'High Inquisitor', 'High Inquisitor'),
  ('alderman', 'Alderman', 'Alderman'),
  ('councilor', 'Councilor', 'Councilor'),
  ('provost', 'Provost', 'Provost'),
  ('burgomaster', 'Burgomaster', 'Burgomaster'),
  ('sheriff', 'Sheriff', 'Sheriff'),
  ('bailiff', 'Bailiff', 'Bailiff'),
  ('justiciar', 'Justiciar', 'Justiciar'),
  ('senator', 'Senator', 'Senator'),
  ('legate', 'Legate', 'Legate'),
  ('prefect', 'Prefect', 'Prefect'),
  ('tribune of the senate', 'Tribune', 'Tribune'),
  ('speaker', 'Speaker', 'Speaker'),
  ('consul', 'Consul', 'Consul'),
  ('proconsul', 'Proconsul', 'Proconsul'),
  ('imperial chancellor', 'Imperial Chancellor', 'Imperial Chancellor'),
  ('imperial secretary', 'Imperial Secretary', 'Imperial Secretary'),
  ('privy councillor', 'Privy Councillor', 'Privy Councillor'),
  ('grand councillor', 'Grand Councillor', 'Grand Councillor'),
  ('imperial steward', 'Imperial Steward', 'Imperial Steward'),
  ('imperial marshal', 'Imperial Marshal', 'Imperial Marshal'),
  ('castellan', 'Castellan', 'Keeper'),
  ('reeve', 'Reaper', 'Reeve'),
  ('yeoman', NULL, NULL),
  ('ensign', 'Ensign', 'Ens.'),
  ('lictor', 'Lictor', 'Lictor'),
  ('paralictor', 'Paralictor', 'Paralictor'),
  ('maralictor', 'Maralictor', 'Maralictor'),
  ('talon captain', 'Captain', 'Captain'),
  ('steel falcon', 'Falcon', 'Falcon'),
  ('whispering agent', 'Whisper', 'Whisper'),
  ('skipper', 'Skipper', 'Skipper'),
  ('first mate', 'First Mate', 'First Mate'),
  ('cook', 'Cook', 'Cook'),
  ('quartermaster', 'Quartermaster', 'Quartermaster'),
  ('boatswain', 'Boatswain', 'Boatswain'),
  ('sailor', 'Sailor', 'Sailor'),
  ('overseer', 'Overseer', 'Overseer'),
  ('chief', 'Chief', 'Chief'),
  ('minister', 'Minister', 'Minister'),
  ('high minister', 'High Minister', 'High Minister'),
  ('secretary', 'Secretary', 'Secretary'),
  ('grand secretary', 'Grand Secretary', 'Grand Secretary'),
  ('chancellor', 'Chancellor', 'Chancellor'),
  ('high chancellor', 'High Chancellor', 'High Chancellor'),
  ('grand vizier', 'Grand Vizier', 'Grand Vizier')
ON CONFLICT (title_name) DO NOTHING;

INSERT INTO titles (title_name, name_feminine, honorific_masculine, honorific_feminine, prefix_masculine, prefix_feminine)
VALUES 
  -- Noble Titles
  ('emperor', 'empress', 'His Imperial Majesty', 'Her Imperial Majesty', 'Emperor', 'Empress'),
  ('grand prince', 'grand princess', 'His Imperial Majesty', 'Her Imperial Majesty', 'Grand Prince', 'Grand Princess'),
  ('king', 'queen', 'His Majesty', 'Her Majesty', 'King', 'Queen'),
  ('prince', 'princess', 'His Highness', 'Her Highness', 'Prince', 'Princess'),
  ('grand duke', 'grand duchess', 'His Royal Highness', 'Her Royal Highness', 'Grand Duke', 'Grand Duchess'),
  ('archduke', 'archduchess', 'His Imperial Highness', 'Her Imperial Highness', 'Archduke', 'Archduchess'),
  ('duke', 'duchess', 'His Grace', 'Her Grace', 'Duke', 'Duchess'),
  ('marquess', 'marquise', 'His Illustriousness', 'Her Illustriousness', 'Marquis', 'Marchioness'),
  ('landgrave', 'landgravine', 'His Highbourn Lordship', 'Her Highbourn Ladyship', 'Landgrave', 'Landgravine'),
  ('count', 'countess', 'His Lordship', 'Her Ladyship', 'Count', 'Countess'),
  ('earl', 'arless', 'His Lordship', 'Her Ladyship', 'Earl', 'Arless'),
  ('viscount', 'viscountess', 'The Right Honorable', 'The Right Honorable', 'Viscount', 'Viscountess'),
  ('baron', 'baroness', 'His Lordship', 'Her Ladyship', 'Baron', 'Baroness'),
  ('baronet', 'baronetess', 'Sir', 'Dame', 'Baronet', 'Baronetess'),
  ('lord', 'lady', 'Lord', 'Lady', 'Lord', 'Lady'),
  ('knight', 'dame', 'Sir', 'Dame', 'Sir', 'Dame'),
  ('esquire', 'esquire', 'Esquire', 'Esquire', 'Esq.', 'Esq.'),
  ('sultan', 'sultana', 'His Majesty', 'Her Majesty', 'Sultan', 'Sultana'),
  ('shah', 'shahbanu', 'His Imperial Majesty', 'Her Imperial Majesty', 'Shah', 'Shahbanu'),
  ('rajah', 'rani', 'His Highness', 'Her Highness', 'Rajah', 'Rani'),
  ('maharajah', 'maharani', 'His Majesty', 'Her Majesty', 'Maharajah', 'Maharani'),
  ('samraja', 'samraat', 'His Greatest Majesty', 'Her Greatest Majesty', 'Samraja', 'Samraat'),
  ('khan', 'khatun', 'His Excellency', 'Her Excellency', 'Khan', 'Khatun'),
  ('czar', 'czarina', 'His Imperial Majesty', 'Her Imperial Majesty', 'Czar', 'Czarina'),
  ('tsar', 'tsarina', 'His Imperial Majesty', 'Her Imperial Majesty', 'Tsar', 'Tsarina'),
  ('pharaoh', 'pharaoh', 'His Divine Majesty', 'Her Divine Majesty', 'Pharaoh', 'Pharaoh'),
  ('elector', 'electress', 'His Serene Highness', 'Her Serene Highness', 'Elector', 'Electress'),
  ('margrave', 'margravine', 'His Illustriousness', 'Her Illustriousness', 'Margrave', 'Margravine'),
  ('jarl', 'jarless', 'His Lordship', 'Her Ladyship', 'Jarl', 'Jarless'),
  ('thane', 'thane', 'His Lordship', 'Her Ladyship', 'Thane', 'Thane'),
  ('boyar', 'boyarina', 'His Lordship', 'Her Ladyship', 'Boyar', 'Boyarina'),
  ('doge', 'dogaressa', 'His Serenity', 'Her Serenity', 'Doge', 'Dogaressa'),
  ('aristocrat', 'aristocrat', 'Sir', 'Madam', 'Mr.', 'Mrs.'),
  ('aristocrat, single', 'aristocrat', 'Sir', 'Madam', 'Mr.', 'Ms.'),
  ('high vaxitalian', 'high vaxitalianette', 'His Excellency', 'Her Excellency', 'High Vaxitalian', 'High Vaxitalianette'),
  ('vaxitalian', 'vaxitalianette', 'His Excellency', 'Her Excellency', 'Vaxitalian', 'Vaxitalianette'),
  ('grand baron', 'grand baroness', 'His Lordship', 'Her Ladyship', 'Grand Baron', 'Grand Baroness'),
  ('suma baron', 'suma baroness', 'His Lordship', 'Her Ladyship', 'Suma-Baron', 'Suma-Baroness'),
  ('over duke', 'over duchess', 'His Grace', 'Her Grace', 'Over Duke', 'Over Duchess'),
  ('abra duke', 'abra duchess', 'His Grace', 'Her Grace', 'Duke', 'Duchess'),
  ('suma duke', 'suma duchess', 'His Grace', 'Her Grace', 'Suma-Duke', 'Suma-Duchess'),
  ('lord montcastle', 'lady montcastle', 'Lord', 'Lady', 'Lord Montcastle', 'Lady Montcastle'),
  ('grandee', 'grandee', 'Grandee', 'Grandee', 'Grandee', 'Grandee'),
  ('abra grandee', 'abra grandee', 'Grandee', 'Grandee', 'Grandee', 'Grandee'),
  ('grand magnate', 'grand magnate', 'Magnate', 'Magnate', 'Grand Magnate', 'Grand Magnate'),
  ('magnate', 'magnate', 'Magnate', 'Magnate', 'Magnate', 'Magnate'),
  ('high lord', 'high lady', 'High Lord', 'High Lady', 'High Lord', 'High Lady'),
  ('true lord', 'true lady', 'True Lord', 'True Lady', 'Lord', 'Lady'),
  ('suma lord', 'suma lady', 'Lord', 'Lady', 'Lord', 'Lady'),
  ('majestor', 'majestrix', 'His Infernal Majestrix', 'Her Infernal Majestrix', 'Majestor', 'Majestrix'),
  ('paraduke', 'paraduchess', 'His Grace', 'Her Grace', 'Paraduke', 'Paraduchess'),
  ('archcount', 'archcountess', 'His Excellency', 'Her Excellency', 'Archcount', 'Archcountess'),
  ('paracount', 'paracountess', 'His Excellency', 'Her Excellency', 'Paracount', 'Paracountess'),
  ('archbaron', 'archbaroness', 'His Lordship', 'Her Ladyship', 'Archbaron', 'Archbaroness'),
  ('demibaron', 'demibaroness', 'His Lordship', 'Her Ladyship', 'Demi-Baron', 'Demi-Baroness'),
  ('satrap', 'satrap', 'His Excellency', 'Her Excellency', 'Satrap', 'Satrap'),
  ('padishah emperor', 'padishah empress', 'His Divine Majesty', 'Her Divine Majesty', 'Padishah Emperor', 'Padishah Empress'),
  ('trade prince', 'trade princess', 'Your Excellency', 'Your Excellency', 'Prince', 'Princess'),
  -- Other Titles
  ('widower emperor', 'dowager empress', 'His Imperial Majesty', 'Her Imperial Majesty', 'Emperor', 'Empress'),
  ('widower duke', 'dowager duchess', 'His Grace', 'Her Grace', 'Duke', 'Duchess'),
  ('widower', 'dowager', 'His Grace', 'Her Grace', 'Widower', 'Dowager'),
  ('widower marquess', 'dowager marquess', 'His Illustriousness', 'Her Illustriousness', 'Marquess', 'Marquise'),
  ('widower count', 'dowager countess', 'His Excellency', 'Her Excellency', 'Count in Residence', 'Dowager Countess'),
  ('widower baron', 'dowager baroness', 'His Lordship', 'Her Lordship', 'Lord Baron', 'Lady Baroness'),
  ('caliph', 'calipha', 'His Holiness', 'Her Holiness', 'Caliph', 'Calipha'),
  ('high priest', 'high priestess', 'Your Holiness', 'Your Holiness', 'High Priest', 'High Priestess'),
  ('archbishop', 'archbishop', 'Your Excellency', 'Your Excellency', 'Archbishop', 'Archbishop'),
  ('bishop', 'bishop', 'Your Grace', 'Your Grace', 'Bishop', 'Bishop'),
  ('abbot', 'abbess', 'Reverend', 'Reverend', 'Reverend', 'Reverend'),
  ('prior', 'prioress', 'Revered Father', 'Revered Mother', 'Revered Father', 'Revered Mother'),
  ('priest', 'priestess', 'Father', 'Mother', 'Father', 'Mother'),
  ('friar', 'friar', 'Friar', 'Friar', 'Friar', 'Friar'),
  ('cardinal', 'cardinal', 'Holy Father', 'Holy Mother', 'Holy Father', 'Holy Mother'),
  ('archmage', 'archmage', 'Archmage', 'Archmage', 'Archmage', 'Archmage'),
  ('magister', 'magistra', 'Magister', 'Magistra', 'Magister', 'Magistra'),
  ('steward', 'stewardess', 'Steward', 'Stewardess', 'Mr.', 'Mrs.'),
  ('gentleman', 'gentlewoman', 'Gentleman', 'Gentlewoman', 'Gent.', 'Gent.'),
  ('freeman', 'freewoman', NULL, NULL, NULL, NULL),
  ('overlord', 'overlady', 'Overlord', 'Overlady', 'Overlord', 'Overlady'),
  ('overking', 'overqueen', 'Overking', 'Overqueen', 'Overking', 'Overqueen')
ON CONFLICT (title_name) DO NOTHING;

-- Set rank_id for titles by name as Case (avoid nested select)
UPDATE titles AS t
SET rank_id = r.id
FROM title_ranks AS r
WHERE r.title_rank_name = CASE t.title_name
    -- Heroic / achievement titles
    WHEN 'hero, city' THEN 'local important'
    WHEN 'hero, regional' THEN 'regional important'
    WHEN 'hero, major' THEN 'major important'
    WHEN 'champion, city' THEN 'local important'
    WHEN 'champion, regional' THEN 'regional important'
    WHEN 'champion, major' THEN 'major important'
    -- Military / civic (gender-neutral)
    WHEN 'general' THEN 'general'
    WHEN 'colonel' THEN 'colonel'
    WHEN 'major' THEN 'major'
    WHEN 'captain' THEN 'captain'
    WHEN 'lieutenant' THEN 'lieutenant'
    WHEN 'sergeant' THEN 'sergeant'
    WHEN 'corporal' THEN 'corporal'
    WHEN 'guard' THEN 'guard'
    WHEN 'private' THEN 'private'
    WHEN 'mayor' THEN 'city'
    WHEN 'lord mayor' THEN 'major city'
    WHEN 'guildmaster' THEN 'guildmaster'
    WHEN 'major guild' THEN 'major guild'
    WHEN 'regional guild' THEN 'regional guild'
    WHEN 'regional guildman' THEN 'guildmaster'
    WHEN 'pathfinder' THEN 'tradesman'
    WHEN 'asp' THEN 'tradesman'
    WHEN 'red mantis' THEN 'tradesman'
    WHEN 'red mantis mistress' THEN 'guildmaster'
    WHEN 'patron' THEN 'guildmaster'
    WHEN 'venture-lieutenant' THEN 'lieutenant'
    WHEN 'venture-captain' THEN 'captain'
    WHEN 'decemvirate' THEN 'major guild'
    WHEN 'magistrate' THEN 'magistrate'
    WHEN 'warden' THEN 'warden'
    WHEN 'marshal' THEN 'major general'       -- same tier as high regional command
    WHEN 'field marshal' THEN 'high general'  -- national‑level command
    WHEN 'commander' THEN 'captain'           -- or create a mid‑tier if you want
    WHEN 'high commander' THEN 'general'
    WHEN 'high inquisitor' THEN 'major faith'
    WHEN 'alderman' THEN 'local important'
    WHEN 'councilor' THEN 'local important'
    WHEN 'provost' THEN 'city'
    WHEN 'burgomaster' THEN 'city'
    WHEN 'sheriff' THEN 'local important'
    WHEN 'bailiff' THEN 'local important'
    WHEN 'justiciar' THEN 'magistrate'
    WHEN 'senator' THEN 'regional important'
    WHEN 'legate' THEN 'regional important'
    WHEN 'prefect' THEN 'regional important'
    WHEN 'tribune of the senate' THEN 'tribune'
    WHEN 'speaker' THEN 'regional important'
    WHEN 'consul' THEN 'national advisor'
    WHEN 'proconsul' THEN 'national advisor'
    WHEN 'minister' THEN 'national advisor'
    WHEN 'high minister' THEN 'national advisor'
    WHEN 'secretary' THEN 'national advisor'
    WHEN 'grand secretary' THEN 'national advisor'
    WHEN 'chancellor' THEN 'national advisor'
    WHEN 'high chancellor' THEN 'national advisor'
    WHEN 'vizier' THEN 'national advisor'
    WHEN 'grand vizier' THEN 'imperial advisor'
    WHEN 'imperial chancellor' THEN 'imperial advisor'
    WHEN 'imperial secretary' THEN 'imperial advisor'
    WHEN 'privy councillor' THEN 'imperial advisor'
    WHEN 'grand councillor' THEN 'imperial advisor'
    WHEN 'imperial steward' THEN 'imperial advisor'
    WHEN 'imperial marshal' THEN 'imperial advisor'
    -- Noble titles (core)
    WHEN 'emperor' THEN 'empire'
    WHEN 'grand prince' THEN 'empire' -- imperial prince-tier
    WHEN 'king' THEN 'kingdom'
    WHEN 'prince' THEN 'principality'
    WHEN 'grand duke' THEN 'grand duchy'
    WHEN 'archduke' THEN 'archduchy'
    WHEN 'duke' THEN 'duchy'
    WHEN 'marquess' THEN 'march'
    WHEN 'landgrave' THEN 'landgrave'
    WHEN 'count' THEN 'county'
    WHEN 'earl' THEN 'earldom'
    WHEN 'viscount' THEN 'viscounty'
    WHEN 'baron' THEN 'barony'
    WHEN 'baronet' THEN 'baronet'
    WHEN 'lord' THEN 'local important'
    WHEN 'knight' THEN 'knight'
    WHEN 'esquire' THEN 'esquire'
    WHEN 'sultan' THEN 'kingdom'
    WHEN 'shah' THEN 'empire'
    WHEN 'rajah' THEN 'principality'
    WHEN 'maharajah' THEN 'kingdom'
    WHEN 'samrajah' THEN 'empire'
    WHEN 'khan' THEN 'march'
    WHEN 'czar' THEN 'empire'
    WHEN 'tsar' THEN 'empire'
    WHEN 'pharaoh' THEN 'kingdom'
    WHEN 'elector' THEN 'duchy'          -- or 'march' if you want them as border princes
    WHEN 'margrave' THEN 'march'
    WHEN 'jarl' THEN 'county'            -- strong regional lord
    WHEN 'thane' THEN 'barony'           -- lesser local noble
    WHEN 'boyar' THEN 'estate'           -- powerful landholder
    WHEN 'doge' THEN 'major city'        -- city‑state ruler
    WHEN 'high vaxitalian' THEN 'principality'
    WHEN 'vaxitalian' THEN 'major important'
    WHEN 'grand baron' THEN 'earldom'
    WHEN 'suma baron' THEN 'viscounty'
    WHEN 'over duke' THEN 'archduchy'
    WHEN 'abra duke' THEN 'earldom'
    WHEN 'suma duke' THEN 'duchy'
    WHEN 'lord montcastle' THEN 'castellan'
    WHEN 'grandee' THEN 'estate'
    WHEN 'abra grandee' THEN 'estate'
    WHEN 'grand magnate' THEN 'estate'
    WHEN 'magnate' THEN 'estate'
    WHEN 'high lord' THEN 'local important'
    WHEN 'true lord' THEN 'local important'
    WHEN 'suma lord' THEN 'local important'
    WHEN 'majestor' THEN 'empire'
    WHEN 'paraduke' THEN 'march'
    WHEN 'archcount' THEN 'landgrave'
    WHEN 'paracount' THEN 'viscounty'
    WHEN 'archbaron' THEN 'earldom'
    WHEN 'demibaron' THEN 'baronet'
    WHEN 'satrap' THEN 'kingdom'
    WHEN 'padishah emperor' THEN 'empire'
    WHEN 'trade prince' THEN 'major guild'
    -- Faith Titles
    WHEN 'caliph' THEN 'major faith'
    WHEN 'high priest' THEN 'major faith'
    WHEN 'priest' THEN 'local faith'
    WHEN 'cardinal' THEN 'regional faith'
    WHEN 'friar' THEN 'local faith'
    WHEN 'archbishop' THEN 'archbishopric'
    WHEN 'bishop' THEN 'bishopric'
    WHEN 'abbot' THEN 'abbey'
    WHEN 'prior' THEN 'temple'
    WHEN 'archmage' THEN 'major important'
    WHEN 'magister' THEN 'regional important'
    -- Other / dowager titles
    WHEN 'widower emperor' THEN 'empire'
    WHEN 'widower duke' THEN 'duchy'
    WHEN 'widower marquess' THEN 'march'
    WHEN 'widower count' THEN 'county'
    WHEN 'widower baron' THEN 'barony'
    WHEN 'widower' THEN 'principality' -- generic very-high-status widow(er)
    WHEN 'tribune' THEN 'tribune'
    WHEN 'merchant' THEN 'merchant'
    WHEN 'artisan' THEN 'artisan'
    WHEN 'master artisan' THEN 'master artisan'
    WHEN 'tradesman' THEN 'tradesman'
    WHEN 'master tradesman' THEN 'master tradesman'
    WHEN 'property owner' THEN 'property owner'
    WHEN 'estate' THEN 'Estate'
    WHEN 'steward' THEN 'steward'
    WHEN 'castellan' THEN 'castellan'
    WHEN 'reeve' THEN 'reeve'
    WHEN 'gentleman' THEN 'gentleman'
    WHEN 'aristocrat' THEN 'gentleman'
    WHEN 'aristocrat, single' THEN 'gentleman'
    WHEN 'yeoman' THEN 'property owner'
    WHEN 'freeman' THEN 'property owner'
    WHEN 'ensign' THEN 'ensign'
    WHEN 'lictor' THEN 'major general'
    WHEN 'paralictor' THEN 'captain'
    WHEN 'maralictor' THEN 'lieutenant'
    WHEN 'talon captain' THEN 'captain'
    WHEN 'steel falcon' THEN 'tradesman'
    WHEN 'whispering agent' THEN 'tradesman'
    WHEN 'skipper' THEN 'lieutenant'
    WHEN 'overseer' THEN 'warden'
    WHEN 'overlord' THEN 'barony'
    WHEN 'overking' THEN 'king'
    WHEN 'first mate' THEN 'lieutenant'
    WHEN 'cook' THEN 'tradesman'
    WHEN 'quartermaster' THEN 'ensign'
    WHEN 'boatswain' THEN 'sergeant'
    WHEN 'sailor' THEN 'private'
    WHEN 'chief' THEN 'local important'
    ELSE NULL
  END;
-- END GLOBAL TITLES SEED BLOCK

-- Fix sequences for all tables with manual ID inserts
SELECT setval('roles_id_seq', (SELECT MAX(id) FROM roles));
SELECT setval('attitude_id_seq', (SELECT MAX(id) FROM attitude));
-- Add any others that manually insert IDs

-- Save seed
COMMIT;