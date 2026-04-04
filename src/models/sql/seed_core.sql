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

-- Seed Religions, reserve 1-5
INSERT INTO religions (id, name)
  VALUES
    (1, 'Unknown'),
    (2, 'Atheist'),
    (3, 'Concept'),
    (4, 'Ancestors'),
    (5, 'Totem Spirits')
  ON CONFLICT (id) DO NOTHING;
-- Core 20 deities from Golarion (Pathfinder 1e)
INSERT INTO religions (name)
  VALUES
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
  ON CONFLICT (name) DO NOTHING;
-- Major Religious Groups
INSERT INTO religions (name, obscurity)
  Values
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
    ('Whispering Way', 'Regional')
  ON CONFLICT (name) DO NOTHING;
-- Regional Faiths
INSERT INTO religions (name, obscurity)
  Values
    --Mwangi / Arcadia
    ('Angazhan', 'Regional'),
    ('Chamidu', 'Regional'),
    ('Balumbdar', 'Regional'),
    ('Iomedae (Mwangi)', 'Regional'),
    ('Grandmother Spider', 'Regional'),
    ('Old-Mage Jatembe', 'Regional'),
    ('Ragdya', 'Regional'),
    ('Shelyn (Mwangi)', 'Regional'),
    ('Shimye-Magalla', 'Regional'),
    --Osirion
    ('Anubis', 'Regional'),
    ('Bastet', 'Regional'),
    ('Horus', 'Regional'),
    ('Isis', 'Regional'),
    ('Nethys (Osirion)', 'Regional'),
    ('Ra', 'Regional'),
    ('Sobek', 'Regional'),
    ('Thoth', 'Regional'),
    -- Tian Xia
    ('Hei Feng (Tian Xia)', 'Regional'),
    ('Tsukiyo (Tian Xia)', 'Regional'),
    ('Daikitsu (Tian Xia)', 'Regional'),
    ('Shizuru (Tian Xia)', 'Regional'),
    -- Vudran (Hindi)
    ('Irori (Vudra)', 'Regional'),
    ('Chohar', 'Regional'),
    ('Gruhastha', 'Regional'),
    ('Lahkgya', 'Regional'),
    ('Nalinivati', 'Regional'),
    ('Vineshvakhi', 'Regional'),
    --City/Nation Patrons
    ('Besmara (Shackles Regional Cult)', 'Regional'),
    ('Walkena (Mzali)', 'Regional'),
    ('Achaekek (Red Mantis)', 'Regional')
    --Other/ Various
    ('Abadar (Localized)', 'Regional'),
    ('Lost Sun', 'Regional'),
    ('Sandpoint Pantheon', 'Regional')
  ON CONFLICT (name) DO NOTHING;
-- Racial Faiths
INSERT INTO religions (name, obscurity)
  Values
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
    ('Shizuru', 'Racial')
  ON CONFLICT (name) DO NOTHING;
-- Lost/Dead/Imprisoned/Pre-Transformed Gods
INSERT INTO religions (name, obscurity)
  Values
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
    ('Mazludeh', 'Lost')
  ON CONFLICT (name) DO NOTHING;
-- Recovered (Lost) or Promoted Gods
INSERT INTO religions (name, Obscurity)
  Values
    ('Nocticula', 'Obscure'),
    ('Easivra', 'Obscure'),
    ('Apsu', 'Racial'),
    ('Dahak', 'Racial'),
    ('Arazni', 'Regional')
  ON CONFLICT (name) DO NOTHING;
-- Other Uncommon Dieties
INSERT INTO religions (name)
  Values
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
    ('Shizuru', 'Uncommon')
  ON CONFLICT (name) DO NOTHING;
-- Other Obscure Dieties
INSERT INTO religions (name)
  Values
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
  ON CONFLICT (name) DO NOTHING;

-- Seed languages, reserving 1-2 for common and other
INSERT INTO languages (id, name, is_recommended)
  VALUES
    (1, 'Common', TRUE),
    (2, 'Other', FALSE)
  ON CONFLICT (id) DO NOTHING;
-- Core Languages (CRB + broadly useful tongues)
INSERT INTO languages (name)
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
  ON CONFLICT (name) DO NOTHING;
-- Secret Languages
INSERT INTO languages (name, is_secret)
  VALUES
    ('Druidic (Wildsong)', TRUE),
    ('Drow Sign Language', TRUE),
    ('Thieves Cant', TRUE),
    ('Lion Blade Codespeak', TRUE)
  ON CONFLICT (name) DO NOTHING;
-- Regional Dialects (usually human)
INSERT INTO languages (name, is_dialect)
  VALUES
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
  ON CONFLICT (name) DO NOTHING;
-- Ancient / Dead Languages
INSERT INTO languages (name, is_ancient)
  VALUES
    ('Ancient Osiriani', TRUE),
    ('Ancient Azlanti', TRUE),
    ('Ancient Thassilonian', TRUE),
    ('Jistka', TRUE),
    ('Orvian', TRUE),
    ('Shory', TRUE),
    ('Tekritanin', TRUE)
  ON CONFLICT (name) DO NOTHING;
-- Other Languages (nonhuman / setting-flavor, not already covered above)
INSERT INTO languages (name)
  VALUES
    -- You can treat this block as an extension space for future additions
    ('Boggard'),
    ('Caligni'),
    ('Kech'),
    ('Syrinx'),
    ('Strix')
  ON CONFLICT (name) DO NOTHING;
