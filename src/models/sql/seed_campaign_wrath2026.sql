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