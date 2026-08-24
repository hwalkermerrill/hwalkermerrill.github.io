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
