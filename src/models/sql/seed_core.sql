-- Database seed file for existing data and initial setup

BEGIN;

-- START GLOBAL LOOKUP TABLES SEED BLOCK
-- Seed Active_Status (idempotent - safe to run multiple times)
INSERT INTO active_status (id, active_status_name)
VALUES (1, 'PENDING')
ON CONFLICT (id) DO NOTHING;

INSERT INTO active_status (active_status_name)
VALUES (
  ('Active'),
  ('Retired'),
  ('Deceased')
)
ON CONFLICT (active_status_name) DO NOTHING;
-- End Active_Status Seeds

-- Seed Attitude (idempotent - safe to run multiple times)
INSERT INTO attitude (id, attitude_name)
VALUES (
  (1, 'Hostile'),
  (2, 'Unfriendly'),
  (3, 'Neutral'),
  (4, 'Friendly'),
  (5, 'Helpful'),
  (6, 'Indifferent')
)
ON CONFLICT (id) DO NOTHING;
-- End Attitude Seeds

-- Seed Speeds (idempotent - safe to run multiple times)
INSERT INTO speed (id, speed_name)
VALUES (1, 'Base')
ON CONFLICT (id) DO NOTHING;

INSERT INTO speed (speed_name)
VALUES (
  ('Climb'),
  ('Swim'),
  ('Fly'),
  ('Burrow')
)
ON CONFLICT (speed_name) DO NOTHING;
-- End Speed Seeds

-- Seed Classes (idempotent - safe to run multiple times)
INSERT INTO classes (id, class_name, source)
VALUES (1, 'Unknown', 'Core')
ON CONFLICT (id) DO NOTHING;


INSERT INTO classes (class_name, source, class_type, magic_type, caster_spontaneous, has_companion)
VALUES ( -- Core Rulebook classes
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
)
ON CONFLICT (class_name) DO NOTHING;

INSERT INTO classes (class_name, source, class_type)
VALUES (-- NPC classes
  ('Adept', 'NPC', 'Magic'),
  ('Aristocrat', 'NPC', 'Skill'),
  ('Commoner', 'NPC', 'Martial'),
  ('Expert', 'NPC', 'Skill'),
  ('Warrior', 'NPC', 'Martial')
)
ON CONFLICT (class_name) DO NOTHING;

INSERT INTO classes (class_name, source, class_type)
VALUES (-- Prestige Classes
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
)
ON CONFLICT (class_name) DO NOTHING;

-- Seed Races (idempotent - safe to run multiple times)
INSERT INTO race (id, race_name)
VALUES (1, 'Unknown')
ON CONFLICT (id) DO NOTHING;


INSERT INTO race (race_name, limited)
VALUES (-- Core Races
  ('Human', FALSE),
  ('Dwarf', FALSE),
  ('Elf', FALSE),
  ('Gnome', FALSE),
  ('Halfling', FALSE),
  ('Half-Elf', FALSE),
  ('Half-Orc', FALSE)
)
ON CONFLICT (race_name) DO NOTHING;

INSERT INTO race (race_name)
VALUES (-- Standard Races
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
  ('Merfolk'),
  ('Munavri'),
  ('Nagaji'),
  ('Orang-Pendak'),
  ('Reptoid'),
  ('Samsaran'),
  ('Strix'),
  ('Wayang')
)
ON CONFLICT (race_name) DO NOTHING;
-- End Race Seeds

-- Seed Religions   (idempotent - safe to run multiple times)
INSERT INTO religions (id, religion_name)
VALUES (-- reserve 1 - 5
  (1, 'Unknown'),
  (2, 'Atheist'),
  (3, 'Concept'),
  (4, 'Ancestors'),
  (5, 'Totem Spirits')
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO religions (religion_name)
VALUES (-- Core 20 deities from Golarion (Pathfinder 1e)
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
)
ON CONFLICT (religion_name) DO NOTHING;

INSERT INTO religions (religion_name, obscurity)
VALUES (-- Major Religious Groups
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
  ('Hei Feng (Tian Xia)', 'Regional'),
  ('Tsukiyo (Tian Xia)', 'Regional'),
  ('Daikitsu (Tian Xia)', 'Regional'),
  ('Shizuru (Tian Xia)', 'Regional'),
  -- Regional Faiths - Vudran (Hindi)
  ('Irori (Vudra)', 'Regional'),
  ('Chohar', 'Regional'),
  ('Gruhastha', 'Regional'),
  ('Lahkgya', 'Regional'),
  ('Nalinivati', 'Regional'),
  ('Vineshvakhi', 'Regional'),
  -- Regional Faiths -City/Nation Patrons
  ('Besmara (Shackles Regional Cult)', 'Regional'),
  ('Walkena (Mzali)', 'Regional'),
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
  ('Hei Feng', 'Racial'),
  ('Tsukiyo', 'Racial'),
  ('Daikitsu', 'Racial'),
  ('Shizuru', 'Racial'),
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
  ('Besmara', 'Uncommon'),
  ('Black Butterfly', 'Uncommon'),
  ('Brigh', 'Uncommon'),
  ('Groetus', 'Uncommon'),
  ('Ghlaunder', 'Uncommon'),
  ('Gyronna', 'Uncommon'),
  ('Hanspur', 'Uncommon'),
  ('Milani', 'Uncommon'),
  ('Pulura', 'Uncommon'),
  ('Ragathiel', 'Uncommon'),
  ('Sivanah', 'Uncommon'),
  ('Vildeis', 'Uncommon'),
  ('Zyphus', 'Uncommon'),
  ('Cihua', 'Uncommon'),
  ('Kurgess', 'Uncommon'),
  ('Kazutal', 'Uncommon'),
  ('Mazludeh', 'Uncommon'),
  ('Besmara (Shackles)', 'Uncommon'),
  ('Hei Feng', 'Uncommon'),
  ('Tsukiyo', 'Uncommon'),
  ('Daikitsu', 'Uncommon'),
  ('Shizuru', 'Uncommon'),
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
  ('Easivra', 'Obscure'),
  ('Picoperi', 'Obscure'),
  ('Hanspur (River Cult)', 'Obscure'),
  ('Groetus (Apocalyptic Cult)', 'Obscure')
)
ON CONFLICT (religion_name) DO NOTHING;
-- End Religion Seeds

-- Seed Languages (idempotent - safe to run multiple times)
INSERT INTO languages (id, language_name, is_recommended)
VALUES ( --reserving 1-2 for common and other
  (1, 'Common', TRUE),
  (2, 'Other', FALSE)
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO languages (language_name)
VALUES ( -- Ancestral / racial core
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
  ('Protean'),
  ('Daemonic'),
  ('Div'),
  ('Qlippothic'),
  ('Shadowtongue'),
  -- Widely referenced “other” tongues
  ('Aklo'),
  ('Alghollthu (Aboleth)'),
  ('Cyclops'),
  ('Dark Folk Cant'),
  ('Gnoll'),
  ('Grippli'),
  ('Necril'),
  ('Sahuagin'),
  ('Sphinx'),
  ('Treant'),
  ('Vegepygmy'),
  ('Yeti')
)
ON CONFLICT (language_name) DO NOTHING;

INSERT INTO languages (language_name, is_secret)
VALUES (-- Secret Languages
  ('Druidic (Wildsong)', TRUE),
  ('Drow Sign Language', TRUE),
  ('Thieves Cant', TRUE),
  ('Lion Blade Codespeak', TRUE)
)
ON CONFLICT (language_name) DO NOTHING;

INSERT INTO languages (language_name, is_dialect)
VALUES (-- Regional Dialects (usually human)
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
)
ON CONFLICT (language_name) DO NOTHING;

INSERT INTO languages (language_name, is_ancient)
VALUES (-- Ancient / Dead Languages
  ('Ancient Osiriani', TRUE),
  ('Ancient Azlanti', TRUE),
  ('Ancient Thassilonian', TRUE),
  ('Jistka', TRUE),
  ('Orvian', TRUE),
  ('Shory', TRUE),
  ('Tekritanin', TRUE)
)
ON CONFLICT (language_name) DO NOTHING;

INSERT INTO languages (language_name)
VALUES (-- Other Languages (expansion block space)
  ('Boggard'),
  ('Caligni'),
  ('Kech'),
  ('Syrinx'),
  ('Strix')
)
ON CONFLICT (language_name) DO NOTHING;
-- End Language Seeds
-- END GLOBAL LOOKUP TABLES SEED BLOCK

-- START GLOBAL TITLES SEED BLOCK (idempotent - safe to run multiple times)
INSERT INTO title_ranks (title_rank_name, sort_order)
VALUES (-- Rank order for backend sorting
  -- 1. Imperial Authority
  ('empire', 1),
  ('holy empire', 1),
  ('imperial advisor', 2),
  -- 2. National Authority
  ('kingdom', 3),
  ('national advisor', 4),
  ('high general', 4),
  ('major faith', 4),
  -- 3. Sub‑National Major Authority
  ('grand duchy', 5),
  ('archduchy', 5),
  ('archbishopric', 5),
  ('principality', 6),
  -- 4. Regional Authority
  ('duchy', 7),
  ('bishopric', 7),
  ('march', 8),
  ('landgrave', 8),
  ('major general', 8),
  ('major city', 8),
  ('major guild', 8),
  ('major important', 8),
  -- 5. Sub‑Regional Authority
  ('county', 9),
  ('earldom', 9),
  ('general', 9),
  ('temple', 9),
  ('regional important', 10),
  ('regional faith', 10),
  ('regional guild', 10),
  ('viscounty', 10),
  ('tribune', 10),
  ('colonel', 10),
  -- 6. Local Major Authority
  ('barony', 11),
  ('abbey', 11),
  ('city', 11),
  ('major', 11),
  ('captain', 12),
  ('guildmaster', 12),
  -- 7. Local Minor Authority
  ('baronet', 13),
  ('estate', 13),
  ('magistrate', 13),
  ('master artisan', 13),
  ('local important', 14),
  ('local faith', 14),
  ('warden', 14),
  ('steward', 14),
  ('castellan', 14),
  ('reeve', 14),
  ('property owner', 14),
  -- 8. Landless Nobility / Officer Class
  ('knight', 15),
  ('lieutenant', 15),
  ('esquire', 16),
  ('gentleman', 16),
  ('ensign', 16),
  ('sergeant', 16),
  -- 9. Wealth‑Based Authority
  ('merchant', 17),
  ('corporal', 17),
  ('artisan', 17),
  ('tradesman', 18),
  ('guard', 18),
  ('private', 18)
)
ON CONFLICT (title_rank_name) DO NOTHING;

INSERT INTO titles (title_name, honorific_masculine, prefix_masculine)
VALUES (-- Gender-Neutral Titles
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
  ('magistrate', 'Magistrate', 'Magistrate'),
  ('warden', 'Warden', 'Warden')
)
ON CONFLICT (title_name) DO NOTHING;

INSERT INTO titles (title_name, name_feminine, honorific_masculine, honorific_feminine, prefix_masculine, prefix_feminine)
VALUES (-- Noble Titles
  ('emperor', 'empress', 'His Imperial Majesty', 'Her Imperial Majesty', 'Emperor', 'Empress'),
  ('king', 'queen', 'His Majesty', 'Her Majesty', 'King', 'Queen'),
  ('prince', 'princess', 'His Highness', 'Her Highness', 'Prince', 'Princess'),
  ('grand duke', 'grand duchess', 'His Grace', 'Her Grace', 'Grand Duke', 'Grand Duchess'),
  ('archduke', 'archduchess', 'His Imperial Highness', 'Her Imperial Highness', 'Archduke', 'Archduchess'),
  ('duke', 'duchess', 'His Grace', 'Her Grace', 'Duke', 'Duchess'),
  ('marquess', 'marquise', 'His Illustriousness', 'Her Illustriousness', 'Marquis', 'Marchioness'),
  ('count', 'countess', 'His Lordship', 'Her Ladyship', 'Count', 'Countess'),
  ('earl', 'countess', 'His Lordship', 'Her Ladyship', 'Earl', 'Countess'),
  ('viscount', 'viscountess', 'The Right Honorable', 'The Right Honorable', 'Viscount', 'Viscountess'),
  ('baron', 'baroness', 'His Lordship', 'Her Ladyship', 'Baron', 'Baroness'),
  ('baronet', 'baronetess', 'Sir', 'Dame', 'Baronet', 'Baronetess'),
  ('lord', 'lady', 'Lord', 'Lady', 'Lord', 'Lady'),
  ('knight', 'dame', 'Sir', 'Dame', 'Sir', 'Dame'),
  ('esquire', 'esquire', 'Esquire', 'Esquire', 'Esq.', 'Esq.')
)
ON CONFLICT (title_name) DO NOTHING;

INSERT INTO titles (title_name, name_feminine, honorific_masculine, honorific_feminine, prefix_masculine, prefix_feminine)
VALUES (-- Other Titles
  ('widower emperor', 'dowager empress', 'His Imperial Majesty', 'Her Imperial Majesty', 'Emperor', 'Empress'),
  ('widower duke', 'dowager duchess', 'His Grace', 'Her Grace', 'Duke', 'Duchess'),
  ('widower', 'dowager', 'His Grace', 'Her Grace', 'Widower', 'Dowager'),
  ('widower marquess', 'dowager marquess', 'His Illustriousness', 'Her Illustriousness', 'Marquess', 'Marquise'),
  ('widower count', 'dowager countess', 'His Excellency', 'Her Excellency', 'Count in Residence', 'Dowager Countess'),
  ('widower baron', 'dowager baroness', 'His Lordship', 'Her Lordship', 'Lord Baron', 'Lady Baroness')
)
ON CONFLICT (title_name) DO NOTHING;

-- Set rank_id for titles by name as Case (avoid nested select)
UPDATE titles AS t
SET rank_id = r.id
FROM title_ranks AS r
WHERE r.title_rank_name = CASE t.title_name
    WHEN 'hero, city' THEN 'local important'
    WHEN 'hero, regional' THEN 'regional important'
    WHEN 'hero, major' THEN 'major important'
    WHEN 'champion, city' THEN 'local important'
    WHEN 'champion, regional' THEN 'regional important'
    WHEN 'champion, major' THEN 'major important'
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
    WHEN 'widower emperor' THEN 'empire'
    WHEN 'widower duke' THEN 'duchy'
    WHEN 'widower' THEN 'principality'
    WHEN 'widower marquess' THEN 'march'
    WHEN 'widower count' THEN 'county'
    WHEN 'widower baron' THEN 'barony'
    WHEN 'guildmaster' THEN 'guildmaster'
    WHEN 'magistrate' THEN 'magistrate'
    WHEN 'warden' THEN 'warden'
  END;
-- END GLOBAL TITLES SEED BLOCK

-- Save seed
COMMIT;
