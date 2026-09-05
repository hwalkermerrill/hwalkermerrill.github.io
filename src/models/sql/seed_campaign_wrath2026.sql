-- ============================================
-- BEGIN SEED MAP ITEMS FOR WRATH
-- ============================================

WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE id = 18
)
INSERT INTO items (
  campaign_id,
  item_type,
  item_subtype,
  sort_order,
  is_identified,
  item_name,
  description
)
VALUES
  -- 1. Map of Kenabres (city)
  ((SELECT campaign_id FROM c_id),
    'map',
    'city',
    1,
    TRUE,
    'Map of Kenabres',
    NULL
  ),

  -- 2. Map of Destroyed Kenabres (city)
  ((SELECT campaign_id FROM c_id),
    'map',
    'city',
    2,
    TRUE,
    'Map of Destroyed Kenabres',
    NULL
  )
ON CONFLICT DO NOTHING;

-- ============================================
-- BEGIN SEED MAP GALLERY FOR WRATH
-- ============================================

WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE id = 18
),
i_id AS (
  SELECT id AS item_id, item_name
  FROM items
  WHERE campaign_id = (SELECT campaign_id FROM c_id)
)
INSERT INTO item_gallery (
  item_id,
  image_url,
  alt,
  is_main,
  is_tall
)
VALUES
  -- Main Kenabres map
  ((SELECT item_id FROM i_id
      WHERE item_name = 'Map of Kenabres'),
    '/images/map/map-kenabres-main.webp',
    'Map of Kenabres',
    TRUE,
    TRUE
  ),

  -- Destroyed Kenabres map
  ((SELECT item_id FROM i_id
      WHERE item_name = 'Map of Destroyed Kenabres'),
    '/images/map/map-kenabres-full.jpg',
    'Map of Destroyed Kenabres',
    FALSE,
    TRUE
  )
ON CONFLICT DO NOTHING;

-- ============================================
-- END WRATH MAP SEED BLOCK
-- ============================================

-- ============================================
-- BEGIN WRATH LOCATION SPOTLIGHT SEED
-- ============================================

-- 1. Insert the session_log entry
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE id = 18
)
INSERT INTO session_logs (
  campaign_id,
  session_number,
  title,
  log_type
)
VALUES
  ((SELECT campaign_id FROM c_id),
    1,
    'Kanabres at a Glance',
    'location spotlight'
  )
ON CONFLICT (campaign_id, log_type, session_number) DO NOTHING;

-- ============================================
-- 2. Insert the gallery image
-- ============================================

WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE id = 18
),
sl_id AS (
  SELECT session_number, id AS session_log_id
  FROM session_logs
  WHERE campaign_id = (SELECT campaign_id FROM c_id)
    AND log_type = 'location spotlight'
)
INSERT INTO session_log_gallery (
  session_log_id,
  image_url,
  alt,
  is_tall
)
VALUES
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 1),
    '/images/hero/hero-kenabres.webp',
    'Kanabres, Bulwark of the Crusades',
    FALSE
  )
ON CONFLICT DO NOTHING;

-- ============================================
-- 3. Insert the paragraphs
-- ============================================

WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE id = 18
),
sl_id AS (
  SELECT session_number, id AS session_log_id
  FROM session_logs
  WHERE campaign_id = (SELECT campaign_id FROM c_id)
    AND log_type = 'location spotlight'
)
INSERT INTO session_log_paragraphs (
  session_log_id,
  paragraph_order,
  paragraph_text
)
VALUES
  -- Paragraph 1
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 1),
    1,
    'The city of Kenabres overlooks the Worldwound from its perch on the eastern bluffs above the West Sellen River. The townsfolk of Kenabres were an industrious, innovative people who constructed a complex system to pump water from the river up to the safety of the town. After the opening of the Worldwound, the town swelled from less than 3,000 to more than 8,000 in a mere decade, due to the constant flow of refugees, researchers, and adventure-seekers, with many of these new citizens being put to work at Truestone Quarry to meet the endless demand for worked stone as the city continued to fortify and expand.'
  ),

  -- Paragraph 2
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 1),
    2,
    'After the Second Crusade, the church of Iomedae built a shielded stone keep to house Kenabres''s wardstone, known as the Kite of Kenabres. The keystone in a series set along the border with the Worldwound, the wardstone keeps demonic forces from crossing the line between it and its neighbors. Meanwhile, the wardstone blesses the waters pumped back into the West Sellen River with its holy power, preventing demons from swimming downstream into the more rural and undefended kingdoms to the south. Between the Kite of Kenabres and the city’s other fortifications, Kenabres has become the strong bulwark for the crusades, and the natural and historical staging point for crusaders. Today, the more than 12,000 inhabitants live almost entirely within the fortifications, while even more gathering crusaders make camp outside the walls to the north of the city.'
  ),

  -- Paragraph 3
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 1),
    3,
    'The Mendevian Crusaders riding out from the city have slain countless demons, and many of them have been carried back to town on their shields to be interred in the catacombs beneath the Cathedral of Saint Clydwell. However, some of these same crusaders—many of them even immortalized in the Hall of Heroes—spent years hunting supposedly demon-tainted faiths and burning at the stake cultists and innocent Mendevians alike. The frequency and intensity of these pogroms have diminished, but the dark history of Kenabres remains ever-present in the minds of its leaders and many of its citizens, and even the most stalwart citizens shudder at the sight of Iomedaean vestments tinged with the orange flames of the witch hunters, who have not-quite limitless power granted them by the city''s prelate inquisitor, Lord Hulrun.'
  ),

  -- Paragraph 4
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 1),
    4,
    'Characters that were raised in Kenabres have for all their lives known the preparation for war and the threat of attack. Even the youngest adventurers from the city have seen the town grow and change in their lifetimes, and have witnessed an ever-changing collection of crusaders passing through. Living in the shadow of a demonic threat is different than living in a normal war-torn land: the looming enemy cannot easily be understood or related to, nor can the demons'' motivations be analyzed and exploited. Growing up with such a threat always present is sure to color the worldview of a young adventurer.'
  )
ON CONFLICT DO NOTHING;

-- ============================================
-- END WRATH LOCATION SPOTLIGHT SEED
-- ============================================

-- ============================================
-- BEGIN WRATH ARTIFACT SEED: Terendelev's Scales
-- ============================================

WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE id = 18
)
INSERT INTO items (
  campaign_id,
  active_status_id,
  item_type,
  item_subtype,
  sort_order,
  is_identified,
  item_name,
  description,
  ability,
  unlocked_boons,
  destruction_method,
  boons_visible,
  unique_destruction
)
VALUES
  ((SELECT campaign_id FROM c_id),
    1,
    'artifact',
    'item',
    NULL,
    TRUE,
    'Terendelev''s Scales',
    'These palm-sized silver dragon scales are minor artifacts resulting from Terendelev''s death to the Storm King''s blade.',
    'Each of Terendelev''s scales weighs 2lbs and grants a different power to the person who carries them. The powers granted do not function at all if more than one scale is carried. The powers of the scales are immediately understood by any nonevil creature that handles them, though they may only be used by a creature who has been marked by Terendelev. Each scale may be activated 3/day as a standard action to cast a spell-like ability of Terendelev at CL19. If the scale duplicates a spell that can be cast on others, it may be used on others normally. These scales return to the possession of the creature who was originally marked and received it from Terendelev after 20 minutes of being lost or given away.',
    'The seven scales received grant the powers of Cloudwalking, Disguise, Fog Vision, Grace, Icy Breath, Resistance, and Sacred Weaponry.',
    'The Storm King Khorramzadeh can destroy each of Terendelev''s scales merely by eating it, and the scales lose their power while the creature who was originally marked and received it from Terendelev is evil or no longer alive.',
    FALSE,
    TRUE
  )
ON CONFLICT (campaign_id, item_name) DO NOTHING;

-- ============================================
-- BEGIN WRATH ARTIFACT GALLERY SEED
-- ============================================

WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE id = 18
),
i_id AS (
  SELECT id AS item_id, item_name
  FROM items
  WHERE campaign_id = (SELECT campaign_id FROM c_id)
)
INSERT INTO item_gallery (
  item_id,
  image_url,
  alt,
  is_main
)
VALUES
  ((SELECT item_id FROM i_id
      WHERE item_name = 'Terendelev''s Scales'),
    '/images/objects/artifact-terendelevs-scales.webp',
    'Terendelev''s Scales',
    TRUE
  )
ON CONFLICT DO NOTHING;

-- ============================================
-- END WRATH ARTIFACT SEED
-- ============================================

-- ============================================================
-- NPC MAIN SEED
-- ============================================================
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE id = 18
)
INSERT INTO npc_main (
  campaign_id,
  active_status_id,
  race_id,
  npc_name,
  is_identified,
  secret_name,
  show_secret_name,
  secret_color,
  is_gendered,
  is_female
)
VALUES
-- Anevia Tirabade
((SELECT campaign_id FROM c_id),
  2,        -- active
  2,        -- human
  'Anevia Tirabade',
  TRUE,
  NULL,
  FALSE,
  NULL,
  TRUE,
  TRUE
),

-- Aravashnial
((SELECT campaign_id FROM c_id),
  2,        -- active
  4,        -- elf
  'Aravashnial',
  TRUE,
  NULL,
  FALSE,
  NULL,
  TRUE,
  FALSE
),

-- Horgus Gwerm
((SELECT campaign_id FROM c_id),
  2,        -- active
  2,        -- human
  'Horgus Gwerm',
  TRUE,
  NULL,
  FALSE,
  NULL,
  TRUE,
  FALSE
),

-- Irabeth Tirabade
((SELECT campaign_id FROM c_id),
  1,        -- pending
  8,        -- half-orc
  'Irabeth Tirabade',
  TRUE,
  NULL,
  FALSE,
  NULL,
  TRUE,
  TRUE
)
ON CONFLICT (campaign_id, npc_name) DO NOTHING;

-- ============================================================
-- NPC ATTITUDE SEED
-- ============================================================
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE id = 18
)
INSERT INTO npc_attitude (
  npc_id,
  attitude_id,
  hostile_boon,
  unfriendly_boon,
  friendly_boon,
  helpful_boon
)
VALUES
-- Anevia Tirabade (Friendly)
((SELECT id FROM npc_main
    WHERE npc_name = 'Anevia Tirabade'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
  4,
  NULL, NULL, NULL, NULL
),

-- Aravashnial (Indifferent)
((SELECT id FROM npc_main
    WHERE npc_name = 'Aravashnial'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
  3,
  NULL, NULL, NULL, NULL
),

-- Horgus Gwerm (Unfriendly)
((SELECT id FROM npc_main
    WHERE npc_name = 'Horgus Gwerm'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
  2,
  NULL, NULL, NULL, NULL
),

-- Irabeth Tirabade (Indifferent for now)
((SELECT id FROM npc_main
    WHERE npc_name = 'Irabeth Tirabade'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
  3,
  NULL, NULL, NULL, NULL
)
ON CONFLICT (npc_id) DO NOTHING;

-- ============================================================
-- NPC SOCIAL SEED
-- ============================================================
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE id = 18
)
INSERT INTO npc_social (
  npc_id,
  appearance,
  background,
  extra_details,
  hidden_details,
  reveal_hidden_details,
  secrets
)
VALUES
-- Anevia Tirabade
((SELECT id FROM npc_main
    WHERE npc_name = 'Anevia Tirabade'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
  'Anevia has a moderately fair complexion and dark auburn hair and she wears the lighter armor of a crusading scout. Her feminine features are toughened somewhat by her hard expressions, and while generally friendly and witty, she speaks frankly and often acts with quiet stoicism.',
  'Anevia is a semi-retired adventurer after falling in love with and marrying a crusader. She keeps quiet about her past, guarding it carefully, but her tithes to Desna, Iomedae, and Shelyn suggest she now lives a faith-filled life, and may either feel a debt to those deities in particular, or else have other reasons for needing hope, strength, and mercy every day.',
  NULL,
  NULL,
  FALSE,
  NULL
),

-- Aravashnial
((SELECT id FROM npc_main
    WHERE npc_name = 'Aravashnial'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
  'Aravashnial''s elven face has been ruined by Khorramzadeh the Storm King, but his otherwise fair and graceful features suggest he was once quite handsome. He dresses finely yet practically for a researcher and spellcaster heading into the field, and he stands as someone who''s never had to learn to bow. Humility has never been one of his defining traits, and he speaks with a harsh bitterness.',
  'A Kyonin elf specializing in conjuration—rather than his family''s specialty of abjuration—Aravashnial is obsessed with the demon Treerazer and the stain he leaves on his hometown of Tanglebriar. After concluding that without aid, the best hope for his people was a continued stalemate, he joined the crusades in hopes of learning better how to fight demons. Since his short time here, he''s become known as a powerful wizard and spellcaster for hire, as well as a somewhat outrageous conspiracy theorist.',
  'Aravashnial is a Riftwarden, a member of a secretive society dedicated to opposing the Blackfire Adepts and any others who would use planar portals and gateways to undermine or assault the Material Plane. After suffering his injury at the hands of Khorramzadeh the Storm King, he was literally unmasked, and now speaks openly in favor of the group, sometimes promising things on their behalf.',
  NULL,
  FALSE,
  NULL
),

-- Horgus Gwerm
((SELECT id FROM npc_main
    WHERE npc_name = 'Horgus Gwerm'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
  'Horgus Gwerm is an arrogant, acerbic, middle-aged nobleman with an inflated sense of his own importance. He is relatively homely, wears flashy jewelry and fine furs, and increasingly has more golden trim in his clothing than he has hair remaining on his thinning head, though he is never at a loss for female companionship. His speech is only infrequently buffered by tact, and he acts genuinely shocked and offended when others don''t recognize him and his status.',
  'Horgus is one of the largest investors in Truestone Quarry, and gets a percentage of the profits on every rock and stone in Kenabres. The last surviving member of his particular family branch, he long ago vowed that a lack of money would not be the thing that does him in in the end. He is miserly with his money, rarely purchasing anything and haggling over every copper, but when he does buy something, he always goes for quality. The majority of his funds go to improving and reinforcing his manor home and its fortifications, while his second largest expense appears to be taxes, something he prides himself in paying promptly and exactly.',
  NULL,
  NULL,
  FALSE,
  NULL
),

-- Irabeth Tirabade
((SELECT id FROM npc_main
    WHERE npc_name = 'Irabeth Tirabade'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
  'Commander Irabeth wears resplendent armor and bears the insignia of a Paladin of Iomedae, the morningstar of an Eagle Knight, and the shield of a Defender of Kenabres. She has green skin, wild black hair, and a slender underbite. She is remarkably even tempered, honorable, and restrained, which is unusual for a crusader but downright shocking for a half-orc.',
  'A farmgirl from a family of crusaders living a few days east of Kenabres, she journeyed to Lastwall to become a crusader. Her time in Vigil faced more racism and prejudice than she ever faced in Kenabres, and while she managed to become a paladin, she was denied entrance to the Crusader War College and entry to knighthood. She instead spent years as a traveling Justicar in the River Kingdoms before returning to Kenabres, where she became a respected mercenary leader and Eagle Knight.',
  NULL,
  NULL,
  FALSE,
  NULL
)
ON CONFLICT (npc_id) DO NOTHING;

-- ============================================================
-- NPC GALLERY SEED
-- ============================================================
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE id = 18
)
INSERT INTO npc_gallery (
  npc_id,
  image_url,
  alt,
  is_main,
  is_hover,
  hover_visible,
  is_tall
)
VALUES
-- Anevia Tirabade
((SELECT id FROM npc_main
    WHERE npc_name = 'Anevia Tirabade'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
  '/images/npc/comp-anevia-tirabade-hurt.webp',
  'Anevia Tirabade Hurt',
  TRUE,
  FALSE,
  FALSE,
  TRUE
),

-- Aravashnial
((SELECT id FROM npc_main
    WHERE npc_name = 'Aravashnial'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
  '/images/npc/comp-aravashnial-hurt.webp',
  'Aravashnial Hurt',
  TRUE,
  FALSE,
  FALSE,
  TRUE
),

-- Horgus Gwerm
((SELECT id FROM npc_main
    WHERE npc_name = 'Horgus Gwerm'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
  '/images/npc/comp-horgus-gwerm-hurt.webp',
  'Horgus Gwerm Hurt',
  TRUE,
  FALSE,
  FALSE,
  TRUE
),

-- Irabeth Tirabade
((SELECT id FROM npc_main
    WHERE npc_name = 'Irabeth Tirabade'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
  '/images/npc/comp-irabeth-tirabade-full.webp',
  'Irabeth Tirabade Full',
  TRUE,
  FALSE,
  FALSE,
  TRUE
)
ON CONFLICT DO NOTHING;

-- End NPC Seed

-- ============================================
-- PC SEED DATA FOR CAMPAIGN 18
-- ============================================

INSERT INTO pc_main (
  user_id,
  campaign_id,
  active_status_id,
  race_id,
  pc_name,
  is_identified,
  is_female,
  campaign_trait
)
VALUES
  (2, 18, 2, 7,  'Ravamir',            TRUE, FALSE, 'Stolen Fury'),
  (3, 18, 2, 2,  'Stark',              TRUE, FALSE, 'Change Encounter'),
  (4, 18, 2, 2,  'Syre',               TRUE, FALSE, 'Riftwarden Orphan'),
  (5, 18, 2, 20, 'Palamedes',          TRUE, FALSE, 'Chance Encounter'),
  (6, 18, 2, 2,  'Dorian',             TRUE, FALSE, 'Touched by Divinity'),
  (7, 18, 2, 38, 'Bukka',              TRUE, FALSE, 'Touched by Divinity'),
  (8, 18, 2, 27, 'Serenity Dragomir',  TRUE, TRUE,  'Child of the Crusades')
ON CONFLICT (user_id, campaign_id, pc_name) DO NOTHING;

-- ============================================
-- PC GALLERY SEED DATA
-- ============================================

INSERT INTO pc_gallery (
  pc_id,
  image_url,
  alt,
  is_main,
  is_hover,
  hover_visible,
  is_tall
)
VALUES
  -- Syre
  (3, '/images/pc/pc-syre-forvirre.webp',
      'Syre Character Portrait',
      TRUE, FALSE, FALSE, TRUE),

  -- Palamedes (main)
  (4, '/images/pc/pc-palamedes.webp',
      'Palamedes Character Portrait',
      TRUE, FALSE, FALSE, TRUE),

  -- Palamedes (hover)
  (4, '/images/pc/pc-palamedes-combat-stance.webp',
      'Palamedes Combat Stance',
      FALSE, TRUE, TRUE, TRUE),

  -- Bukka
  (6, '/images/pc/pc-bukka.webp',
      'Bukka Character Portrait',
      TRUE, FALSE, FALSE, TRUE),

  -- Serenity Dragomir
  (7, '/images/pc/pc-serenity-dragomir.webp',
      'Serenity Character Portrait',
      TRUE, FALSE, FALSE, TRUE),

	-- Stark
  (2, '/images/pc/pc-stark.webp',
      'Serenity Character Portrait',
      TRUE, FALSE, FALSE, TRUE);