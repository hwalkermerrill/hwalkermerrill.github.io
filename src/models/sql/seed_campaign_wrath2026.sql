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
      'Stark Character Portrait',
      TRUE, FALSE, FALSE, TRUE),

	-- Dorian
  (1, '/images/pc/pc-ravamir-briarstride.webp',
      'Ravamir Character Portrait',
      TRUE, FALSE, FALSE, TRUE),

	-- Ravamir
  (5, '/images/pc/pc-dorian-kalder.webp',
      'Dorian Character Portrait',
      TRUE, FALSE, FALSE, TRUE);

-- ============================================
-- CAMPAIGN TRAITS SEED DATA
-- ============================================

WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE id = 18
)
INSERT INTO campaign_traits (
  campaign_id,
  trait_name,
  description
)
VALUES
	((SELECT campaign_id FROM c_id),
    'Chance Encounter',
    'You always tended to get in over your head as a child, but your biggest youthful misadventure was the time you <q>accidentally</q> found yourself behind enemy lines
		in the Worldwound. You probably never would have made it back home to Kenabres if not for the help of a mysterious woman who helped you trick your 
		way through a group of cultists. The woman never told you her name, but you remember her beauty and a deep sense of sadness she seemed to carry with her. Her skill 
		with the bow was impressive as well, but the thing you remember most about her was the symbol of Desna she wore-she often held onto it without seeming to realize 
		it, as if the connection to the goddess was something she clung to in a sense of need, as someone might clutch at a rope while dangling over a vast pit. She left your side 
		a few moments before you were picked up by a patrol of crusaders, who finished the job of escorting you back to safety, and youve never seen her again. Ever since, youve 
		just been lucky when it comes to trickery. Once per day, if you fail an Acrobatics, Bluff, Disguise, Sleight of Hand, or Stealth check, you may immediately reroll that check 
		as a free action. You must take the second result, even if it is worse.
		<br>Associated Mythic Path: Trickster. 
		<br>Multiple Characters: You and other characters were all saved by the same mysterious woman in your childhood. This could have been the same event, or she could have saved you on 
		separate occasions-the discovery that someone else was saved by the mysterious stranger has resulted in a long friendship (or perhaps friendly rivalry) with the others 
		she rescued. '
  ),
	((SELECT campaign_id FROM c_id),
    'Child of the Crusade',
    'Your parents were members of the crusade, as were their parents before them. (If you are an elf, gnome, or other long-lived race, these could 
		be brothers or cousins instead, since its possible that the Worldwound simply didnt exist at a time before you were born.) The righteousness of the crusades 
		sometimes feels as if it runs in your very blood, and it bolsters you against demonic influence. Your parents may be alive still, or they may have perished 
		on a mission-that choice is up to you. You grew up knowing them, though, and their zeal and devotion to the crusade is the primary reason you feel the same way. 
		Theyve told you of other family members who have also been involved in the crusade, and its not uncommon for you to meet a distant cousin or long-lost aunt, uncle, 
		or other family member while traveling among the border towns of Mendev. This strong family tie bolsters your mind and sense of belonging to the crusade. Once 
		per day when you fail a saving throw against an effect created by a demon that would possess or incapacitate you mentally, you may immediately reroll that saving 
		throw as a free action. You must take the second result, even if it is worse.
		<br> Associated Mythic Path: Marshal. 
		<br> Multiple Characters: If other characters take this trait, you should all be related-you can be siblings, cousins, or even more distant relations, but you 
		should all be aware of this shared lineage. '
  ),
	((SELECT campaign_id FROM c_id),
    'Exposed to Awfulness',
    'When you were a child, you were nearly slain by a demon that managed to make its way through the wardstones into the lands beyond. The demon was slain before it could kill 
		you, but you lingered at deaths door in a coma for weeks before waking. Ever since then, youve unusually been hale and hearty, as if your body had endured its brush with 
		awfulness by becoming supernaturally fit. But still, the scars (whether physical or purely mental) of your brush with death remain, and nightmares of what could have happened often plague 
		your sleep. Something, be it your own personal force of will, some strange "infection" from the assault, or perhaps a combination of both, has made you stronger than before.
		Youre not sure what to make of the theories that you survived this exposure to awfulness because you yourself have some trace of demonic heritage that helped give you the advantage 
		you needed to survivebut whatever it was, youre glad for it! Your strange resistance to demonic attacks persists to this day. Once per day when you fail a saving 
		throw against an effect created by a demon that would kill or physically incapacitate you, you can immediately reroll that saving throw as a free action. You must take 
		the second result, even if it is worse. 
		<br> Associated Mythic Path: Guardian.
		<br> Multiple Characters: You and any others with this trait are related, if only distantly. You could be siblings or cousins - a condition that perhaps lends 
		some credence to the theory that all of you share more than just a common bloodline. '
  ),
	((SELECT campaign_id FROM c_id),
    'Riftwarden Orphan',
    'You bear a strange birthmark on your body-something youve learned is the Sign of the Seekers Spiral, a rune associated with the secret society known 
		as the Riftwardens. You have researched this rune, and have learned that the mark sometimes appears on the children of Riftwardens who have been exposed 
		to particularly strange planar energies. Unfortunately, you never knew your parents, for you were raised by a foster family in Kenabres. Your foster family has confirmed 
		that both of your parents were Riftwardens, and has further confirmed that your parents went missing on a secret mission into the Worldwound less than a month after you 
		were born. Youre not sure what happened to them, but youre certain theyre dead - and your gut tells you that the one who murdered them yet lives! In any event, youve long felt 
		magic in your blood, and casting spells comes easily to you. You gain a +2 trait bonus on all concentration checks.
		<br> Associated Mythic Path: Archmage.
		<br> Multiple Characters: You should be siblings with any other character that takes this trait, so that you share the same missing parents. Your parents could even be foster parents. '
  ),
	((SELECT campaign_id FROM c_id),
    'Stolen Fury',
		'You were forced to take part in a demonic ritual as a youth after having been captured by cultists. Whatever the rituals purpose may have been, it didnt work out the way your captors 
		envisioned - rather than corrupting your soul, you absorbed the rituals energy and made it your own before you escaped to safety. Ever since, youve been 
		haunted by strange nightmares about the ritual, and have long felt that the energies it bathed you in have changed you. Recently, those energies have changed 
		its as if youve finally managed to come to terms with your past and have turned the rituals aftereffects to your advantage, following the old adage of what doesnt 
		kill you makes you stronger. Youve been unable to learn more about the ritual or what it was for, but the question lingers in the back of your head to this day. This 
		nagging has instilled in you a fury against demonkind. Today, when you face demons in combat, those energies bolster your fury, granting you a +2 trait bonus on all 
		combat maneuver checks against demons. 
		<br> Associated Mythic Path: Champion.
		<br> Multiple Characters: You and any other PC who takes this trait were all part of the same ritual, and it was only by working together that you managed to escape-further, the support of your fellow 
		ritual survivors has played a key role in your coming to terms with it, and you retain a close bond of friendship (or perhaps a friendly rivalry) to this day. '
  ),
	((SELECT campaign_id FROM c_id),
    'Touched by Divinity',
    'As long as you can remember, youve had an unexplainable interest in one deity in particular. One of your parents may have been a priest of this deity, or you may have been an orphan raised 
		by the church, but these alone cannot explain your deep connection to the faith. Youve always felt calm and at ease in places holy to the deity, and often have 
		dreams about the god or goddess visiting you - most often in the form of a sacred animal or creature. Your faith is strong, even if you dont happen to be a divine 
		spellcaster - if you are a divine spellcaster, you should be a worshiper of this deity. You begin play with a silver holy symbol of your chosen deity for free. In addition, 
		choose one domain associated with your chosen deity. You gain the use of that domains 1st-level domain spell as a spell-like ability usable once per day (CL equals your character level).
		<br> Associated Mythic Path: Hierophant. 
		<br> Multiple Characters: If other characters choose this trait, you should all work together to decide what deity youre associated with-it should be the same deity shared by 
		all of you. You might even share the same dreams. '
  )
ON CONFLICT DO NOTHING;