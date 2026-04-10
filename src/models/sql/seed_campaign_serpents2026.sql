-- Database seed file for existing data and initial setup
BEGIN;

-- Seed campaign into structure for organization
INSERT INTO campaigns (campaign_name, description, start_date)
VALUES (
  'Serpents 2026',
  'Explore the endless jungle of the Mwangi Expanse in an Indiana-Jones style pulp adventure search for lost cities and ancient treasure.',
  '2024-06-08'
)
ON CONFLICT DO NOTHING;

-- BEGIN SEED SESSION LOGS BLOCK (Converted from journal.js)
-- Session_logs CTE
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
)
INSERT INTO session_logs (campaign_id, book_number, session_number, title)
VALUES
  ((SELECT campaign_id FROM c_id), 1, 1,  'Chapter 01 - Castaway'),
  ((SELECT campaign_id FROM c_id), 1, 2,  'Chapter 02 - The Wreck of the <i>Jenivere</i>'),
  ((SELECT campaign_id FROM c_id), 1, 3,  'Chapter 03 - Getting to Know Each Other'),
  ((SELECT campaign_id FROM c_id), 1, 4,  'Chapter 04 - A Ghost Captain and a Typhoon'),
  ((SELECT campaign_id FROM c_id), 1, 5,  'Chapter 05 - Poor Pezock'),
  ((SELECT campaign_id FROM c_id), 1, 6,  'Chapter 06 - The Money Pit'),
  ((SELECT campaign_id FROM c_id), 1, 7,  'Chapter 07 - The Silent Gray Island'),
  ((SELECT campaign_id FROM c_id), 1, 8,  'Chapter 08 - The Red Mountain Looms'),
  ((SELECT campaign_id FROM c_id), 1, 9,  'Chapter 09 - Charming Cannibals'),
  ((SELECT campaign_id FROM c_id), 1, 10, 'Chapter 10 - Shiv''ers and Snakes'),
  ((SELECT campaign_id FROM c_id), 2, 11, 'Chapter 11 - Picking Sides and Parting Ways'),
  ((SELECT campaign_id FROM c_id), 2, 12, 'Chapter 12 - A Riot of Surfs and Slaves'),
  ((SELECT campaign_id FROM c_id), 2, 13, 'Chapter 13 - A Storm-Wrought Spirit Journey'),
  ((SELECT campaign_id FROM c_id), 2, 14, 'Chapter 14 - Starting the Race in Last Place'),
  ((SELECT campaign_id FROM c_id), 2, 15, 'Chapter 15 - Fzumi Salt Mines'),
  ((SELECT campaign_id FROM c_id), 2, 16, 'Chapter 16 - A Ranch''s Night-mare'),
  ((SELECT campaign_id FROM c_id), 2, 17, 'Chapter 17 - Trouble on the Road'),
  ((SELECT campaign_id FROM c_id), 2, 18, 'Chapter 18 - On Sharrowsmith''s Trail'),
  ((SELECT campaign_id FROM c_id), 2, 19, 'Chapter 19 - A Song that Grippli''s the Heart'),
  ((SELECT campaign_id FROM c_id), 2, 20, 'Chapter 20 - The Ruins of Ashkurnhall'),
  ((SELECT campaign_id FROM c_id), 2, 21, 'Chapter 21 - A Golden Guardian and a Bronze Moon'),
  ((SELECT campaign_id FROM c_id), 2, 22, 'Chapter 22 - A Jungle Cruise'),
  ((SELECT campaign_id FROM c_id), 2, 23, 'Chapter 23 - Welcome to the Jungle'),
  ((SELECT campaign_id FROM c_id), 2, 24, 'Chapter 24 - Being Head-hunted')
ON CONFLICT (campaign_id, log_type, session_number) DO NOTHING;

-- Gallery CTE
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
),
sl_id AS (
  SELECT session_number, id AS session_log_id
  FROM session_logs
  WHERE campaign_id = (SELECT campaign_id FROM c_id)
    AND log_type = 'session summary'
)
INSERT INTO session_log_gallery (session_log_id, image_url, alt, is_tall)
VALUES
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 1),
    '/images/hero/hero-souls-for-smugglers-shiv.webp',
    'Castaway on Smuggler''s Shiv',
    FALSE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 2),
    '/images/hero/hero-dimorphodon-nest.webp',
    'Raiding a Dimorphodon''s Nest',
    FALSE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 3),
    '/images/objects/loot-exsanguinated-goat.webp',
    'A Goat Dropped in the Fire',
    FALSE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 4),
    '/images/monster/monster-captain-kinkarion.webp',
    'Ghost of Captain Kinkarion',
    TRUE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 5),
    '/images/map/place-pezocks-crab.webp',
    'Pezock''s Castaway Crab Home',
    FALSE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 6),
    '/images/monster/monster-festrog.webp',
    'Undead Amphibian Lacedon',
    TRUE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 7),
    '/images/map/sketch-gray-island-fungus.webp',
    'Sketch of the Gray Island Fungus',
    FALSE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 8),
    '/images/monster/monster-red-mountain-devil.webp',
    'The Devil of Red Mountain',
    TRUE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 9),
    '/images/monster/monster-witch-malikadna.webp',
    'The Cannibal-Witch Malikadna',
    TRUE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 10),
    '/images/hero/hero-temple-zura.webp',
    'Pendulum and Pit Traps of the Temple of Zura',
    FALSE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 11),
    '/images/hero/hero-eleder.webp',
    'The City of Eleder',
    FALSE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 12),
    '/images/npc/npc-umagro.webp',
    'Freeman Brotherhood Radical - Umargo',
    TRUE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 13),
    '/images/monster/monster-kelpie.webp',
    'A Protective Kelpie',
    TRUE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 14),
    '/images/hero/hero-cheliax-v-pirates.webp',
    'Red Mantis and Rivermen Sabotaging Each-Others'' Ships',
    FALSE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 15),
    '/images/monster/monster-blue-warrior.webp',
    'The Blue Warrior',
    TRUE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 16),
    '/images/monster/monster-chemosit.webp',
    'Chemosit Night Terror',
    TRUE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 17),
    '/images/hero/hero-ankheg-attack.webp',
    '*',
    FALSE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 18),
    '/images/npc/npc-gcs-miner.webp',
    'A G.C.S. Miner',
    TRUE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 19),
    '/images/hero/hero-mwangi-t-rex.webp',
    'Fleeing an Angry T-Rex',
    FALSE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 20),
    '/images/monster/monster-kobold-cultists.webp',
    'Kobold Cultist',
    TRUE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 21),
    '/images/monster/monster-golden-guardian.webp',
    'A Golden Guardian',
    TRUE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 22),
    '/images/monster/monster-needle-tooth-piranhas.webp',
    'Needle-toothed Piranhas',
    TRUE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 23),
    '/images/hero/hero-mwangi-campaigns.webp',
    'Fleeing Hostile Natives on a River Boat',
    FALSE
  ),

  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 24),
    '/images/hero/hero-headhunter-ambush.webp',
    'Ambushed (not really) by Headhunters',
    FALSE
  );
-- End Gallery CTE Block

-- Paragraphs CTE Block
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
),
sl_id AS (
  SELECT session_number, id AS session_log_id
  FROM session_logs
  WHERE campaign_id = (SELECT campaign_id FROM c_id)
    AND log_type = 'session summary'
)
INSERT INTO session_log_paragraphs (session_log_id, paragraph_order, paragraph_text)
VALUES
  -- Session 1 (5 paragraphs)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 1),
    1,
    'After over 100 days at sea, the <i>Jenivere</i> had taken on more than a few passengers to Eleder, the capital city of Sargava within the fabled Mwangi Expanse. The <i>Jenivere</i> is a large Wyvern-class merchant ship, a blue-water vessel making the same voyage it has made dozens of times before. The trip was exotic, sailing around the endless hurricane of the Eye of Abendego and through the pirate-infested waters of the Shackles, but it only featured a middling amount of danger or prospects for profit. With nothing out of the ordinary, save for some of the passenger''s unique predilections, the <i>Jenivere</i> got within only a few days of Eleder.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 1),
    2,
    'The various passengers had already had plenty of time to get to know each other, with the newest one boarding over a month ago, and all persons sharing the same bunk-filled cabin. Some, such as the Elf maid Aerys, preferred to be left alone as much as possible; others, like the gnome ne''er-do-well Gelik, kept the silence at bay with a constant stream of conversation. An unusually high number of passengers spent their evenings on the main deck, weather permitting, watching the sky and dancing in the starlight. This was tolerated by Captain Kovack as worship to Desna - or Shimye-Magalla as some of them called it - which would hopefully curry her favor in safely reaching the destination, but he did not allow his crew to be distracted by their ceaseless antics.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 1),
    3,
    'Joining the Ship''s Cook for dinner, the passengers dined while the crew worked, eating the same watery fish soup Rambar Terillo prepared every night. "This has no spice!" Avarice grumbled in Polyglot for the third time today, knowing the cook could not understand. Many of them chattered in an overlapping mix of Common and Polyglot, grousing again over the food, but Rambar characteristically ignored them as they ate. Dakota continued to disagree with the general motion of the ship and the salt-less bouillabaisse, and went topside to wretch while Avarice muscled to keep the food down as the ship rocked violently as it cut across the currents.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 1),
    4,
    'As sensations began creeping back in, first the feeling of searing sunlight and warm sand against bare skin, followed by a lapping wetness and the sound of gently breaking waves, Ivy awoke first as a sharp pain cut into her foot. She had been pinched by a eurypterid - a sort of lobster with a scorpion tail! Looking about, she found herself on a beach along with several other passengers. The <i>Jenivere</i> lay smashed and wedged on the rocks offshore, with the rear half jutting out of the surf, while a half-dozen eurypterids trawled the beach, feasting on the detritus of dead crew members. Drag marks and footprints lead from the sea to each of the bodies slumped on the beach and to a pile of gear just ashore, with footprints returning to the water each time.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 1),
    5,
    'After squawking in panic, Ivy successfully alerted Avarice, who began fighting the eurypterids with his bare hands, while she about waking the others. Dakota found some sharp sticks to fight with, and Ishirou charged in with his family sword. They made short work of the overgrown lobsters with them all avoiding the eurypterids stings and the worst of their injuries being only a few scratches. Feeling sick to their stomachs, they were in various stages of shock and were utterly unable to remember anything that happened after dinner the night before. The prisoner Jask was among those on the shore, still bound in shackles, but Ivy couldn''t get much out of him other than the phrase "not again" in Polyglot. Ishirou suggested they try to reach the wreckage to salvage what they could before the tide came in, while Gellik instead urged the group to find shelter from the elements. Splitting up, a portion of the group went up the beach in search of a safe place to cross the rocks, when they found a sobbing Sasha. She embraced Dakota and sobbed while standing next to the body of a shark which was filled with jagged stab wounds from a pair of saw-toothed punching daggers, saying something about not wanting to kill anymore. Sending her back up the beach to the others, the rest of the survivors set themselves to trying to get back aboard the <i>Jenivere</i>.'
  ),

  -- Session 2 (5 paragraphs)
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 2),
    1,
    'The survivors had reached the wreckage of the <i>Jenivere</i>, precariously wedged on the rocks in the low tide. They noted how the water line was below their knees, but likely wouldn''t remain so low once the tide came in. They used a rope and a grappling hook to easily scale the large rock the ship was wrecked on and rappel safely down onto the top deck, where the full scale of the disaster became apparent - the entire lower deck of the ship and its hull were shorn off, as was the prow, leaving only the rear and upper half of the <i>Jenivere</i> intact. They also found the remains of the ship''s only longboat, tied up to the side of the ship and smashed to bits, evidence that someone used it to return to the wreckage before the tide went out.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 2),
    2,
    'Searching the wreckage, they started in the captain''s cabin. A large hole in the side of the ship allowed most of its contents to spill out to sea, but a large desk was wedged in the hole, keeping it and a footlocker from stumbling out. They recovered the footlocker, some supplies, sea charts, and the captain''s log, before smashing open a locked drawer and gathering up the captain''s emergency supplies - a bottle of fine brandy and a mess of potions. Some of the bottles were broken, including a miniature of the <i>Jenivere</i>, but with the water rising fast, they took what they could gather and searched below deck.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 2),
    3,
    'The middens was most familiar to the survivors, as it was where they slept and ate while aboard. The lower decks were for the crew and cargo and were completely lost. The survivors killed a eurypterid that was scratching at the supply room before opening it to discover enough supplies to build out a campsite, along with the body of the first mate, Alton Devers. He had a series of older stab wounds from a rapier along with some fresher inflamed stings and signs of succumbing to poison. They hauled his body to the top deck and tasked Ishirou with shuttling everything they found to shore before the tide came back in. A thorough search of the larder also revealed the body of the ship''s cook, Rambar Terillo, who had been stuffed into a hidden nook, along with a small bag of salt that seemed to have been laced with something. Examining the body, the ship''s cook appeared to have been killed by a snake bite from a rather large snake. Finally reaching the passenger quarters, they stripped the beds of their blankets before exploring the animal hold, where Astra''s tiger was chained up and was eating the carcass of Ivy''s horse. Ishirou expertly calmed the tiger and convinced it to follow them back to the others, where Astra, Ivy, and Gellik were setting up camp.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 2),
    4,
    'Back at camp, they released Jask from his bindings and returned to him his armor, holy symbol, and spell component pouch that had been in the footlocker. Gellik poured through the captain''s log and sea maps, and came to an alarming discovery - it appeared the captain had gone mad and became obsessed with one of the other passengers, the Varisian scholar Ieana, and intentionally wrecked the <i>Jenivere</i> on the infamous island of <i>Smuggler''s Shiv</i>. Disheartened, several members of the group fell into despair, and everyone tried their best to get a good night''s sleep. That night, Astra and Loric shared a nightmare where they were retching over the side of the ship along with all the passengers and crew. With soup spoons in their hands, the captain ordered them to bail the ship out with their spoons.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 2),
    5,
    'The next day, leaving a few of the survivors behind at the camp, a scouting party set out to explore the beach to the west, planning to walk the coastline before walking back to the camp. They found the wreck of another ship, the <i>Tattooed Lady</i>, which had enough supplies aboard to build another campsite - a grim sign regarding the fate of the crew - but nothing else of value. They attempted to mark its location before continuing their journey, where they spotted an odd grey island covered in fungal stalks across the cove. As they worked their way around the point, they were attacked by several groups of dimorphodon''s as they cleared out their nests, with each member of the group taking injuries and several struggling with the effects of the dimorphodon''s poison. Returning with eggs for food, they made their way back to camp, only for several monkeys to steal and smash some of their recovered food stores. Astra had spent the day working with Jask and communicating slowly. As he opened up, he disclosed that he was from Sargava, and he had reported some corruption he uncovered regarding some civil servants and the Free Pirates of the Shackles. To his horror, his supervisor accused him of the crimes he had exposed, and he fled to Cheliax where he''d been in hiding for a few years before he was caught by a Sargavan official and extradited for trial. He wondered aloud if the wreckage of a ship known as <i>The Brine Demon</i> could be found here on <i>Smuggler''s Shiv</i>, as it reportedly wrecked on this island. It would be a long shot, but the captain of that ship, Avret Kinkarian, was one of the Free Pirates his supervisor associated with, and if he kept any records aboard, it might be sufficient to prove his innocence.'
  ),

  -- Session 3 (3 paragraphs)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 3),
    1,
    'The survivors of the <i>Jenivere</i> spent the next several days slowly exploring and securing the area around their campsite. They explored wrecks that had smashed along the island''s outer coast, found and eliminated nests of hostile creatures, and spent time getting to know their companions. While their nights were sometimes fitful (indeed, Gelik experienced frequent night terrors), they began to adapt to their new environment, and they slowly fell into a routine regarding tasks to accomplish, both at camp and within the surrounding jungle. As their companions opened up one after another, they discovered new ways they could try to help each other: Aerys wanted help dealing with her withdrawals and alcoholism, Gelik wanted to find the wreckage of the <i>Nightvoice</i>, Jask wanted to try to clear his name, and Sasha wanted some baby poisonous creatures to raise.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 3),
    2,
    'After they had been on the island for a week, their routine was disturbed by the exsanguinated body of a goat falling from the sky into their campfire, dropped by a giant, winged chupacabra. Many of the survivors panicked and quickly put out the spreading fire, realizing the dangers deeper in the island and losing the feeling of safety their campsite had previously brought. From now on, attacks on the campsite would be more frequent, and deadly.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 3),
    3,
    'The morning after, they decided it was time to move the camp further south, and the survivors had found a cave on a hill with a stream where they could set up camp, after clearing out the snakes nesting there. They also spotted another old campsite from atop the hill, one over a week old with clear evidence that both Captain Kovack and Ieana had used it. Picking up their trail, they followed it a short distance, where they discovered a patch of berries that could help Aerys with her addiction. After Avarice harvested all he could, they brought the berries back to the grateful Aerys, who recited for her new friends her poem in progress, the <i>Abendego Cantos,</i> which took the rest of the evening to get through. And as they turned in for the night, the survivors prepared to begin their tenth day on the island.'
  ),

  -- Session 4 (4 paragraphs)
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 4),
    1,
    'Moving their campsite meant they could explore more of the island. They started by exploring the shipwrecked <i>Brine Deamon</i>; the ship was over 150 feet long, flew a tattered pirate''s flag, and had a figurehead matching its name. Climbing aboard, they forced their way into the captain''s cabin and found the captain''s skeleton, slumped in his chair at his desk, clutching something in its hand. Prying the sealed watertight coffer from his bony fingers, they brought the coffer back to the camp to see if someone had the finesse to open it. Inside, they discovered a magical dagger, several fat ledgers and journals, and a locket containing a tiny portrait of a red-haired half-elf with the inscription, <i>”Aeshamara”</i>. Jask poured over the journals and found within them evidence that would exonerate him of his accused crimes, and in thanks, he taught the rest of the group his meditation techniques for focusing his mind.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 4), 
    2,
    'That night, they encountered the haunted ghost of the captain of the <i>Brine Deamon</i>, having tracked them from the sea up the river to the cave mouth of their campsite. Bemoaning for <i>”Aeshamara”</i>, Loric grabbed the inscribed locket and tossed it at the ghost''s feet, where it struggled repeatedly to lift the locket before becoming angry. Approaching cautiously, Dakota opened the locket and strongly presented it to the ghost, who smiled as he looked upon the face of his beloved one last time before vanishing.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 4),
    3,
    'That night, a loud rumbling came from the red mountain on the southeastern shore of <i>Smuggler''s Shiv</i>. Lightning flashed across the sky - only striking the red mountain; storm clouds began to gather, and the wind changed direction suddenly and violently. A massive storm was coming, a storm they had to prepare for, a powerful and violent typhoon.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 4), 
    4,
    'The following morning, with the storm fast approaching, the survivors of the wreck of the <i>Jenivere</i> explored the area immediately surrounding their still-new shelter and set about hunting several large crabs and gathering their meat - a decision that would soon prove prescient. They also followed a game trail where Avarice got momentarily caught in a hunter''s snare - a sign of the dangerous local inhabitants. Finally, they reached an overlook atop a large hill with a strange lack of vegetation, spotting several more shipwrecks along the nearby coastline, from one of which they recovered a magnificent bow, as well as an ominous site - a cabin built on a hill nearby. Not having time to explore the cabin yet, they returned to take shelter from the storm in their cave. The ensuing typhoon that hit <i>Smuggler''s Shiv</i> lasted a full three dangerous days.'
  ),

  -- Session 5 (5 paragraphs)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 5), 
    1, 
    'The survivors began their day with a visit to the shore, having spotted several bodies floating in the water - the drowned sailors of ships caught in the typhoon. Finding no survivors, they searched the dead, recovering some heavy armor and a trident, both of whom seemed hauntingly inscribed with the words “Down and Drowned and Never Found.” They also had their first encounter with the island''s dangerous shocker lizards, an encounter that nearly took the lives of several of them.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 5), 
    2, 
    'Debating the dangers ahead, they pressed on toward the mysterious cabin on the hill and explored it carefully. The cabin had signs of being frequently visited, and the exterior was decorated with human skulls, but the inside had obviously not been touched in a long time. Searching the home, they found a hidden nook with an old, barely legible journal - the journal of the captain of the <i>“Thrune Fang,”</i> a Chelish warship that ran aground on the Shiv many decades ago. The journal wrote about the crew following the strange and esoteric beliefs of an old woman aboard the ship, turning wild and frenzied, and eventually falling to cannibalism. Deciding the cabin was a better shelter than their old cave, the survivors moved their camp to the cabin, hoping the cannibals would avoid entering the site. They settled in for the night, only to be attacked by dangerous Ningo''s hunting the people wearing the armor and wielding the trident recovered from the sea. Though they survived the fight, the smell of human flesh boiling in the cannibal''s cookpots nearby was sickening.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 5), 
    3,
    'The following day, as they were discussing their plans to explore, they heard loud and manic screams carried on the wind, screams that sounded suspiciously avian. Rushing to help, they went north, only to fall into another cannibal''s trap as they were running along another game trail - a warning. They continued along the trail more cautiously before discovering the source of the now-ended commotion - two giant crabs had fought, with one lying dead at the claws of the larger, gargantuan crab. Hungrily eyeing the carcass, as well as the meat from the massive crab, the party stayed at a safe distance as the massive beast waved a huge claw and moaned threateningly at them, taking the occasional swipe but easily missing. Realizing it was immobile and taking a closer look, they noticed the massive crab was long dead and hollowed out, now used as a home for a marooned Tengu named Pezock, who had long since lost his mind. Leaving him alone for now, they explored the nearby abandoned campsite of the survivors of the wreckage of the Crow''s Tooth, who had long ago been attacked and carried off by the cannibal inhabitants of the Shiv.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 5), 
    4, 
    'The survivors continued along the bay''s interior before turning south along the western coastline and then following a river inwards towards the interior of the island. Along the way, they fought and harvested a few more crabs nests and an oyster bed, as well as exploring a handful of shipwrecks, discovering the tidal-locked passage to the silent gray island, and fighting off the giant winged chupacabra, forcing it to retreat towards the red mountain. As they finished their loop, they noticed a nearby hill topped by a massive banyan tree, and a hidden bluff overlooking a game trail in a small canyon. Dropping down on the bluff from above, they easily killed the two cannibal hunters stationed there.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 5), 
    5, 
    'Having now met the inhabitants directly, a future confrontation was looking increasingly inevitable.'
  ),

  -- Session 6 (4 paragraphs)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 6), 
    1,
    'Resting up after their various excursions, Ishirou revealed that he had the odd habit of collecting treasure maps - regardless of their apparent authenticity - one of which supposedly pointed to a treasure here on <i>Smuggler''s Shiv.</i> The map pointed to the strangely barren hill they visited before, so the group set out with tools for digging. After excavating a 10-foot hole in the barren earth, they uncovered the body of a man who had been stabbed in the back, lying atop a strange wooden platform. Deciding not to dig straight through it, they excavated the edges until they had uncovered the entire 10-foot diameter platform, as well as a place to stand alongside it. Breaking through the wood, they uncovered a buried cenote, with a small piece of land surrounded by water at the bottom.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 6), 
    2,
    'They descended into the cenote (with varying amounts of caution) and fought some lacedons that had been sealed inside the chamber. Though they were initially separated, Ivy''s song of the otter helped save the day as they swam circles around the amphibious undead. After finishing them off, Ivy dove beneath the water and found a hidden passage beneath the small parcel of land, which held a large watertight chest just above the waterline. They took it back to camp and broke the lock off to reveal an amazing haul of treasure - magical potions, arms and armor, various scrolls including one to revive the dead, and a pirate''s hoard of clothes, coins, gems, and jewels. Deciding to give Ishirou the gems as his cut, he showed his gratitude by sharing some of the fighting techniques he learned during his lifetime as a mercenary.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 6), 
    3,
    'The survivors then explored the western interior of the island, looking for high points where they could get a better view of their surroundings. They built a temporary shelter atop the tidal-locked mesa in view of the gray island - a preparation for their future expedition - finally exterminated the shocker lizards (except for a baby they chose to keep and named ''lil Zappy), and finally made their way to the loaming hill with the banyan tree. On their approach, they were met by a tropical dryad, the Spirit of the Hill, who offered them food and beseeched them to rid <i>Smuggler''s Shiv</i> of the creeping blight spreading out from the silent gray island, promising them rewards if they could manage.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 6), 
    4,
    'From atop the banyan hill, they could see the lighthouse they sought, surrounded by the cannibal campsite, and decided they needed the banyan dryad''s help, preparing themselves for the undoubtedly difficult journey to the grey island they first spotted so long ago.'
  ),

  -- Session 7 (7 paragraphs)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 7),
    1,
    'Setting out straight away for the gray island, they moved everyone to the temporary shelter they built atop the tidal locked mesa and peered out at the fungus-covered island. Fearing infection and disease, they took the precaution of each eating a handful of viper nettle berries, a decision that undoubtedly saved their lives.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 7), 
    2, 
    'Avarice was the first to become infected, becoming a carrier of the gray fungus and they quickly began to grow out of his ears and along his throat. As they ventured into the island, they encountered silent and deadly vegepygmies with sharp spears that tried to infect the party with the island''s dangerous spores. They swayed strangely in time with the fungal forest, a sway that avarice copied, and more of the group became host carriers of the fungus.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 7), 
    3, 
    'They eventually made it to the massive shipwreck they had spotted from the mesa, the grim and doomed <i>Nightvoice</i>, a pathfinder ship that had intentionally run aground on <i>Smuggler''s Shiv</i> to keep the strange fungus from spreading to a populated area. The crew had all died after becoming hosts to the gray fungus, with their corpses sprouting the dangerous vegepygmies that silently roamed the island. They fought off the remaining vegepygmies, including a beefier one wearing cooking pots as armor, though after the fight, everyone had now become hosts to this same fungus. Though there was no sign of the captain or his body aboard the ship, they retrieved the captain''s log from his cabin. Its final entry detailed a trip to the eastern end of the island, where he sought to hide away the heart of the strange, spreading fungus, before it could bloom more spores.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 7), 
    4, 
    'Feeling a desperate urgency, the group raced to the small towering and isolated cave cliff, within which held a powerful and dangerous violet fungus - the trapped heart of the gray island''s infestation. As it pulsed with violet light, the entire mushroom forest and the infected hosts of the group swayed and moved in response. Taking a defensive stance, Avarice drew its attention and bore the brunt of its violence while the group struggled against it, before Loric landed the killing blow. With its death, the fungal forest became suddenly still, and within the following hour, all the fungus across the island - including the spores infecting the group, withered, and died.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 7), 
    5, 
    'The party returned to the mesa camp to recover, taking three full days to rest before everyone was healthy again. During that time, they shared the Pathfinder''s journal with Gellik, who returned the favor by sharing some of his secrets to proper comedic timing with the group. Ivy spent her free time visiting poor Pezock and becoming his friend, learning more of his story and time as a passenger aboard a red mantis assassin''s ship.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 7), 
    6, 
    'Once everyone had recovered, they returned to the Spirit of the Hill, who had spent her time speaking with the island and growing a shelter for all the survivors of the wreckage of the <i>Jenivere</i>. She promised to help the survivors in any way she could, as her thanks, and offered them a safe shelter, all the food they would need, and access to her magic in whichever way they saw fit.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 7), 
    7, 
    'With a safe home, their life on the Shiv would be much easier from now on, but they still needed to send out a distress signal from the lighthouse to the south if they were going to be rescued, a signal that would require tackling the cannibal''s camp. With the red mountain looming over them, it was time to make a plan.'
  ),

  -- Session 8 (7 paragraphs)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 8), 
    1, 
    'With the blessings of the spirit of the hill, the survivors of the <i>Jenivere</i> attempted to ambush a cannibal checkpoint. While a few of them were able to maintain a stealthy approach, a few of them was spotted before the attack could begin, and a number of cannibals emerged from their defenses to attack while others threw javelins from atop their crude towers. While they engaged the violent cannibals, a ritualistically scarred woman wearing only a bra made from human skulls began cursing them with juju magics, making the survivors'' attacks miss while she cackled at their failures. Though one of the cannibals may have also been affected by her juju, as when he went to throw his javelin at the survivors, he tripped and fell horrifically to the ground and impaled his head on his own javelin, leaving behind another decorative skull on a pike.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 8), 
    2, 
    'While most of the survivors quickly broke from stealth and engaged fiercely, Loric was able to sneak around the cannibal''s defenses and flank the scarred witch, injuring her fiercely before suffering from a powerful hex, an opening Avarice was able to exploit to finally kill her. As the other cannibals were cut down while trading blows, the last tower defender, seeing the inevitability of his fate, lit his own tower on fire, eventually immolating himself. The smoke from the tower was quickly visible from afar, and the sound of war drums in the distance forced the survivors to retreat before they could be caught, deciding to head towards the red mountain rather than attack the now alert cannibal camp.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 8), 
    3,
    'As they traveled towards the red mountain, they took a detour to hunt for a shiv dragon, having spotted signs of a large nest in the area. But apex predators are not accustomed to being hunted, and they were ambushed by the shiv dragons while searching their territory, first by a male, then by a female. The survivors quickly cut them down, but not before they each charged Loric and gave him some nasty bites, bites that quickly drained him of his vitality. With Loric badly injured and the survivors low on magic, they took the baby shiv dragon from its nest and returned to camp, avoiding further cannibal checkpoints. Sasha was so grateful for the baby shiv dragon, that she taught the rest of the survivors some of her techniques for getting the jump on prey, techniques that would be helpful in the future.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 8), 
    4,
    'Continuing to avoid the cannibals for now, the survivors explored more of the area. They hiked the red mountain and from that high vantage point, they were able to spot more shipwrecks, as well as an interesting set of standing stones. They also noticed that despite the standing stones being over a low point into which the rivers ran, the water drained uphill into the ocean - a puzzling sight. They explored a number of shipwrecks, including a strange otherworldly wreck that vanished when they slayed the spirit aboard, and a ship named “The Bearded Harpy” being used as a nest by a harpy sorceress. After initial hostilities, she traded a set of magical armor for a dance and a roll with Avarice, following a parley. She tried to convince him to stay with her forever, but he eventually resisted her charms and returned to the group.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 8), 
    5,
    'Venturing to the standing stones, they discovered a small stone pyramid at the center of the stones, and each stone had a strange rune carved into its face facing the pyramid (one of which was covered in dried blood). With a combination of skill and some incredible luck, Ivy was able to blindly activate a strange device, though she did not know what steps she took to do so. This caused the water level in the area to drop a further 30 feet and opened a set of large stone doors that had previously been underwater and hidden by thick seaweed. As they tried to make their way down, they again encountered the red mountain devil, the giant winged chupacabra, who charged them to protect his nest, but Dakota caught it in the neck with her grappling hook and ripped it out of the sky, killing it quickly. They also killed the baby chupacabra after it knocked Avarice dangerously off a rope bridge into the water below. Exploring its nest, they filled their pockets with coins and magic items from the chupacabra''s treasure hoard.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 8), 
    6,
    'Working their way down to the formerly underwater seabed, Loric was able to charm his way past an agitated bull shark that was temporarily trapped in a shallow pool. They then explored a shipwreck that had been underwater, making friends with a water mephit and finding some magical rope for Dakota, though a fight with a spiny sea urchin left both Avarice and Loric weakened from its poison. They pushed on to enter through the strange doors but were unable to decipher the markings on the walls. Its origins and meaning were unclear, though the drawings seemed to depict vampires preying upon ancient humans. Entering the mysterious structure, they were ambushed by skeletal archers with strange snake skulls, before falling into a sacrificial pit occupied by strange, malevolent dolls made from the bones of the sacrificed.'
  ),
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 8), 
    7, 
    'Though they hadn''t made much progress into the structure yet, the survivors were badly injured and low on both magic and strength, so they retreated back to camp for now, unsure if they would ever have the luck they would need to trigger the device again and open the strange doors to the hidden structure. They did, however, find evidence that this place had been visited recently, if not often, and the only other people on the island were the cannibals. Perhaps, it was reasoned, the conflict with the cannibals was no longer something they could postpone.'
  ),

  -- Session 9 (1 paragraph)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 9),
    1,
    'Placeholder: Infiltrated cannibal camp, killed all the cannibals;'
  ),

  -- Session 10 (1 paragraph)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 10),
    1,
    'Placeholder: Ventured into the underworld (caves of the mother), fought festrogs and lacedons, the mother, Garzoth the Magnificent, fell into traps, made rubbings, fought Yarzoth at the temple of blood, released evil spirits from the shiv, lit the lighthouse and got rescued.'
  ),

  -- Session 11 (1 paragraph)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 11), 
    1,
    'Placeholder: Got rescued, went shopping, met the factions, picked a side, astra retired, Alhemja and Ezekiel were hired on.'
  ),

  -- Session 12 (1 paragraph)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 12), 
    1,
    'Placeholder: Encountered the freemen, Alhemja accidentally helped them set fire to the GCS warehouses, the freemen captured pezock, the heroes rescue pezock and kill umargo, their expedition is set back 10 days, their worker''s spiritual leader dies, sent on a quest to try to recruit Nketchi.'
  ),

  -- Session 13 (1 paragraph)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 13), 
    1,
    'Placeholder: Encountered the Hellknights of the Coil (talked past them), besought Nketchi, went on Nketchi''s quests: the trial of the wind and the trial of the water (aided by birds and Bas''o), went on a dream journey with Nketchi (encountered giant snake).'
  ),

  -- Session 14 (1 paragraph)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 14), 
    1,
    'Placeholder: Began traveling, learned how to journey, fought (and died to) hyenadons - Alhemja and Ezekiel were lost, also bypassed some dinosaurs and encountered a wildling.'
  ),

  -- Session 15 (1 paragraph)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 15), 
    1,
    'Placeholder: Met and recruited Athyra (the wildling) and her companion, entered the condemned fzumi salt mines, discovered the tragedy that occurred there, destroyed the blue warrior spirit and laid the miners to rest, discovered the identity of athyra and explained her past to her, used the mines as a shortcut.'
  ),

  -- Session 16 (1 paragraph)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 16), 
    1,
    'Placeholder: Roadside cockfight terror, reached the freehold ranch, recruited their leader (Lady Mindra Macini), decided to help the village with their chemosit problem, fought off the dream bears in dreamland with the Dakota bear, set off towards kalabuto, encountered the first delta lion (which was disrespected), got thrashed by a subsequent delta lion (which was respected) and its lionesses.'
  ),

  -- Session 17 (1 paragraph)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 17), 
    1,
    'Placeholder: Found the Pathfinders and the Ivory Cross stuck and battling each other because of a roadside ambush (ankeg), poached some rhinos (took a horn) in a sleet storm, found a haunted tree (M''zali), reached Kalabuto, met up with "Skipper Cheiton."'
  ),

  -- Session 18 (1 paragraph)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 18), 
    1,
    'Placeholder: Sailed up past trading post to Bandu Fort, met fort commander, paid off soldiers to inform on the Ivory Cross that were present, followed the Ivory Cross via giant eagles, killed the mercenaries and saved GSC miners, ventured further into the valley.'
  ),

  -- Session 19 (1 paragraph)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 19), 
    1,
    'Placeholder: Met up with a village of gripplis, explained they were following Sharrowsmith, received quest to recover an egg from a scaled one (carnivore) for them to raise as their own, ventured into jungle, fought off minor drake and swarms of ants, killed lizardfolk hunters, stole T-Rex Eggs, escaped from T-rex in chase wih one egg left, return to find Ivory Cross trying to burn grippli village, killed the Ivory Cross'' abusive ranger leader, received their reward - a song: "Lead Kindly Light."'
  ),

  -- Session 20 (1 paragraph)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 20), 
    1,
    'Placeholder: Climbed mountain, crossed bridge with traps, reached summit, fought and killed kobolds there, rescued an Ivory Cross mercenary, found Sharrowsmith (cursed), bypassed trap, avarice and ivy scout ahead in the dark (invisibly) and fail an acrobatics check, falling off the side of the mountain.'
  ),

  -- Session 21 (1 paragraph)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 21), 
    1,
    'Placeholder: Ivy saves themselves with feather fall and returns to the group, they clear out the remainder of the ruins (kill a basilisk), reach the kobolds, begin fighting a golden gargoyle, sing the song, pass the trial of the moon to recover the Shield of Acavna relic, talk down the kobold leader, kite the Ivory Cross mercenaries in to be killed by the golden guardian (including their leader), return to Kalabuto with the shield.'
  ),

  -- Session 22 (1 paragraph)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 22), 
    1,
    'Placeholder: Starting rowing with the skipper and chatting up npcs, fought some bull hippos, a dark-souls octopus, and dived for treasure guarded by a baby nessie.'
  ),

  -- Session 23 (1 paragraph)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 23),
    1,
    'Placeholder: Continued upriver fighting crocodiles, leaches, and M''zali while getting npcs to friendly. Reached the rapids head base camp and ditched the boats, learned the meaning of the strange convergent cocoon cloak, and fought and killed some jungle pigs. Fled from a t-rex in the night.'
  ),

  -- Session 24 (1 paragraph)
  ((SELECT session_log_id FROM sl_id 
      WHERE session_number = 24),
    1,
    'Placeholder: Found some headhunters (whose ambush failed), rescued some shrunken (cursed) heads, started traveling with the pathfinder again (they caught up), encountered a magical mwangi tree-ent, found bodies floating in the river belonging to the Sargavan Custodial Government.'
  );
-- END Paragraphs CTE Block

-- END SESSION LOGS BLOCK

-- BEGIN SEED LOOT BLOCK (converted from loot.js)
-- Start Loot Seed CTE (idempotent)
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
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
  ability
)
VALUES
  -- 1. Convergent Cocoon Cloak (3 paragraphs)
  (
    (SELECT campaign_id FROM c_id),
    2,
    'minor',
    'item',
    NULL,
    TRUE,
    'Convergent Cocoon Cloak',
    'This ruffled silk cloak is incredibly durable despite its soft, delicate construction; the outer lining is lightweight and decorated with depictions of a great moth.',
    'This <i>Cocoon Cloak</i> appears to be connected to some being of the great beyond through some sort of magical convergence. As normal, anytime the wearer falls asleep (whether normally or they are forced unconscious), the cloak immediately transforms into sticky strands that envelop the wearer''s body, hardening into a solid silk cocoon. While wrapped in the cocoon the wearer is not helpless, they gain a +4 enhancement bonus to their natural armor and CMD against attempts to move them, and they are protected from critical hits and sneak attacks as if subject to the light fortification armor ability. 
<br><br>Only those who sleep wrapped in its silky strands can truly know what is experienced there, or what might emerge from the cocoon come dawn; the cocoon opens and transforms back into a cloak once the wearer wakes.'
  ),

  -- 4. Captain's Log (note1 → note, ship log, sort 1)
  ((SELECT campaign_id FROM c_id),
    2,
    'note',
    'ship log',
    1,
    TRUE,
    'Captains Log of Alizandru Kovack of the <i>Jenivere</i>',
    'This logbook was kept inside a locked and weathertight compartment in the captain''s cabin of the <i>Jenivere</i>. Bits of torn paper make it plain that the last few pages have been ripped out.',
    'An examination of this log reveals that the <i>Jenivere''s</i> captain seemed to be suffering from some sort of madness that grew over the course of the ship''s final voyage. Earlier entries from previous voyages are precise in recording progress and events along the way, as are entries from the first two-thirds of this last trip. Yet as one reads further, the more recent the entries get, the less common they become—in some cases, several days are missing entries. What entries do appear are strangely short, focusing more and more on one of the passengers - the Varisian scholar Ieana, with whom the captain seems to have become obsessed. Several entries are nothing more than poorly written love poems to Ieana, while others bemoan Captain Kovack''s inability to please her or catch her attention. Near the end, the entries begin to take on a more ominous tone with the captain starting to complain that other members of the crew are eyeing “his Ieana.” In particular, he suspects his first mate is in love with her, and writes several times about how he wishes Alton would just “have an accident.” The final entry is perhaps the most disturbing, for in it the captain writes of how he''s changed course for Smuggler''s Shiv at Ieana''s request. He hopes that the two of them can make a home on the remote island, but also notes that the crew are growing increasingly agitated at the ship''s new course. The captain muses that “something may need to be done about the crew” if their suspicions get any worse. The last few pages have been torn from the log.'
  ),

  -- 6. Magnificent Golden Bow (1 paragraph → ability only)
  ((SELECT campaign_id FROM c_id),
    2,
    'minor',
    'weapon',
    NULL,
    TRUE,
    'Magnificent Golden Bow',
    'This bow is magnificent to behold, made from solid gold yet magically as flexible as yew, and it - as well as its shots - look both powerful and impressive, even if they don''t seem to be exceptionally effective.',
    'This <i>+1 composite longbow</i> has a +2 strength rating. Despite its appearances, it its not made from any special materials.'
  ),

  -- 7. Kensuke (weapon)
  ((SELECT campaign_id FROM c_id),
    2,
    'minor',
    'weapon',
    NULL,
    TRUE,
    'Kensuke',
    'The dark blade of this machete reflects no light, and the pommel has a unique tentacle-stylized guard. When grasped, these tentacles seem to grasp back, and seem as though they would creep up the arm if only they were left unwatched.',
    'This <i>+1 adamantine machete</i> has the tentacled touch quirk, enabling it to deliver touch spells cast through it from an extra 5ft. away.'
  ),

  -- 8. Sodden Cloak of Resistance
  ((SELECT campaign_id FROM c_id),
    2,
    'minor',
    'item',
    NULL,
    TRUE,
    'Sodden Cloak of Resistance',
    'Whatever identifying colors or embroidery this cloak may have had have all been washed out, leaving behind a dull gray mass of thin cloth. With a texture somewhere between a wet blanket and soggy socks, the cloak is so thoroughly waterlogged, it drips even after being wrung out repeatedly. ',
    'This <i>Cloak of Resistance +1</i> is permanently waterlogged, and wearing it causes the wearer to be damp, regardless of outside conditions. Similarly, any furniture or bag this is placed in, on, or against, becomes damp in a very short time.'
  ),

  -- 9. Thirsty Headband of Alluring Charisma
  ((SELECT campaign_id FROM c_id),
    2,
    'minor',
    'item',
    NULL,
    TRUE,
    'Thirsty Headband of Alluring Charisma',
    'This stylish blue headband is soft and velvety to the touch. On close inspection, small swirls of deep reds and purples can be faintly seen, mixing with the deep blue hues.',
    'This <i>+2 headband of alluring charisma</i> causes the bearer to be physically and socially thirsty. They require 3x the amount of water as a normal person, and are constantly on the lookout for gratification.'
  ),

  -- 10. Yemba Iron Bell
  ((SELECT campaign_id FROM c_id),
    2,
    'minor',
    'item',
    NULL,
    TRUE,
    'Yemba Iron Bell',
    'This small iron bell is rusted beyond salvaging, and would likely crumble if struck or rung. Despite this, it seems to contain great magic.',
    'Once per day, when the bell is rung as a standard action, the bell produces a loud and clear chime compelling all creatures within 60 feet that hear the bell to make a DC 14 Will save or seek out the source of the sound for 7 rounds, or until they find the source, moving at their normal speeds. If the sound leads its subjects into a dangerous area, each affected creature gets a second save. This is a mind affecting compulsion effect. The bell affects a maximum of 24 HD of creatures.
<br><br> Any subsequent attempts that day to ring the bell produces no more sound than a faint clank, barely-audible from within 5ft.'
  ),

  -- 11. Zenj Spirit Fetish (1 paragraph)
  ((SELECT campaign_id FROM c_id),
    2,
    'minor',
    'item',
    NULL,
    TRUE,
    'Zenj Spirit Fetish',
    'This shrunken monkey head is filled with juju magics.',
    'The bearer of this shrunken monkey head can use it to cast dispel evil. While the spell is in effect, the bearer can make a melee touch attack with the head to banish an evil creature from another plane back to its home plane, or dispel one evil spell or one enchantment spell cast by an evil creature. This use discharges and ends the spell. When the spell ends, the fetish becomes a normal, non-magical shrunken monkey head.'
  ),

  -- 12. War Mask of Terror (2 paragraphs)
  ((SELECT campaign_id FROM c_id),
    2,
    'minor',
    'item',
    NULL,
    TRUE,
    'War Mask of Terror',
    'This appears to be the kind of wooden war mask used by shamans and warriors of many of the indigenous tribes of western Garund to add to their fierceness and mystique. Bearing terrifying visages of demonic spirits, a war mask is considered sacred and personal, and is often handed down to the next generation when a wearer dies. Individual masks are often notorious, and many tribesfolk can readily identify masks of other tribes with a DC 15 Knowledge (local) check.',
    'A war mask of terror provides its wearer with a +2 competence bonus on Intimidate checks and a +1 deflection bonus to Armor Class. In addition, the wearer may cast scare once per day.'
  ),

  -- 13. Fragments of Captain Beliker's Log (note1)
  ((SELECT campaign_id FROM c_id),
    2,
    'note',
    'ship log',
    3,
    TRUE,
    'Fragments of Captain Beliker''s Log of the <i>Thrunefang</i>',
    'This journal was carefully wrapped and hidden inside the abandoned cabin on smuggler''s shiv. Though clearly well used in its time, neglect and decay have rendered most of the Journal illegible.',
    '...many survived, the Thrune''s Fang will never sail again. Sargava''s assimilation must proceed without...
<br>...fine hunting on the Shiv, but the bugs are a constant distraction. Nylithati''s skills at healing help fight the sickness, but I fear she has...
<br>...founded. Nylithati has seized control of my crew. They are hers now. And so I have abandoned...
<br>...fine home. Fresh water nearby and I need not endure Nylithati''s ceaseless raving about...
<br>...will not be returning to that gray, silent island again. There is nothing there but horror...
<br>...crew lurking about the area. They seem strange, almost feral. It has been almost a decade since the wreck. I wonder what strange beliefs Nylithati has...
<br>...changed. There was no sign of Nylithati in the camp, but the focus of their ceremony was a cauldron they must have salvaged from the Thrune''s Fang at the base of the ruined lighthouse. It was into this they threw the half-eaten body of the still screaming man...
<br>...all around. I can hear them chanting in the green even now. They call Nylithati “Mother Thrunefang” now, and promise me immortality if I lay down my arms and submit. I know what their immortality consists of, and I''ll have no part of that corrupt life after...'
  ),

  -- 14. Last Words of Captain Alizandru Kovack
  ((SELECT campaign_id FROM c_id),
    2,
    'note',
    'ship log',
    2,
    TRUE,
    'Last Words of Captain Alizandru Kovack',
    'Written on a few scrap pages torn from a logbook, the words of this note appear to be written shakily in blood.',
    'I am Captain Alizandru Kovack, betrayer of my crew and destroyer of the good ship Jenivere. Hell would be a welcome escape from what hideous un-life looms before me, but it is no less a punishment than I deserve. That I was enslaved mind and body to a serpentine demon who wore a Varisian''s skin does not pardon me. It is my weakness that led the <i>Jenivere</i>, her crew, and her passengers to their doom. That Ieana has abandoned me here is nothing more than the fate I deserve. I do not beg forgiveness, but I despair that she lives still, and that she seeks something dire on this forsaken isle — she seemed particularly interested in <i>Red Mountain</i>. If you read this and you be a kind soul, seek out what I have become and destroy me, and then seek out Ieana and slay her as well. And to those whose lives I have helped destroy, I can only apologize from this, my dark cradle and darker grave.'
  ),

  -- 15. Red Mountain Ritual Notes
  ((SELECT campaign_id FROM c_id),
    2,
    'note',
    'rubbing',
    1,
    TRUE,
    'Red Mountain Ritual Notes',
    'A low stone altar, its sides carved like coiling snakes and its top carved to resemble a yawning viper''s maw, sits in the center of this room. The walls of the chamber are carved with images of anthropomorphic serpents using strange, pointed megaliths of stone to work great feats of magic—transforming an army of humans into zombies, calling down flaming bolts of lightning from the stars, or parting the waters of the sea to dash human ships upon the exposed rocks of the seabed below. This final image seems to have been recently cleaned of dust, and several lines of text have been made more legible via the application of inks and perhaps blood.',
    'The translation of the legible lines of text are reproduced as follows:
<br>&ensp;<b>To Command the Very Tides to Rise Up and Eschew What Lies Below:</b>
<br>&ensp;Empower the Four Sentinel Runes with the Blood of a Thinking Creature Tempered by the Kiss of a Serpent''s Tongue.
<br>&ensp;Anoint the Tide Stone with Waters Brought from the Sea in a Vessel of Purest Metal.
<br>&ensp;Invoke the Lord''s Sacred Name to Wrap His Coils around the Sea Itself that He Might Lay Bare What Lies Below and Cast Down Your Enemies on the Waves above.'
  ),

  -- 16. Venture-Captain Havner Ames' Log of the Nightvoice
  ((SELECT campaign_id FROM c_id),
    2,
    'note',
    'ship log',
    4,
    TRUE,
    'Venture-Captain Havner Ames'' Log of the <i>Nightvoice</i>',
    'Ravaged by mold and the strange fungus, only pieces of this log survive, but the entries were detailed enough to piece together the ship''s tragic history.',
    'The <i>Nightvoice</i> was a Pathfinder Society exploration vessel that  was on its way back from an expedition around the horn of Garund, when a strange leathery pod they discovered in a seaside cavern burst open. Only Captain Havner Ames managed to resist the resultant infection, and as he watched his crew succumb, he knew he couldn''t allow the strange bulb to reach the coast. It was all the captain could do to alter the ships course so that it would wreck on <ik>Smuggler''s Shiv</i> instead of along the populous sargavan coastline. Delirious with fever, the captain''s final log states he decided to ''carry the blasphemous pod up to the top of a rock spire on the east of the island,'' with an attempt to find a cave where he could hide it away from humanity forever.'
  ),

  -- 17. Rubbing of the Azlanti Runes in the Temple of Zura
  ((SELECT campaign_id FROM c_id),
    2,
    'note',
    'rubbing',
    1,
    TRUE,
    'Rubbing of the Azlanti Runes in the Temple of Zura',
    'These ancient runes are remarkably intact given its age, though cracks in the wall do make portions of the text illegible.',
    'Studying these runes is frustrating and difficult to translate because of the missing portions of wall that have cracked, coupled with the ancient inscriber''s fondness for awkward metaphor; however, four key bits of information can be gleaned from these carvings:
<br>&ensp;This chamber was once a scriptorium where books and scrolls sacred to the worship of Zura were transcribed and illuminated.
<br>&ensp;This temple was built over an even more ancient temple — one that was dedicated to a deity referred to only as the “Beheaded One,” an entity that was apparently an enemy to the ancient Zura cultists.
<br>&ensp;Several prayers seem to indicate that the ancients made use of undead slaves created from both “humans culled from the unbelievers and slaves of the Beheaded One.”
<br>&ensp;As much hatred as the Zura cultists had for the “slaves of the Beheaded One,” they also seemed to despise their own kind—especially those they called the “misbegotten of Saventh-Yhi.”'
  ),

  -- 18. Yarzoth's Notes on Saventh-Yhi
  ((SELECT campaign_id FROM c_id),
    2,
    'note',
    'rubbing',
    1,
    TRUE,
    'Yarzoth''s Notes on Saventh-Yhi',
    'These notes appear to be meticulously detailed, written carefully on pages clearly torn from another book. The script is a combination of curved alien glyphs with sharp, jagged strokes, with the lettering arranged in odd twisting, angular clusters rather than neat rows.',
    'These notes are written in Aklo but are otherwise quite complete, being a careful translation of the murals above the altar in the temple of Zura:
<br>&ensp;The three large alcoves in this room once served as meditation chambers—the cultists would enter one, pull a curtain for privacy, and recite the complex prayers and parables carved on the walls here. These carvings, all written in Azlanti, tell the history of this particular Zura cult in three stages.
<br>&ensp;The southern alcove tells of the cult''s genesis in the city of Saventh-Yhi in the jungle, but is frustratingly vague when it comes to exact details on the legendary city apart from confirming that it was built by Azlanti — this section ends with the cult''s exile from Saventh-Yhi and how they made a dangerous overland journey that ended on the shores of a remote island far from their homeland.
<br>&ensp;The northwestern alcove takes up the story at this point, detailing the cult''s exploration of this island (identifiable as Smuggler''s Shiv), their discovery and defeat of a large group of serpentfolk who had gone into hiding after the defeat of their kind many years before at Saventh-Yhi, and the creation of this temple.
<br>&ensp;The northeastern alcove plots the cult''s future plans, focusing on how they had hoped to earn the gift of vampirism from Zura by undertaking extensive and vile rituals, and once this gift was theirs, how they planned on making the journey back to Saventh-Yhi to ''awaken the city with Zura''s blessing.'' The route back to the ancient city is similarly cryptic, and the portions that do make sense reference antiquated geography; however, it seems they ultimately intended to use something called the ''Light of Tazion'' to return to the city through its protective wards.
<br>&ensp;In her notes, Yarzoth seems particularly intrigued by the possibility that Saventh-Yhi might be the exact spot where, so long ago, her god Ydersius was beheaded.'
  ),

-- 19. First Nightmare
  ((SELECT campaign_id FROM c_id),
    2,
    'dream',
    'shiv nightmare',
    1,
    TRUE,
    'First Nightmare',
    NULL,
    'You''re back aboard the <i>Jenivere</i>, bent over the railing being seasick. After your latest bout of retching, you slump back and see the rest of the passengers and crew are on deck as well, all of them sick save for the captain and the quiet Varisian scholar Ieana. She whispers in the captain''s ear, then gives him a kiss on the cheek. At that point the captain holds up a wooden soup spoon, and you realize that you''re holding one as well. Everyone has a spoon. The ship is sinking, and the only way to stop it is to bail out the hold with your spoon! You work feverishly, but the waters keep rushing in. Just before you wake, you can see monstrous things with pincers in the water trying to claw their way into the ship...'
  ),

  -- 20. Second Nightmare
  ((SELECT campaign_id FROM c_id),
    2,
    'dream',
    'shiv nightmare',
    2,
    TRUE,
    'Second Nightmare',
    NULL,
    'You''re sitting down in the galley aboard the <i>Jenivere</i>, getting ready for your meal. The ship''s cook has given you a steaming bowl of soup, but you drop your spoon. You see that the deck below is covered with seawater up to your ankles, and your dropped spoon has sunk into the water and washed out to sea through a hole. You''re forced to lift your delicious bowl of soup to your lips and drink. But something big goes into your mouth as you do so, and you feel a sharp bite on your tongue. You drop the bowl, only to reveal a serpent had hidden in your soup that now dangles from your tongue as it chews furiously. You start awake, biting your own tongue in an attempt to bite through the snake''s body.'
  ),

  -- 21. Third Nightmare
  ((SELECT campaign_id FROM c_id),
    2,
    'dream',
    'shiv nightmare',
    3,
    TRUE,
    'Third Nightmare',
    NULL,
    'You''re in a rowboat on the open ocean at night. Sitting across you, rowing the boat, is First Mate Alton. He''s obviously dead, with the wounds and stings his body displays on the wreck of the <i>Jenivere</i>, but still he rows. Eventually, the boat reaches an island covered with snakes. Alton waits as you exit the boat, standing ankle-deep in snakes, and then he turns and rows back out to sea, you assume off to look for more survivors to ferry to shore. But Alton never returns, and you wake up just as the snakes start to bite...'
  ),

  -- 22. Wings in the Dark
  ((SELECT campaign_id FROM c_id),
    2,
    'dream',
    'shiv nightmare',
    4,
    TRUE,
    'Wings in the Dark',
    NULL,
    'You''re laying on the floor looking up at the stars. In the sky above you, you note the constellations, counting each one that you know. All at once, a collection of stars form an obvious grouping; as you trace the stars with your eyes, lines form between the stars into the shape of a serpentine skull. Its mouth is open, as though speaking, but you cannot understand its whispers. You listen closer, trying to interpret the darkness it spews. Out of the corner of your eyes, you notice something large with blood-red eyes watching from the jungle''s edge, but you cannot move, cannot scream, all that comes out is a rasping hiss...'
  ),

  -- 23. Atlquipan (2 paragraphs)
  ((SELECT campaign_id FROM c_id),
    2,
    'minor',
    'weapon',
    NULL,
    TRUE,
    'Atlquipan',
    'This golden azlanti idol of a serpent appears lifelike, though inanimate. Around the length of the belly of the serpent is a series of tightly wrapped strips of leather, creating an oddly placed grip.',
    'This idol eagerly transforms into a <i>+1 monstrous humanoid bane returning trident</i> when grasped, its shaft decorated with a golden serpent twinning along its length. In addition to having the eager perk, it may be drawn as a non-action when initiative is rolled, as it springs into its owners hand, something it occasionally does on its own. Every time its owner draws a different weapon, there is a 5% chance they draw this one instead.'
'<br><br>As a standard action, the wielder can wrestle the serpent into twining around the shaft of another held trident or spear. This grants that other spear the <i>monstrous humanoid bane</i> ability; however, once that weapon is thrown, this weapon returns using its <i>returning</i> ability, leaving the weapon it was twined around behind.'
  ),

  -- 24. Wavecutter
  ((SELECT campaign_id FROM c_id),
    2,
    'minor',
    'weapon',
    NULL,
    TRUE,
    'Wavecutter',
    'This unusual terbuje is made of sharp chunks of quarts embedded along a length of steel',
    'This <i>+1 keen steel terbuje</i> may be used underwater without suffering any penalties, and its bearer may use attack rolls in place of swim checks to swim underwater.'
  ),

  -- 25. Savage Sting
  ((SELECT campaign_id FROM c_id),
    2,
    'minor',
    'weapon',
    NULL,
    TRUE,
    'Savage Sting',
    'This blowgun is made of a hollowed piece of reed lacquered in vibrant orange hues and decorated with a fetish of brilliantly colored feathers',
    'This is a <i>+1 seeking blowgun</i>. Up to three times per day, the wielder may envenom a dart fired from the blowgun with a virulent toxin, which functions as the poison spell.'
  ),

  -- 26. Orb of the Kindred Flame (1 paragraph)
  ((SELECT campaign_id FROM c_id),
    2,
    'minor',
    'item',
    NULL,
    TRUE,
    'Orb of the Kindred Flame',
    'This glowing red orb is roughly two inches in diameter with the a wooden texture, lik that of a large bead.',
    'This orb acts as a pearl of power level 3, except it is usable up to three times per day and it can only restore spells with the fire descriptor.'
  )
ON CONFLICT (campaign_id, item_name) DO NOTHING;

-- End Loot Seed

-- Start Loot Gallery Seed CTE (idempotent)
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
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
      WHERE item_name = 'Convergent Cocoon Cloak'),
    '/images/objects/loot-cocoon-cloak.webp',
    'Convergent Cocoon Cloak',
    TRUE
  ),
  ((SELECT item_id FROM i_id 
      WHERE item_name = 'Zenj Spirit Fetish'),
    '/images/objects/loot-zenj-spirit-fetish.webp',
    'Zenj Spirit Fetish',
    TRUE
  ),
  ((SELECT item_id FROM i_id 
      WHERE item_name = 'War Mask of Terror'),
    '/images/objects/loot-war-mask-terror.webp',
    'War Mask of Terror',
    TRUE
  )
ON CONFLICT DO NOTHING;
-- End Loot Gallery Seed
-- END SEED LOOT BLOCK

-- START resources.ejs SEED BLOCK
-- Seed Hardcoded Artifacts CTE (idempotent)
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
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
    'weapon',
    NULL,
    FALSE,
    'Spear of Seven Parts',
    'Fully assembled, this 14lb mithral spear bears the engraving "Orgē Aganakteō Ploúthos Agónizomai Perisseuó Horkos Euforía Anapauó Tímios Peri̱fánia," which roughly translates to "My Righteous Anger is Full, My (Zeal) is Overflowing, I Swear by (All I Love) [I Will] Lay You to Rest, and Let [Your Death] be My Glory." This spear appears to be the culmination of Savith''s work as he pursued the serpentfolk deity Ydersius. The spear glows corresponding to the spears of Saventh-Yhi.',
    'The <i>Spear of Seven Parts</i> has a total enhancement bonus of +7 and is always considered an epic weapon with the ability to transform into any weapon from the spear weapons group and critical threaten any creature (even if they are normally immune to critical hits). Additionally, when the corresponding spear is illuminated, the bearer may exchange an equivalent amount of enhancement bonus to activate or deactivate the following, according to the color:
<br>&ensp;Red = <i>flaming</i> or <i>flaming burst</i>
<br>&ensp;Orange = <i>keen</i> or <i>vorpal</i>
<br>&ensp;Yellow = <i>defending</i> or <i>defiant</i>
<br>&ensp;Green = <i>ghost touch</i> or <i>brilliant-energy</i>
<br>&ensp;Blue = <i>returning</i> or <i>dancing</i>
<br>&ensp;Indigo = <i>monstrous-humanoid bane</i> or <i>furyborn</i>
<br>&ensp;Violet = <i>holy</i> or <i>nullifying</i>.',
    'Additionally, when scoring a critical hit, this spear has enhanced abilities depending on what color it is glowing, as follows:
<br>&ensp;Red = Critical hits deal an additional 2d10 fire damage to all creatures within 15 feet of the target, except the wielder.
<br>&ensp;Orange = The <i>Spear of Seven Parts</i>'' critical multiplier increases by one step.
<br>&ensp;Yellow = Critical hits cause this weapon to cast <i>dispel magic</i> on the target.
<br>&ensp;Green = Critical hits cause this weapon to <i>disrupt</i> and completely destroy the target if it is undead.
<br>&ensp;Blue = The extra damage caused by a critical hit is transferred to the wielder as healing.
<br>&ensp;Indigo = Critical hits affect the target as per the spell <i>dimension door</i>, moving them to a space of the wielder''s choice within line of sight and within 30ft.
<br>&ensp;Violet = Critical hits grant the wielder an additional attack using the same bonus as the original attack, targeting any creature within range.',
    'If the <i>Spear of Seven Parts</i> is disassembled and each piece taken to a different outer plane, wherein the bearer uses their fragment of the spear to commit a heinous act that is anathema to that plane''s foundation, the spear will lose its cohesion and disintegrate.',
    TRUE,
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    1,
    'artifact',
    'weapon',
    1,
    FALSE,
    'Spear of Seven Parts - Red Spear-Tip',
    'This 10-inch long piece of azlanti crystal is braced within a mithral housing engraved with the words "Orgē Aganakteō," meaning "Filled with Righteous Anger." When gripped by a creature attuned to its matching districts'' spear, it projects the memory of its missing parts in order to take form. Each piece weighs 2 lbs and glows in unison with its corresponding districts'' spear.',
    'The <i>Spear of Seven Parts</i> is a mithral spear with a total enhancement bonus of +1 for each attached piece (maximum +5, minimum +1). Each piece of the <i>Spear of Seven Parts</i> may be activated while its corresponding district spear is active to change the spear''s abilities by exchanging an equivalent amount of weapon enhancement.',
    'This piece may be activated to grant the spear <b><i>flaming</i></b>. When this piece is glowing, critical hits deal an additional 2d10 fire damage to all creatures within 15 feet of the target, except the wielder.
<br><br>When at least three pieces of this spear are joined, the <i>Spear of Seven Parts</i> gains the ability to transform into any type of spear from the fighter weapons group, always transforming into a spear of the correct size for the creature wielding it. This functions as the resizing and transformative weapon properties.',
    'If the <i>Spear of Seven Parts</i> is disassembled and each piece taken to a different outer plane, wherein the bearer uses their fragment of the spear to commit a heinous act that is anathema to that plane''s foundation, the spear will lose its cohesion and disintegrate.',
    TRUE,
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    1,
    'artifact',
    'weapon',
    2,
    FALSE,
    'Spear of Seven Parts - Orange Reinforced Upper Shaft',
    'This 11-inch long piece of azlanti crystal is braced within a mithral housing is engraved with the word "Ploúthos," meaning "abundance" or "filled." When gripped by a creature attuned to its matching districts'' spear, it projects the memory of its missing parts in order to take form. Each piece weighs 2 lbs and glows in unison with its corresponding districts'' spear.',
    'The <i>Spear of Seven Parts</i> is a mithral spear with a total enhancement bonus of +1 for each attached piece (maximum +5, minimum +1). Each piece of the <i>Spear of Seven Parts</i> may be activated while its corresponding district spear is active to change the spear''s abilities by exchanging an equivalent amount of weapon enhancement.',
    'This piece may be activated to grant the spear <b><i>keen</i></b>. When this piece is glowing, the <i>Spear of Seven Parts</i>'' critical multiplier increases by one step.
<br><br>When at least three pieces of this spear are joined, the <i>Spear of Seven Parts</i> gains the ability to transform into any type of spear from the fighter weapons group, always transforming into a spear of the correct size for the creature wielding it. This functions as the resizing and transformative weapon properties.',
    'If the <i>Spear of Seven Parts</i> is disassembled and each piece taken to a different outer plane, wherein the bearer uses their fragment of the spear to commit a heinous act that is anathema to that plane''s foundation, the spear will lose its cohesion and disintegrate.',
    TRUE,
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    1,
    'artifact',
    'weapon',
    3,
    FALSE,
    'Spear of Seven Parts - Yellow Upper Shaft',
    'This 12-inch long piece of azlanti crystal is braced within a mithral housing isengraved with the word "Agónizomai," generally understood to mean "overcome with zeal." When gripped by a creature attuned to its matching districts'' spear, it projects the memory of its missing parts in order to take form. Each piece weighs 2 lbs and glows in unison with its corresponding districts'' spear.',
    'The <i>Spear of Seven Parts</i> is a mithral spear with a total enhancement bonus of +1 for each attached piece (maximum +5, minimum +1). Each piece of the <i>Spear of Seven Parts</i> may be activated while its corresponding district spear is active to change the spear''s abilities by exchanging an equivalent amount of weapon enhancement.',
    'This piece may be activated to grant the spear <b><i>defending</i></b>. When this piece is glowing, the <i>Spear of Seven Parts</i> casts <i>dispel magic</i> on its target when delivering a critical hit.
<br><br>When at least three pieces of this spear are joined, the <i>Spear of Seven Parts</i> gains the ability to transform into any type of spear from the fighter weapons group, always transforming into a spear of the correct size for the creature wielding it. This functions as the resizing and transformative weapon properties.',
    'If the <i>Spear of Seven Parts</i> is disassembled and each piece taken to a different outer plane, wherein the bearer uses their fragment of the spear to commit a heinous act that is anathema to that plane''s foundation, the spear will lose its cohesion and disintegrate.',
    TRUE,
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    1,
    'artifact',
    'weapon',
    4,
    FALSE,
    'Spear of Seven Parts - Green Central Haft',
    'This 14-inch long piece of azlanti crystal is braced within a mithral housing is engraved with the word "Perisseuó," which appears to be an oath. When gripped by a creature attuned to its matching districts'' spear, it projects the memory of its missing parts in order to take form. Each piece weighs 2 lbs and glows in unison with its corresponding districts'' spear.',
    'The <i>Spear of Seven Parts</i> is a mithral spear with a total enhancement bonus of +1 for each attached piece (maximum +5, minimum +1). Each piece of the <i>Spear of Seven Parts</i> may be activated while its corresponding district spear is active to change the spear''s abilities by exchanging an equivalent amount of weapon enhancement.',
    'This piece may be activated to grant the spear <b><i>ghost touch</i></b>. When this piece is glowing, critical hits completely destroy target undead as if <i>disrupted</i>.',
    'If the <i>Spear of Seven Parts</i> is disassembled and each piece taken to a different outer plane, wherein the bearer uses their fragment of the spear to commit a heinous act that is anathema to that plane''s foundation, the spear will lose its cohesion and disintegrate.',
    TRUE,
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'artifact',
    'weapon',
    5,
    TRUE,
    'Spear of Seven Parts - Blue Lower Shaft',
    'This 16-inch long piece of azlanti crystal is braced within a mithral housing is engraved with the words "Horkos Euforía," which translates to both charity and love. When gripped by a creature attuned to its matching districts'' spear, it projects the memory of its missing parts in order to take form. Each piece weighs 2 lbs and glows in unison with its corresponding districts'' spear.',
    'The <i>Spear of Seven Parts</i> is a mithral spear with a total enhancement bonus of +1 for each attached piece (maximum +5, minimum +1). Each piece of the <i>Spear of Seven Parts</i> may be activated while its corresponding district spear is active to change the spear''s abilities by exchanging an equivalent amount of weapon enhancement.',
    'This piece may be activated to grant the spear <b><i>returning</i></b>. When this piece is glowing, the extra damage caused by a critical hit is transferred to the wielder as healing. This healing is equal to the extra damage dealt to the target before they reached zero hit points.
<br><br>When at least three pieces of this spear are joined, the <i>Spear of Seven Parts</i> gains the ability to transform into any type of spear from the fighter weapons group, always transforming into a spear of the correct size for the creature wielding it. This functions as the resizing and transformative weapon properties.',
    'If the <i>Spear of Seven Parts</i> is dissembled and each piece taken to a different outer plane, wherein the bearer uses their fragment of the spear to commit a heinous act that is anathema to that plane''s foundation, the <i>Spear of Seven Parts</i> will lose its cohesion and disintegrate.',
    TRUE,
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'artifact',
    'weapon',
    6,
    TRUE,
    'Spear of Seven Parts - Indigo Reinforced Lower Shaft',
    'This 18-inch long piece of azlanti crystal is braced within a mithral housing is engraved with the word "Anapauó," commonly understood as the azlanti word for the sleep of death. When gripped by a creature attuned to its matching districts'' spear, it projects the memory of its missing parts in order to take form. Each piece weighs 2 lbs and glows in unison with its corresponding districts'' spear.',
    'The <i>Spear of Seven Parts</i> is a mithral spear with a total enhancement bonus of +1 for each attached piece (maximum +5, minimum +1). Each piece of the <i>Spear of Seven Parts</i> may be activated while its corresponding district spear is active to change the spear''s abilities by exchanging an equivalent amount of weapon enhancement.',
    'This piece may be activated to grant the spear <b><i>monstrous-humanoid bane</i></b>. When this piece is glowing, critical hits affect the target as per the spell <i>dimension door</i>, moving them to a space of the wielder''s choice within line of sight and within 30ft of their previous position. This cannot move the target to an inherantly unsafe location.
<br><br>When at least three pieces of this spear are joined, the <i>Spear of Seven Parts</i> gains the ability to transform into any type of spear from the fighter weapons group, always transforming into a spear of the correct size for the creature wielding it. This functions as the resizing and transformative weapon properties.',
    'If the <i>Spear of Seven Parts</i> is dissembled and each piece taken to a different outer plane, wherein the bearer uses their fragment of the spear to commit a heinous act that is anathema to that plane''s foundation, the <i>Spear of Seven Parts</i> will lose its cohesion and disintegrate.',
    TRUE,
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'artifact',
    'weapon',
    7,
    TRUE,
    'Spear of Seven Parts - Violet Base',
    'This 21-inch long piece of azlanti crystal is braced within a mithral housing is engraved with the words "Tímios Peri̱fánia," meaning "[this] is my Glory." When gripped by a creature attuned to its matching districts'' spear, it projects the memory of its missing parts in order to take form. Each piece weighs 2 lbs and glows in unison with its corresponding districts'' spear.',
    'The <i>Spear of Seven Parts</i> is a mithral spear with a total enhancement bonus of +1 for each attached piece (maximum +5, minimum +1). Each piece of the <i>Spear of Seven Parts</i> may be activated while its corresponding district spear is active to change the spear''s abilities by exchanging an equivalent amount of weapon enhancement.',
    'This piece may be activated to grant the spear <b><i>speed</i></b>. When this piece is glowing, critical hits grant the wielder an additional attack using the same bonus as the original attack. This attack may target any creature within range, not just the original target. If thrown, this additional attack represents a ricochet and must target a creature within 30ft. of the original target.
<br><br>When at least three pieces of this spear are joined, the <i>Spear of Seven Parts</i> gains the ability to transform into any type of spear from the fighter weapons group, always transforming into a spear of the correct size for the creature wielding it. This functions as the resizing and transformative weapon properties.',
    'If the <i>Spear of Seven Parts</i> is dissembled and each piece taken to a different outer plane, wherein the bearer uses their fragment of the spear to commit a heinous act that is anathema to that plane''s foundation, the <i>Spear of Seven Parts</i> will lose its cohesion and disintegrate.',
    TRUE,
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    1,
    'artifact',
    'weapon',
    NULL,
    FALSE,
    'Mantis Blade',
    'This sinister looking sawtooth sabre is made of red chitin and bright steel that forms a curved, serrated blade.',
    'The <i>Mantis Blade</i> is an intelligent <i>+2 axiomatic sawtooth sabre</i> which increases the sneak attack damage of its wielder by +1d6 sneak attack, granting the ability as a rogue if they don''t already possess it. When a creature is wounded with the blade, the wielder grant the blade the bane special ability against that type of creature as a swift action. This bane ability lasts for 10 minutes and is usable once per day. 
<br><br>Sacred to the faith of the mantis god Achaekek, the mantis blade also grants bonuses to a Red Mantis assassin who wields it. A Red Mantis assassin wielding the mantis blade gains a +2 bonus to the DC of her prayer attack, and may use her red shroud and fading abilities each an additional time per day.',
    'The <i>Mantis Blade</i> has the following statistics:
<b>Alignment</b> LE; <b>Ego</b> 16
<b>Senses</b> vision, hearing 60ft., darkvision 60ft.
<br><b>Int</b> 10, <b>Wis</b> 12, <b>Cha</b> 14
<br><b>Communication</b> telepathy
<br><b>Spell-Like Abilities</b> (CL 20th, concentration +22)
<br>&ensp; 3/day - <i>alter self, darkness, spider climb, true strike</i>
<br>&ensp; 1/day - <i>clairaudience/clairvoyance, deeper darkness, dimension door, greater invisibility</i>',
    'If a single wielder uses the mantis blade to slay nine rightful ruling monarchs, the weapon can be destroyed by a successful sunder maneuver.',
    TRUE,
    TRUE
  )
ON CONFLICT (campaign_id, item_name) DO NOTHING;
-- End Hardcoded Artifacts seed

-- Start Hardcoded Relics Seed

WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
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
  unlock_method,
  unlocked_boons,
  destruction_method,
  boons_visible,
  unlock_visible,
  unique_destruction
)
VALUES 
  ((SELECT campaign_id FROM c_id),
    2,
    'relic',
    'weapon',
    NULL,
    TRUE,
    'Blade of the Blood Feud',
    'First recovered by Sharrowsmith from an old dwarven mine, this dull looking machete is with the seal of a long-dead dwarven clan and lies ready to draw blood in service to an ancient design. It''s steel doesn''t lend itself to either polish or the grindstone, as if the blade deliberately wants to look non-threatening.',
    'This <i>+1 rival-bane machete</i> applies the bane property against agents directly employed by a rival faction. To qualify as a rival faction, the leaders of both factions must acknowledge the other as a bitter blood-rival and a threat, with a direct financial incentive to eliminating the competitor; merely desiring the destruction of one-another is not enough. Additionally, this blade provides a +2 circumstance bonus on all survival checks, instead of the normal +1 on checks to get along in the wild.',
    'Eliminate a rival leader with an ironic fate worse than death.',
    'The <i>Blade of the Blood Feud</i> looks shiny and deadly when properly wielded, but appears dull and lifeless in the hands of others. The blade becomes a <i>+2 heart-seeking ominous rival-bane machete</i>, and the circumstance bonus it applies on survival checks increases to +6. If the wielder begins their turn or ends their movement next to a dying or disabled agent employed by a rival faction, the blade forces them to spend a standard action to attempt a touch attack to touch the blade to the agents throat. If successful, the agent must make a DC17 will save or die as though slain by a <i>death knell</i> spell, and the wielder gains the benefits as though they cast the spell. If the wielder attempts to resist this action, they must make a DC17 will save to drop the blade.',
    NULL,
    FALSE,
    TRUE,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    1,
    'relict',
    'item',
    NULL,
    FALSE,
    'Legendary Warrior Totem',
    'This Legendary Warrior Totem depicts one of the 10 Magic Warriors of Old-Mage Jatembe, woven by the hands of a legendary spirit and imbued with the zeitgeist of the magic warriors themselves.',
    'This amulet acts as an amulet of natural armor +2. Legendary Warriors Found: Azure Leopard.',
    'Slay a unique magical beast imbued with zeitgeist, and present a trophy from it to the legendary spirit of Grand Prince Cyricas, the Leaping Lion. Then it needs to be worn by a creature with an associated awakened spirit totem.',
    'When worn by a creature with an associated awakened spirit totem, they may activate this Legendary Totem once per day when activating their totemic power, to commune with the spirit of the magic warrior for 1 minute. This unlocks their totem''s legendary power, as well as granting them the shapechanger subtype, DR 10/silver, and the ability to instantly polymorph chosen parts of their body into that of their totem animal as part of an attack action, granting all of the natural attacks (but not special attacks) possessed by their totem animal. These natural attacks count as magical, and deal half damage to swarms instead of none. It is rumored that Old-Mage Jatembe possessed a special totem of his own, one that can only be found by gathering together all ten magic warriors.',
    'If the wearer is slain while communing with the spirit of the magic warrior, the totem is destroyed and will need to be remade. Only one totem for each magic warrior can exist at a time.',
    FALSE,
    TRUE,
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'relic',
    'item',
    NULL,
    TRUE,
    'Ring of Seven Virtues',
    'This bronze band is covered in geometric shapes and studded with tiny pearls. When within the boarders of Saventh-Yhi, the pearls glow with the colors of the seven spears, corresponding to whichever one is lit.',
    'The wearer of the <i>Ring of Seven Virtues</i> gains a constant <i>endure elements</i> effect and a +7 competence bonus on survival checks. Also, even if the bearer has not been keeyed to the districts spear, they gain the benefits of that districts spear when within that district while the spear is lit.',
    'Gain access to the prismatic computer.',
    NULL,
    NULL,
    FALSE,
    TRUE,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'relic',
    'weapon',
    NULL,
    TRUE,
    'Rod of Well-Deserved Rest',
    'This rod appears to be made of polished gold, and features three blown-glass onion-shaped domes at one end. It seems heavy enough to be wielded as a weapon, should the need arise.',
    'This rod functions as a <i>+1 light mace</i> when wielded as a weapon. Up to three times per day, with a successful hit in combat, the wielder may attempt to put the target of the attack to sleep (Will DC14 negates). This functions as the <i>sleep</i> spell, but there is no limit to the Hit Dice that may be affected. Any creature put to sleep with this rod enters a dreamscape, which the wielder may choose to enter at will.
<br>Additionally, the wielder may create an opaque sphere of force to protect themselves from the elements once per day, as a <i>tiny hut</i> with a 5-foot radius. If the wielder goes to sleep with the rod in their possession, 2 hours of sleep is the equivalent of 8 hours of rest, and 8 hours of rest provides the equivalent benefits of a full day of bed rest, as well as granting the wielder the benefits of the <i>good hope</i> spell for 1 hour after waking.
<br><br>In any dreamscape, regardless of the wearers form, this rod may continue to be wielded, or passed to another creature. If the wielder is not a medium creature while in the dreamscape, they may wield the rod as though they were a medium creature.',
    'Fully attune to a dream totem and unlock its legendary powers.',
    'There is no longer a limit to the number of times per day that the wielder may attempt to put a creature to sleep after striking them with the rod, and the wielder gains three additional daily uses of their totem magic.',
    NULL,
    FALSE,
    TRUE,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'relic',
    'weapon',
    NULL,
    TRUE,
    'Savith''s Swift Strike',
    'A replica of the heroine Savith''s sword, even this impersonation of her blade is filled with the zeitgeist of an ancient nation. This sword is incredibly heavy, with a gray stone blade that is otherwise unremarkable, except for the constant light that radiates from it.',
    'This <i>+1 adamantine aberration-bane keen longsword</i> requires a DC30 strength check to hold aloft (reduced by 3 for each azlanti relic the person is holding, or by 5 for azlanti-blooded humans). A creature only needs to make this strength check once - if they fail, they cannot attempt it again until the next new moon. After they succeed on this strength check, the sword is weightless in their hands - otherwise, it weighs 200lbs. Being strong enough to wield this weapon, however, does not make you automatically worthy of it. IF you have not become worthy of this weapon, and another creature successfully wields it, you must make the check to wield it anew. If you are unworthy of this weapon, you may never wield it, and automatically fail any checks required to wield it.',
    'Slay seven titanic monstrosities while either wielding this sword or with the sword on your person (not in an extradimensional space). You are unworthy of this weapon if you are evil, if you murder an innocent civilian, or if you flee an enemy who then kills a friend.',
    NULL,
    NULL,
    FALSE,
    TRUE,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'relic',
    'shield',
    NULL,
    TRUE,
    'Shield of Acavna',
    'This azlanti shield contains a large moonstone in the center surrounded by bronze inlaid with gold depictions of crossed spears as well as the acavnan aphorism "The brave do not live forever; the cautious do not live at all."',
    'This <i>+2 quickdraw light bronze shield</i> is as hard as steel (but immune to rust) and is only held in the hand, being as easy to stow as it is to draw. This shield counts as a holy symbol of Acavna, as well as of any deity granted their divine spark through the starstone (namely Aroden, Iomedae, Cayden Calien, and Norberger).
<br><br>All creatures within 30 feet of a visible <i>Shield of Acavna</i> are treated as though they can see both the full moon and the open night''s sky.
<br>As an immediate action 1/day, the bearer may take a 5ft. step and enter the square of an ally being attacked to interpose themselves, forcing the attack to resolve against their touch AC instead. This must be done before the result of the attacker''s roll is revealed. If this attack was not the result of the ally''s movement, after resolving the attack, the ally may either spend an immediate action to take a 5ft. step into the bearer''s former square, fall prone, or force the bearer to fall prone.',
    'Interpose yourself on behalf of an ally using the <i>Shield of Acavna</i> against an attack that was a critical threat, which deals enough damage to you that it subjects you to massive damage and would have killed them outright. This may make you worthy even if it kills you, though you would still be dead. If you ever murder a helpless innocent, you stop being worthy of this item and can never become worthy of it.',
    'The <i>Shield of Acavna''s</i> enhancement bonus increases to +4, and it grants energy resistance 10 against an element of the bearers choice (default is cold). The bearer may attune to a different element by offering a prayer to acavna as a 1-minute action. Additionally, when they use the shield to interpose themselves, they may move up to half their movement speed instead of taking a 5ft step. This movement provokes attacks of opportunity as normal.
<br>Once per day as a standard action, the bearer can emit a 30'' aura of protection for 1 minute, granting all allied creatures within the aura a +4 deflection bonus to AC and energy resistance 10 vs the attuned element. During this time, and for 1 hour after, the shield loses its enhancement bonus to AC and does not provide energy resistance to its bearer.',
    NULL,
    TRUE,
    TRUE,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'relic',
    'weapon',
    NULL,
    TRUE,
    'Seaspike',
    'This elegant, short-hafted trident appears to be made from razor-sharp coral. A jade serpent wraps around the haft of the weapon before being impaled on the haft''s spiked foot.',
    '<i>Seaspike</i> is treated as a light weapon for the purposes of Weapon Finesse and other similar abilities, and may be wielded as either a trident or a shortspear with the <i>+1 animal bane</i> special abilities. If a monstrous humanoid attempts to wield <i>Seaspike</i>, they automatically drop the weapon at the end of their turn.
<br><br>Last, the wielder of <i>Seaspike</i> gains a bonus to fortitude saving throws against poison equal to twice the weapons enhancement bonus.',
    'The wielder must recover from three different poisons while holding this weapon, without other aid. Intentionally exposing themselves to poison does not apply for this ability. If the wielder ever uses poison against another, they become unworthy of <i>Seaspike</i>.',
    '<i>Seaspike''s</i> enhancement bonus increases to +3, and its bane special quality also applies against any serpent, including serpentine monstrous humanoids and magical beasts (at the GM''s discretion).
<br>As a standard action, the wielder may attempt a single melee or thrown ranged attack with seaspike to embed their weapon in their target. If this special attack hits, in addition to doing normal damage, the target must make a reflex save with a DC = 10 + the amount the attack roll exceeded the targets AC. If they fail, they become entangled by the weapon. If the target is a serpentine creature, they also take a penalty to natural attacks equal to Seaspike''s effective enhancement bonus until the weapon is removed.
<br>Special: If the wielder has vital strike, this special attack action counts as vital strike.',
    NULL,
    TRUE,
    TRUE,
    FALSE
  )
ON CONFLICT (campaign_id, item_name) DO NOTHING;
-- End Hardcoded Relics Seed

-- Start resources.ejs Gallery Seed
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
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
      WHERE item_name = 'Spear of Seven Parts'),
    '/images/objects/loot-spear-seven-parts-full.webp',
    'Spear of Seven Parts - Complete',
    TRUE
  ),
  ((SELECT item_id FROM i_id 
      WHERE item_name = 'Spear of Seven Parts - Red Spear-Tip'),
    '/images/objects/loot-spear-seven-parts1.webp',
    'Spear of Seven Parts - Part 1',
    TRUE
  ),
  ((SELECT item_id FROM i_id 
      WHERE item_name = 'Spear of Seven Parts - Orange Reinforced Upper Shaft'),
    '/images/objects/loot-spear-seven-parts2.webp',
    'Spear of Seven Parts - Part 2',
    TRUE
  ),
  ((SELECT item_id FROM i_id 
      WHERE item_name = 'Spear of Seven Parts - Yellow Upper Shaft'),
    '/images/objects/loot-spear-seven-parts3.webp',
    'Spear of Seven Parts - Part 3',
    TRUE
  ),
  ((SELECT item_id FROM i_id 
      WHERE item_name = 'Spear of Seven Parts - Green Central Haft'),
    '/images/objects/loot-spear-seven-parts4.webp',
    'Spear of Seven Parts - Part 4',
    TRUE
  ),
    ((SELECT item_id FROM i_id 
      WHERE item_name = 'Spear of Seven Parts - Blue Lower Shaft'),
    '/images/objects/loot-spear-seven-parts5.webp',
    'Spear of Seven Parts - Part 5',
    TRUE
  ),
  ((SELECT item_id FROM i_id 
      WHERE item_name = 'Spear of Seven Parts - Indigo Reinforced Lower Shaft'),
    '/images/objects/loot-spear-seven-parts6.webp',
    'Spear of Seven Parts - Part 6',
    TRUE
  ),
  ((SELECT item_id FROM i_id 
      WHERE item_name = 'Spear of Seven Parts - Violet Base'),
    '/images/objects/loot-spear-seven-parts7.webp',
    'Spear of Seven Parts - Part 7',
    TRUE
  ),
  ((SELECT item_id FROM i_id
      WHERE item_name = 'Mantis Blade'),
    '/images/objects/loot-mantis-blade.webp',
    'Mantis Blade',
    TRUE
  ),
  ((SELECT item_id FROM i_id
      WHERE item_name = 'Legendary Warrior Totem'),
    '/images/objects/loot-legendary-totem.webp',
    'Legendary Warrior Totem',
    TRUE
  ),
  ((SELECT item_id FROM i_id
    WHERE item_name = 'Blade of the Blood Feud'),
  '/images/objects/loot-bane-machete.webp',
  'Blade of the Blood Feud',
  TRUE
  ),
  ((SELECT item_id FROM i_id
    WHERE item_name = 'Ring of Seven Virtues'),
  '/images/objects/loot-ring-seven-virtues.webp',
  'Ring of Seven Virtues',
  TRUE
  ),
  ((SELECT item_id FROM i_id
    WHERE item_name = 'Shield of Acavna'),
  '/images/objects/loot-shield-acavna.webp',
  'Shield of Acavna',
  TRUE
  ),
  ((SELECT item_id FROM i_id
    WHERE item_name = 'Seaspike'),
  '/images/objects/loot-seaspike.webp',
  'Seaspike',
  TRUE
  )
ON CONFLICT DO NOTHING;
-- End resources.ejs Gallery Seed
-- END resources.ejs SEED BLOCK

-- START maps.ejs SEED Block
-- Start Session Spotlight Seeds
-- LOCATION SPOTLIGHTS: session_logs CTE
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
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
    'Sargava at a Glance',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Smuggler''s Shiv',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    3,
    'Eleder',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    4,
    'Kalabuto',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    5,
    'Fort Bandu',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    6,
    'The Korir River',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    7,
    'The Screaming Jungle',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    8,
    'The Bandu Hills',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    9,
    'Ruins of Tazion',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    10,
    'The Lost City of Saventh-Yhi',
    'location spotlight'
  )
ON CONFLICT (campaign_id, log_type, session_number) DO NOTHING;
-- End Session Spotlight Seeds

-- Start Session Spotlight Gallery
-- LOCATION SPOTLIGHTS: gallery CTE
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
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
    '/images/map/map-sargava.webp',
    'Sargava at a Glance',
    FALSE
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 2),
    '/images/hero/hero-souls-for-smugglers-shiv.webp',
    'Smuggler''s Shiv',
    FALSE
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 3),
    '/images/hero/hero-eleder.webp',
    'Eleder',
    FALSE
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 4),
    '/images/hero/hero-kalabuto.webp',
    'Kalabuto',
    FALSE
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 5),
    '/images/npc/npc-praetor-sylien.webp',
    'Fort Bandu',
    FALSE
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 6),
    '/images/map/sketch-great-river.webp',
    'The Korir River',
    FALSE
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 7),
    '/images/hero/hero-screaming-jungle.webp',
    'The Screaming Jungle',
    FALSE
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 8),
    '/images/hero/hero-bandu-hills.webp',
    'The Bandu Hills',
    FALSE
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 9),
    '/images/hero/hero-tazion.webp',
    'Ruins of Tazion',
    FALSE
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 10),
    '/images/hero/hero-saventh-yhi.webp',
    'The Lost City of Saventh-Yhi',
    FALSE
  )
ON CONFLICT DO NOTHING;
-- End Session Spotlight Gallery

-- Start Session Spotlight Paragraphs
-- LOCATION SPOTLIGHTS: paragraphs CTE
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
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
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 1),
    1,
    'Beset by devil-binding pilgrims and inescapable debts to pirate lords, as well as generations of resentment from the nation''s subjugated indigenous peoples, the colony of Sargava remains a bastion of northern culture and civilization in the heart of the southern wilds. Once part of a vast and mighty empire long since fallen to dust, as evidenced by the crumbling ruins still lurking beneath the veneer of lush farmland and verdant jungle, Sargava''s rich landscape is home to fierce Mwangi natives and even fiercer predators of the deep jungle, as well as a dwindling population of northern colonials who seek to uphold their ideals of culture and breeding at all cost, straining against the tides of resentment that may soon sweep them into the sea and return the land to its original owners.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 1),
    2,
    'Founded over 500 years ago by Prince Haliad I as part of Cheliax''s expansionist Everwar, Sargava stood as the jewel of the empire for centuries. But when Aroden died, the empire was thrown into chaos, and Sargava''s ruler backed the wrong house in the Chelish Civil War. House Thrune took control of Cheliax and sent a flotilla of warships to retake the colony that had supported their enemy in the bloody conflict. Grand Custodian Grallus anticipated the onslaught, however, and made a fateful alliance with the Free Captains of the Shackles. Swooping out of Desperation Bay to pounce on the unsuspecting Chelish Navy, the pirates'' superior fleet swiftly ended the threat to their southern neighbor, and extracted a mighty price from Sargava for their efforts. To this day, vast portions of Sargava''s wealth flow into the Free Captains'' coffers for past assistance and assurance of continued naval protection.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 1),
    3,
    'Financially weakened by the Free Captains'' high demands and cut off from many of their former trade partners to the north, Sargava faces an even larger threat from within. The native Mwangi people, inspired by the teachings of a mysterious, undead child-god in the nearby city-state of Mzali, move ever closer to open rebellion to free themselves from colonial rule. While Cheliax no longer has an official stake in Sargava''s government, the colonial Sargavan minority maintains control of the vastly larger native population. But the natives know that they have the resources of the entire Mwangi Expanse at their backs, and that Grand Custodian Utilinus''s government is in a poor position to quell a rebellion.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 2),
    1,
    '<i>"They say the dead walk on Smuggler''s Shiv, and that those who have yet to die dine on the flesh of their kin. They say that the very plants and animals of the island thirst for blood. And they say that those who sail too close to the island''s cutting edge are already doomed, even before their ships are impaled and slip beneath the shark-hungry waves. The island itself is a grave to all manner of folk - pirate and soldier, merchant and smuggler alike. By day, one who approaches too closely can hear their screams from the green that crowns the isle, and by night one can watch the witchlights dance on its shore, said to be glowing cannibal ghosts eager to lure new meals to their shore."</i>'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 2),
    2,
    '<i>"They say all this and more about Smuggler''s Shiv. I can think of no better place to hide my treasure."</i> - Final recorded words of Captain Lortch Quellig'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 2),
    3,
    'Smuggler''s Shiv is a notorious island north of Eleder. It''s not shown on most maps, but is rightfully feared by those who ply the waters of Desperation Bay. The island is named not only for the knife-like shape of its coastline, but for its uncanny habit of wrecking ships that draw too near—mostly smugglers eager to avoid detection by Sargava''s navy.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 2),
    4,
    'It''s commonly believed that the shores of Smuggler''s Shiv are haunted by the ghosts and ghouls of the sailors who have died on the jagged rocks and reefs surrounding the island. These rumors are supported by reports of several failed attempts to establish long-lasting colonies on the remote island.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 2),
    5,
    'When Sargava was first settled, Chelish engineers erected a lighthouse on the Shiv''s southwest shore. The light was intended to warn approaching ships of the dangerous waters and, eventually, was to have been the first building in a small colony. The light and all plans for colonization were abandoned just before completion amid rumors of curses, haunts, and cannibalism.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 2),
    6,
    'Rumors hold that a group of shipwrecked Chelish soldiers, survivors of an attempted Thrune invasion of Sargava some 70 years ago, were stranded on the island. The rumors claim that they degenerated into a cannibalistic society, and that their descendants scour the isle''s shores for shipwreck victims to add to their meals.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 3),
    1,
    'Appearance: Eleder is dominated by extensive stone docks, where ships from most nations on the Arcadian Ocean lie moored. The city is an unusual blend of architecture, as the gothic stonework of the colonists'' native Cheliax has adapted to the native building styles in favor of less stuffy, open designs that better combat the heat. Although Eleder itself is surrounded by a sturdy stone wall, the individual homes of many colonials also feature low stone walls and iron gates—a decorative concession to their roots that does nothing to make their homes less comfortable. These buildings are joined by more practical wood and canvas structures, and outside the city walls, countless mud-daub huts — the homes of the native workers — stretch far out into the banana, cocoa, and pineapple plantations.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 3),
    2,
    'History: The original founders of Sargava selected a small, natural harbor as the site of their future colony, gradually expanding from a stockaded encampment to a walled city with a fully equipped shipyard. It was named Eleder after the daughter of one of the original colonists, whose gentle diplomacy and efforts to learn Polyglot enabled the colonists to live in cooperation with the locals. Though the city today is named for Eleder''s efforts, the first several decades were fraught with violent misunderstandings between Chelaxians and natives. Large numbers of Chelish troops were brought in to help bring the native tribes under control, and they gradually convinced the tribes to assist the colonists in bringing “order” and industry to their “savage” land. When Sargava broke from Cheliax with the help of the Shackles, the citizens of Eleder opened up their repair yards as docks to ships of any nation, provided they paid a hefty fee for the privilege. Eleder is now considered one of the finest shipyards in Garund, and certainly the finest on the western coast. With the appointment of Utilinus to the position of Grand Custodian, Eleder has even made a few strides toward attracting other foreign businesses — mainly merchants from Nidal, Varisia, and Rahadoum. But though he has gained popularity with the colonials, the Grand Custodian is not well liked by the Hurricane King, who heavily taxes the merchant fleets his pirates guide past the Eye of Abendego.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 3),
    3,
    'Society: Eleder is a city of contradictions. The colonials live in relative luxury, while the native workers dwell in poverty outside the city walls. While countless scruffy sailors and explorers parade through Eleder every year en route to adventures in the interior — or simply on their way to enjoy the brothels and clubs Eleder maintains near the docks to keep pirates out of the city proper — the colonials maintain high personal standards of decorum and propriety. Although Grand Custodian Utilinus is Sargava''s authority, the elderly Lady Madrona Daugustana is the city''s unofficial leader. As the oldest living colonial in all of Sargava, Lady Madrona bears the responsibility of upholding the ideals and customs of her forebearers, and any major undertaking must meet her approval. While the majority of colonials consider the native Mwangi to be a “lesser people” than themselves, they rely on them not only as a labor pool but as a standing militia of poorly paid volunteers. Eleder''s Praetor, Commander Ezio Egorius, regularly drills the Sargavan Guard, which consists of mixed units, though all Mwangi natives are enlisted regulars while the colonials are all officers, much to the ire of many Mwangi veterans.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 3),
    4,
    'Adventurers: Though Sargava relies on the influx of foreign money to pay its debts to the Shackles pirates, the Eleder colonials would much rather the seemingly constant stream of adventurers and explorers sail up the Korir River to their destinations in-country, bypassing Eleder completely. In the words of Lady Madrona Daugustana, “Adventurers merely pass through Eleder; we must live here when they are long gone.” The major problem most colonials have with adventurers is that the colonials are barely keeping the Mwangi populace under control as it is, and in their view, the last thing they need is thrill-seekers or would-be “liberators” stirring up the natives, either by picking fights with tribal warriors or speaking ill of the colonials to the workers. Adding to the problem, adventurers rarely bother to learn the local customs, let alone observe the agreements between the tribes and the colonials, and a single incident can sour an entire tribe against all foreigners. Finally, the people of Eleder are obsessed with dignity and decorum — going even beyond many northern countries in their attempts to prove that they''ve remained “civilized” — and consider the carousing of bored adventurers the height of impropriety. It is bad enough for dwarves to stagger through the streets singing after dark, but having one''s daughter indecently solicited by an Ulfen barbarian quickly alienates even the most open-minded Sargavan colonist.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 4),
    1,
    'From a distance, Kalabuto seems to be nothing more than a low hill surrounded by fields of pineapples, with a few scattered buildings under a pall of smoke. This is because the city ruins are almost entirely covered with centuries of jungle growth. Closer up, visitors quickly notice the thousands of native Mwangi coming and going from the city in the hustle and bustle of commerce and daily life. For many, it''s not until they approach quite close to the city gates that they realize the hill is actually a collection of crumbling stone buildings covered in tangled vines and other greenery.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 4),
    2,
    'As it stands, the city appears to be overgrown by the jungle, with a large collection of shanties and warehouses along the riverbank. Kalabuto is a center of trade with the Mwangi interior, serving as a trade hub between foreign colonials, foreigners, and indigenous tribespeople. Over the years, overland caravans have declined in favor of more efficient river barges. To accommodate the increase in vessels, the city erected a snaking boardwalk connected to an elaborate tangle of docks. Warehouses make up the bulk of the structures along the water''s edge. Further inland, the ruins of the original ancient city begin, climbing up the hill to the more lavish private colonial residences.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 4),
    3,
    'While native Kalabuta-Vidric inhabit the majority of the city''s ruins, a small minority of Sargavan colonials rule the city and have claimed the highest buildings with the best views for themselves. Racial tension is thus rife in Kalabuto. But the city also serves as Sargava''s first line of defense against the city-state of Mzali. In this role Kalabuto has suffered greatly, and has been sacked by the Mzali forces on several occasions.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 4),
    4,
    'Not just the most populous city in Sargava, Kalabuto sits on the edge of the expansive jungle; the last bastion of civilization before the wilderness. In contrast to Eleder, explorers and adventurers find that Kalabuto awaits them with open arms. Those who do not find work as soldiers in the Kalabuto militia usually find plenty of opportunities with expeditions setting out to explore the Bandu Hills, Mzali, and the Screaming Jungle; the colonials look forward to sending new adventurers on the dangerous missions the local Mwangi refuse to undertake, while the natives readily hire themselves out to adventurers, who often treat and pay them better than the colonials.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 5),
    1,
    'Created to protect miners in the Bandu Hills from hostile Mwangi, Fort Bandu has suffered in the last hundred years — much to the consternation of its half elf commander, Praetor Sylien. Having commanded the fort for decades, the Praetor is the grandson of an old elven explorer. Though the aging Sylien rarely ventures outside anymore, he is a skilled commander of his 150-soldier legion, and it is largely thanks to him that miners and explorers are able to operate in the area at all. Fort Bandu nevertheless still has tremendous difficulties with local tribes, particularly the Bandu, who take every opportunity to attack the work crews Sylien has sent to build a bridge over the River of Tears.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 5),
    2,
    'The fort is a small frontier settlement surrounded by high stone walls located on the northern edge of Sargava. Within the fort''s walls, dozens of mining companies maintain outposts out of pavilion tents, hiring laborers and purchasing necessary supplies brought in by merchants from the north, south, and west. The fort''s garrison struggle to maintain a balance of defense of the frontier and protection for the miners and traders within its walls.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 5),
    3,
    'The fort is also a training ground and staging point for Sargava''s embattled militia. Because watches at Fort Bandu are relatively peaceful, militia personnel can become accustomed to their responsibilities before moving on to assignments requiring more vigilance. While the training of the militia excels under the old Praetor''s gaze, he has been openly displeased with the quality of the officer pool sent to him, and he has been unable to train someone he deems would be a suitable successor. Until that day, he does what he deems best for the fort and the people in his jurisdiction, frequently asking adventurers to fill the gap by assisting with training or escorting new patrols in exchange for granting them permission to venture deep into the Laughing Jungle.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 6),
    1,
    'Known to the locals simply as "The River," this river flows through the entirety of the Mwangi Expanse, flowing down from the shattered range, through the jungles and hills, past countless ruined civilizations, and emptying in to the ocean to the west through large delta''s. The word "Korir" is a portmanteau of the polyglot words for Serpent''s Tears, suggesting a river that is winding, sorrowful, and endless. The large number of waterfalls and rapids coupled with the jungle terrain make both navigation and portaging difficult, and while this does reduce the number of crocodiles, hippopotamuses, and enchanted dolphins frequently encountered, it does have the added threat of large snakes dropping on passing prey from branches hanging over the river.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 6),
    2,
    'Few explorers dare navigate the waters all the way to the shattered range, and none have successfully managed to bridge the gap and sail from one end of the continent to the other. While the shattered range is the most obvious perilous obstacle, most explorers get lost just traveling through the screaming jungle, with its heavy daily rains, low obscuring fog, endless chattering monkeys, and heavy dreams which pull people into fevered nightmares and sleeping sickness. Fatigue takes many, and eventually, sleep takes all. It is said that all people dream of the jungle and its treasures...'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 7),
    1,
    'An isolated corner of the Mwangi Expanse, marking the practical border of Sargava and the reach of civilization, the Screaming Jungle is mired in a thick layer of fog that perpetually rolls down from the Shattered Range and the Bandu Hills. Seen from above, it resembles a lake of clouds more than a forest. The harsh screams of primates and birds perpetually echo throughout the suffocatingly humid mists, giving the jungle its infamous name. In contrast to the majestic, tall trees common to other woodlands, the trees of the Screaming Jungle are hooked and stunted. The terrain is sloped, as the jungle extends up onto the nearby mountains, and the tangles of tough roots and wet leaves make it treacherous to navigate by foot.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 7),
    2,
    'It''s not just the footing one need be wary of here. The dreamlike atmosphere of the Screaming Jungle weighs heavily on the minds of all who enter it. Many within the Expanse dream of this place, even those that have never set foot within its mists.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 7),
    3,
    'Similar to the Kaava Lands, the particularities of the Screaming Jungle are not well known, as its location and circumstances make it dangerous to those unfamiliar with it. Those who have ventured in and returned alive often tell lively, meandering stories that do not answer any questions about the mysteries contained within the forest. From the birds that nest above the fog, to the diverse primates who make their home in the canopy, to the ground-dwelling mammals stalking the forest floor, the Screaming Jungle hosts an improbable density of wildlife. Every layer is home to an endemic assortment of insects that range from vibrantly colored to nearly invisible, and from harmless to deadly. Certain insects and birds can also mimic any sound to an eerily accurate degree, and the pattering footsteps of river hogs and rodents are occasionally punctuated by the stalking of the barukal leopard, a predator possessing the ability to shift its fur color to match its surroundings.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 8),
    1,
    'The Bandu Hills serve as the northern border of Sargava, separating civilization from the endless wilderness of the Expanse. These dreary slopes serve as desolate tombs — homes for the restless undead. Bleak stone ruins, bleached bone-white by centuries beneath the pitiless sun, clutter the barren land. Gray clouds sink low into the narrow valleys, cloaking the treacherous paths with dense fog, heavy with the promise of cold, soul-soaking rain. What was once a delicate sign of spring beats upon travelers in freezing, impregnable sheets of slate gray that set the mud of the Bandu Hills churning, grasping hungrily at a traveler''s every step. Despite the constant rain, the hills and vales bear only stone, packed soil, and the occasional empty cairn.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 8),
    2,
    'It has been whispered around many a sputtering bonfire that the sparse, spiky grass and skeletons of petrified trees harbor hungry spirits, eager to steal the breath from unsuspecting travelers. Those who find themselves trekking the neglected trails of those hills soon realize that the shallow valleys have led them astray with far more ease than expected.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 8),
    3,
    'It is where Mount Nakyuk and its cousins rise, like the bony fingers of a nameless, ancient god, that the erosion of the Bandu Hills remains at its most prominent - pock-marked with the forgotten mining camps and hunters'' trails that once fed into the great throat of the earth. Deep underground sprout the fruit of the Bandu Hills: veins of precious gold, deposits of minerals, and sprigs of precious stones that spread open like shimmering blossoms in the hands of foreign explorers and natives alike. It is here, in these hills, the Gold Crown Shipping and Mining Company claims its great treasures.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 8),
    4,
    'The main path through the Bandu Hills is known as the Trail of Burst Souls, which slithers and snakes its way from one side to the other. Travelers note the trail is lined with shallow graves and hastily constructed cairns, some of them thousands of years old. While the graves are plentiful, explorers will find that few have been disturbed by passersby. Rumors abound that those who desecrate the mounds and barrows that mark the trail will find themselves prey for hungry spirits and vengeful husks that stalk the night in search of whomever robbed them of their grave goods.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 9),
    1,
    'The ruins of Tazion stand as a remnant of a forgotten age, an outpost of ancient Azlant lost in the southern Mwangi Jungle. Little remains within its walls, with most of the settlement having crumbled or been buried centuries before. The majority of Tazion''s structures remain unidentifiable. Centuries of weathering and erosion have transformed the once-splendid architecture into little more than scattered stones, curious topography, and fetid tar pits. Few could have ever suspected that the ruins possess the key to finding the lost city of Saventh-Yhi, and its secrets are ripe for the taking.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 9),
    2,
    'Rumor says that a tribe of ape-men, known as charau-ka, now inhabit the ruins, though they wouldn''t share its secrets in the unlikely event they discovered any. From the ruins, they have reportedly established a temple in the shape of a serpent''s skull; this temple is now the ape-men''s main encampment, where they gather to share information and deposit relics they have found in the ruins as offerings to their new snake-god.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 9),
    3,
    'The Charau-Ka are dangerous, xenophobic abominations, whose very name translates from polyglot to "Beware-Them," though it is unclear if they are named after the phrase, or if the phrase exist because of the abominations. As mysterious as they are dangerous, and as fetid as they are strong, it is unwise to try to communicate with them, as while semi-intelligent, they are unlikely to speak unless they can use speaking to bait their victims into a trap. Those who find themselves encircled by Charau-Ka frequently take their own lives to prevent capture, out of fear of being brutalized and transformed into another of their kind.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 10),
    1,
    'One of the most legendary of the still-undiscovered cities of the Mwangi Expanse is Saventh-Yhi. Believed by some to be the classic “city of gold” and by others to be nothing more than a hallucination born from jungle fever, most scholars agree that the real Saventh-Yhi exists somewhere in the deep Mwangi Jungle, where it is likely hidden by a combination of fortuitous terrain and lingering magic. The most fascinating rumors of Saventh-Yhi indicate that the city was established by the ancient Azlanti — if so, it would be the only significant Azlanti ruin in the region. The fact that the city''s name has a meaning in the Azlanti tongue (“Savith''s Grave”—the Azlanti hero Savith being the one most often credited with beheading the serpentfolk god Ydersius) is certainly the most compelling evidence to support this theory. Indeed, the thought of an undiscovered Azlanti ruin in Garund has driven countless Pathfinders, Aspis Consortium agents, and other explorers to unknown dooms, for if such a ruin does exist, the secrets it must hide could revolutionize what is known of the mysterious Age before Earthfall. The city could have been the crown jewel of the empire, a bastion of magic and technology on this continental frontier, and a city that may have largely survived the calamity that destroyed the rest of the civilization ten thousand years ago. Since then, the city has lain lost and sleeping.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 10),
    2,
    '&ensp;&ensp;Ten thousand years is a long time to wait.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 10),
    3,
    'The expedition has now used the light of Tazion to find the city, hidden by a strong curtain of storm and wind 1-mile thick and 70-miles wide. The storm seems to deter all intruders that stumble upon it, as compasses bend out of its way. Now within the city''s borders, trapped by the stormwall, the expedition is completely isolated, hoping to uncover the secrets of the city and claim its treasures and the renown for its discovery.'
  ),
  ((SELECT session_log_id FROM sl_id
      WHERE session_number = 10),
    4,
    'While exploring the lost city, the expedition team has discovered that each of its seven districts have formed their own disparate, warring communities, each blessed by a tall obelisk atop a ziggurat they call their “spear,” which grants the residents additional abilities when lit. Each district also features a vault which can only be opened while the spear is lit. It is hoped that the treasures within these vaults will unlock the city''s secrets, as well as provide means for escape.'
  )
ON CONFLICT (session_log_id, paragraph_order) DO NOTHING;
-- End Session Spotlight Paragraphs

-- BEGIN SEED MAP ITEMS BLOCK
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
)
INSERT INTO items (
  campaign_id,
  item_type,
  item_subtype,
  sort_order,
  is_identified,
  item_name
)
VALUES
  ((SELECT campaign_id FROM c_id),
    'map',
    'area',
    1,
    TRUE,
    'Map of Smuggler''s Shiv'
  ),
  ((SELECT campaign_id FROM c_id),
    'map',
    'city',
    2,
    TRUE,
    'Map of Eleder'
  ),
  ((SELECT campaign_id FROM c_id),
    'map',
    'area',
    3,
    TRUE,
    'Map of Saventh-Yhi'
  ),
  ((SELECT campaign_id FROM c_id),
    'map',
    'region',
    4,
    TRUE,
    'Map of the Mwangi Expanse'
  ),
  ((SELECT campaign_id FROM c_id),
    'map',
    'region',
    5,
    TRUE,
    'Map of Sargava'
  ),
  ((SELECT campaign_id FROM c_id),
    'map',
    'area',
    6,
    TRUE,
    'Map of Tazion Ruins'
  )
ON CONFLICT DO NOTHING;
-- END SEED MAP ITEMS BLOCK

-- BEGIN SEED MAP GALLERY BLOCK
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
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
  ((SELECT item_id FROM i_id
      WHERE item_name = 'Map of Smuggler''s Shiv'),
    '/images/map/map-smugglers-shiv-big.webp',
    'Map of Smuggler''s Shiv',
    TRUE,
    TRUE
  ),
  ((SELECT item_id FROM i_id
      WHERE item_name = 'Map of Eleder'),
    '/images/map/map-eleder.webp',
    'Map of Eleder',
    TRUE,
    TRUE
  ),
  ((SELECT item_id FROM i_id
      WHERE item_name = 'Map of Saventh-Yhi'),
    '/images/map/map-saventh-yhi-big.webp',
    'Map of Saventh-Yhi',
    TRUE,
    TRUE
  ),
  ((SELECT item_id FROM i_id
      WHERE item_name = 'Map of the Mwangi Expanse'),
    '/images/map/map-mwangi-redacted.webp',
    'Map of the Mwangi Expanse',
    TRUE,
    FALSE
  ),
  ((SELECT item_id FROM i_id
      WHERE item_name = 'Map of Sargava'),
    '/images/map/map-sargava.webp',
    'Map of Sargava',
    TRUE,
    FALSE
  ),
  ((SELECT item_id FROM i_id
      WHERE item_name = 'Map of Tazion Ruins'),
    '/images/map/map-ruins-tazion.webp',
    'Map of Tazion Ruins',
    TRUE,
    FALSE
  )
ON CONFLICT DO NOTHING;
-- END SEED MAP GALLERY BLOCK
-- END maps.ejs SEED BLOCK

-- START npcs.ejs SEED BLOCK (idempotent)
-- BEGIN NPC Main Seed
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
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
  ((SELECT campaign_id FROM c_id),
    2,
    2,
    'Amivor Glaur',
    TRUE,
    NULL,
    FALSE,
    NULL,
    TRUE,
    FALSE
  ),
    ((SELECT campaign_id FROM c_id),
    2,                -- active_status_id (unfriendly → active)
    2,                -- race_id (human)
    'Dargan Etters',  -- npc_name
    TRUE,
    NULL,
    FALSE,
    NULL,
    TRUE,             -- is_gendered
    FALSE             -- is_female
  ),
    ((SELECT campaign_id FROM c_id),
    2,  -- active_status_id
    (SELECT id FROM race 
      WHERE LOWER(race_name) = 'elf'),
    'Chivañe',
    TRUE,
    NULL,
    FALSE,
    NULL,
    TRUE,
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    2,
    'Kassata Lewynn',
    TRUE,
    NULL,
    FALSE,
    NULL,
    TRUE,
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    2,
    'Ortho Vibius',
    TRUE,
    NULL,
    FALSE,
    NULL,
    TRUE,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    2,
    'Rotilius Havelar',
    TRUE,
    NULL,
    FALSE,
    NULL,
    TRUE,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    2,
    'Athyra "of the Jungle" Crinhouse',
    TRUE,
    'Fanged Raptor',
    TRUE,
    NULL,
    TRUE,
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    (SELECT id FROM race 
      WHERE LOWER(race_name) = 'half-elf'),
    'Aerys Mavato',
    TRUE,
    'Poetic Raven',
    FALSE,
    NULL,
    TRUE,
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    (SELECT id FROM race 
      WHERE LOWER(race_name) = 'dwarf'),
    'Cheiton Taralu',
    TRUE,
    'Stone Badger',
    TRUE,
    '#ada578',
    TRUE,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    (SELECT id FROM race
      WHERE LOWER(race_name) = 'gnome'),
    'Gelik Aberwhinge',
    TRUE,
    'Cerulean Lynx',
    TRUE,
    '#007BA7',
    TRUE,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    2,
    'Ishirou',
    TRUE,
    'Onyx Gibbon',
    TRUE,
    '#353839',
    TRUE,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    2,
    'Jask Derindi',
    TRUE,
    'Garnet Jackal',
    TRUE,
    '#733635',
    TRUE,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    2,
    'Mindra Macini',
    TRUE,
    'Cream Bison',
    FALSE,
    '#FFFDD0',
    TRUE,
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    2,
    'Nkechi "The Tempest"',
    TRUE,
    'Cranky Crab',
    TRUE,
    'crimson',
    TRUE,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    (SELECT id FROM race 
      WHERE LOWER(race_name) = 'tengu'),
    'Pezock "Crow Tooth"',
    TRUE,
    'Olive Scorpion',
    TRUE,
    '#808000',
    TRUE,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    2,
    'Sasha Nevah',
    TRUE,
    'Emerald Mantis',
    FALSE,
    '#50C878',
    TRUE,
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    (SELECT id FROM active_status 
      WHERE active_status_name = 'Retired'),
    1,
    'Aycenia - The Spirit of the Hill',
    TRUE,
    NULL,
    FALSE,
    NULL,
    TRUE,
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    (SELECT id FROM active_status 
      WHERE active_status_name = 'Retired'),
    1,
    'Ekubus',
    TRUE,
    NULL,
    FALSE,
    NULL,
    TRUE,
    FALSE
  )
ON CONFLICT (campaign_id, npc_name) DO NOTHING;
-- End NPC Main Seed

-- Start NPC Dead Status Seed
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
),
as_id AS (
  SELECT id AS status_id
  FROM active_status
  WHERE active_status_name = 'Deceased'
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
  is_female,
  death_cause,
  end_session
)
VALUES
  ((SELECT campaign_id FROM c_id),
    (SELECT status_id FROM as_id),
    1,
    'Ieana',
    TRUE,
    NULL,
    FALSE,
    NULL,
    TRUE,
    TRUE,
    'Was killed and replaced by Yarzoth before she boarded the Jenivere.',
    0
  ),
   ((SELECT campaign_id FROM c_id),
    (SELECT status_id FROM as_id),
    1,
    'Rambar Terillo',
    TRUE,
    NULL,
    FALSE,
    NULL,
    TRUE,
    TRUE,
    'Killed by a snake bite aboard the Jenivere.',
    0
  ),
  ((SELECT campaign_id FROM c_id),
    (SELECT status_id FROM as_id),
    1,
    'Alton Devers',
    TRUE,
    NULL,
    FALSE,
    NULL,
    TRUE,
    TRUE,
    'Succumbed to his mysterious injuries and finally to eurypterid poison.',
    1
  ),
  ((SELECT campaign_id FROM c_id),
    (SELECT status_id FROM as_id),
    1,
    'Alizandru Kovack',
    TRUE,
    NULL,
    FALSE,
    NULL,
    TRUE,
    TRUE,
    'Turned into an undead Lacedon by the Mother, and finally put out of his misery by the explorers.',
    4
  ),
  ((SELECT campaign_id FROM c_id),
    (SELECT status_id FROM as_id),
    1,
    'Klorak "the Red"',
    TRUE,
    NULL,
    FALSE,
    NULL,
    TRUE,
    FALSE,
    'Stabbed in the eyes by Loric''s thrown trident.',
    9
  ),
  ((SELECT campaign_id FROM c_id),
    (SELECT status_id FROM as_id),
    1,
    'Yarzoth',
    TRUE,
    NULL,
    FALSE,
    NULL,
    TRUE,
    FALSE,
    'Decapitated by Avarice, her severed head muttered, "Cut off one head, two more shall take its place..."',
    10
  ),
  ((SELECT campaign_id FROM c_id),
    (SELECT status_id FROM as_id),
    2,
    'Umagro',
    TRUE,
    NULL,
    FALSE,
    NULL,
    TRUE,
    FALSE,
    'Martyr''d by Dakota atop the flensing house roof of the South Arcadian Whaling Company, in front of a riotous crowd.',
    12
  ),
  ((SELECT campaign_id FROM c_id),
    (SELECT status_id FROM as_id),
    2,
    'Neiford "The Arrow" Sharrowsmith',
    TRUE,
    'Cartographer Walrus',
    TRUE,
    NULL,
    TRUE,
    FALSE,
    'Killed by failing to activate a wand of goodberry, causing him to wither and die.',
    33
  )
ON CONFLICT (campaign_id, npc_name) DO NOTHING;
-- End NPC Dead Status Seed

-- Start NPC Titles Seed
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
)
INSERT INTO npc_titles (
  npc_id,
  title_id
)
VALUES 
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Amivor Glaur'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM titles
      WHERE LOWER(title_name) = 'venture-captain')
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Dargan Etters'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM titles
      WHERE LOWER(title_name) = 'patron')
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Chivañe'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM titles
      WHERE LOWER(title_name) = 'red mantis mistress')
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Kassata Lewynn'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM titles 
      WHERE LOWER(title_name) = 'captain')
  ),
  ((SELECT id FROM npc_main 
      WHERE npc_name = 'Ortho Vibius'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM titles 
      WHERE LOWER(title_name) = 'earl')
  ),
  ((SELECT id FROM npc_main 
      WHERE npc_name = 'Rotilius Havelar'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM titles 
      WHERE LOWER(title_name) = 'general')
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Cheiton Taralu'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM titles
      WHERE LOWER(title_name) = 'skipper')
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Mindra Macini'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM titles
      WHERE LOWER(title_name) = 'lord')
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Ekubus'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM titles
      WHERE LOWER(title_name) = 'captain')
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Alizandru Kovack'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM titles
      WHERE LOWER(title_name) = 'captain')
  ),
    ((SELECT id FROM npc_main
      WHERE npc_name = 'Alton Devers'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM titles
      WHERE LOWER(title_name) = 'first mate')
  ),
    ((SELECT id FROM npc_main
      WHERE npc_name = 'Rambar Terillo'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM titles
      WHERE LOWER(title_name) = 'cook')
  ),
    ((SELECT id FROM npc_main
      WHERE npc_name = 'Klorak "the Red"'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM titles
      WHERE LOWER(title_name) = 'chief')
  )
ON CONFLICT (npc_id, title_id, title_location) DO NOTHING;
-- End NPC Titles Seed

-- Start NPC Attitude Seed
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
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
  ((SELECT id FROM npc_main
    WHERE npc_name = 'Amivor Glaur'
    AND campaign_id = (SELECT campaign_id FROM c_id)),
  2,
  NULL,
  NULL,
  'Amivor shares some of his skill with disabling traps; Everyone gains the ability to make a thrilling	escape, once per day; pathfinder delvers may instead use their thrilling escape ability one additional time per day.
<br>&ensp;Thrilling escape: When you trigger a trap via a failed disable device check, you may attempt a disable device check against its normal DC as an immediate action; if you succeed, the trap is not triggered until the end of your turn.',
  'Amivor will vouch for the explorers, unlocking the Pathfinder Delver prestige class.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Dargan Etters'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    2,   -- Unfriendly
    NULL,
    NULL,
    'Patron Etters pays well for loyalty. He gifts them an [item that can cast <i>detect secret doors</i> once per day].',
    'Patron Etters concede''s to providing a letter of introduction for the Aspis consortium, unlocking the Aspis Agent prestige class.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Chivañe'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    2,
    NULL,
    NULL,
    'She personally educates the players in the fighting stances of the Red Mantis Assassins, granting weapon focus (sawtooth sabre) as a bonus feat (or weapon specialization (sawtooth sabre) if they already have an applicable weapon focus). Characters that already have both of these feats may immediately refund one of these spent feats.',
    'Recognizing your talents, she is willing to induct the explorers, unlocking the Red Mantis Assassin prestige class.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Kassata Lewynn'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    2,
    NULL,
    NULL,
    'Kassata Lewynn offers some dueling instruction, teaching everyone the Classic Duelist pirate trick: You gain a +1 competence bonus on attack rolls made with a cutlass, rapier, or short sword.',
    'She sponsors them in becoming free captains (once they have a ship). This unlocks the Deep Sea Pirate prestige class.'
  ),
  ((SELECT id FROM npc_main 
      WHERE npc_name = 'Ortho Vibius'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    4,
    NULL,
    NULL,
    'Ortho Vibius studied the bold fighting style of Grand Prince Cyricas, and teaches everyone how to emulate his intrepid tread through jungles and other dangerous lands. Everyone gains Brash Stride as a bonus feat.',
    'The players gain Lion Blade Association for the Lion Blade class.'
  ),
  ((SELECT id FROM npc_main 
      WHERE npc_name = 'Rotilius Havelar'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    4,
    NULL,
    NULL,
    'The general is an excellent teacher, and can grant skill focus as a bonus feat in a skill of choice chosen from the following list: Intimidate, Knowledge (dungeoneering, engineering, or nobility), Ride, or Sense Motive.',
    'He pledges to speak on their behalf before the Sargavan government, so that when the adventure is over, they might become nobility and receive land grants in Saventh-Yhi.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Athyra "of the Jungle" Crinhouse'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    5,
    NULL,
    NULL,
    'She teaches everyone her naked-courage technique. Naked courage grants a +1 dodge bonus and a +1 morale bonus on saving throws versus fear effects to anyone not wearing armor.',
    'Athyra can rally velociraptors to her, allowing them to be selected as animal companions.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Aerys Mavato'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3,
    NULL,
    NULL,
    'She allows the PCs to read her unfinished epic — the Abendego Cantos. Anyone who reads it gains a +1 bonus on Will saving throws against compulsion effects.',
    NULL
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Cheiton Taralu'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    5,
    NULL,
    NULL,
    NULL,
    NULL
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Gelik Aberwhinge'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    5,
    NULL,
    NULL,
    'Gelik shares several secrets of comedy. Everyone gains a +1 Caster Level bonus when casting spells with the charm or language-dependent descriptors.',
    NULL
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Ishirou'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    5,
    NULL,
    NULL,
    'Ishirou shares some of his sword-fighting styles and tricks, granting everyone a +1 bonus to CMB and CMD against disarm combat maneuvers.',
    NULL
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Jask Derindi'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    5,
    NULL,
    NULL,
    'Jask shares a number of mantras and focusing chants. Everyone gains Meditation Master as a bonus feat.',
    NULL
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Mindra Macini'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    4,
    NULL,
    NULL,
    NULL,
    NULL
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Nkechi "The Tempest"'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    5,
    NULL,
    NULL,
    'The Tempest can create powerful drugs that enable the adventurers to go on spirit journeys.',
    'The Tempest can perform the spirit dance ritual, unlocking advanced powers for totemic spirits.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Pezock "Crow Tooth"'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    5,
    NULL,
    NULL,
    NULL,
    'Cured of his madness, Pezock shares some of his combat tactics. He grants everyone Exotic Weapon Proficiency (Sawtooth Saber), and anyone dealing sneak attack damage with a sawtooth saber may gain the benefit of the Bleeding Attack rogue talent.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Sasha Nevah'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    4,
    NULL,
    NULL,
    'Especially skilled at graceful movements, anyone who studies under Sasha gains a permanent +1 bonus on Initiative checks.',
    NULL
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Aycenia - The Spirit of the Hill'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    5,
    NULL,
    NULL,
    NULL,
    'Aycenia allows the PCs to rest on her hill as often as they wish, pledges to use her magic to aid them in whatever method they desire, and can answer most specific questions about the island and its inhabitants.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Ekubus'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    5,
    NULL,
    NULL,
    'Captain Ekubus is happy to escort the castaways to and through the vampiric temple, though he cannot leave his crew for more than an hour at a time.',
    NULL
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Ieana'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3,
    NULL,
    NULL,
    NULL,
    NULL
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Rambar Terillo'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3,
    NULL,
    NULL,
    NULL,
    NULL
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Alton Devers'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3,
    NULL,
    NULL,
    NULL,
    NULL
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Alizandru Kovack'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3,
    NULL,
    NULL,
    NULL,
    NULL
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Klorak "the Red"'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    2,
    NULL,
    NULL,
    NULL,
    NULL
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Yarzoth'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    2,
    NULL,
    NULL,
    NULL,
    NULL
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Umagro'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    2,
    NULL,
    NULL,
    NULL,
    NULL
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Neiford "The Arrow" Sharrowsmith'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    5,
    NULL,
    NULL,
    'Once per day, Sharrowsmith can gift an explorer with a single scroll containing any 3rd level or lower bard spell for free. These scrolls are custom-made and cannot be sold, and the recipient gains a +5 circumstance bonus on Use Magic Device checks to activate the scroll. Sharrowsmith can only make 5 spell-levels worth of scrolls per week, and will not give a new scroll if the recipient already has 5 of his scrolls.',
    NULL
  )
ON CONFLICT (npc_id) DO NOTHING;
-- End NPC Attitude Seed.

-- Start NPC Social Seed
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
)
INSERT INTO npc_social (
  npc_id,
  appearance,
  background
)
VALUES 
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Amivor Glaur'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'A wild-haired redhead with a neatly trimmed beard and mustache. Amivor keeps himself conspicuously clean. Eschewing a shirt for an open vest with many pockets, he is covered in easily accessed tools, and every piece of his clothing has utility.',
    'A veteran of several expeditions into the Mwangi interior. Skilled at organizing and leading missions, appraising sites, and exploring ruins. Hardened and made more wild by jungle life, he prefers the field to civilization.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Dargan Etters'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Well adapted to the hot climate of the expanse, Patron Etters wears loose fitting and unrestricted clothing decorated in gold. He rarely ventures anywhere without his bodyguards, but his demeanor makes it clear that in any conversation, he is always the most important, powerful, and dangerous man in the room.',
    'A charismatic businessman, Patron Etters is solely interested in his own wealth and prestige. Based out of Blood Cove, he rose to upper echelons of a society built on subterfuge and skullduggery. Arrogant and utterly ruthless, he has a reputation for maximizing profits at the expense of lives; having no qualms about killing people in his way, either to lessen competition or to get what he wants.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Chivañe'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Startlingly beautiful, Chivañe takes the rare approach of removing her mask of the red mantis, allowing her to be recognized. This is likely due to the reality of leading an expedition of several assassins, rather than merely being on a job, but this decision enables the expedition leader to be recognized on sight at a distance.',
    '[REDACTED]'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Kassata Lewynn'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Strikingly pretty with long, curly red hair and delicate tattoos in both prominent and delicate places, Captain Kassata wields her looks like any other weapon. Jovial, prone to heavy drinking and wild partying, Kassata lives a one-life-one-shot mantra, never letting an opportunity for fun or adventure pass idly by.',
    'Captain of the <i>Last Hurrah</i>, Kassata Lewynn is an ambitious Free Captain of the Shackles. She craves authority and the admiration of her fellow captains, something she somewhat-rightfully believes can only be bought, and she will pursue fortune and glory with every drop of her blood.'
  ),
  ((SELECT id FROM npc_main 
      WHERE npc_name = 'Ortho Vibius'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Middle aged and mildly foppish, His Honorable Lordship Vibius is a confirmed old bachelor possessing both wealth and station. At all times, he is dressed impeccably and acts with decorum, though he imperiously eyes the jungle with a combination of fright and disgust. His nobility has afforded him a fantastic and diverse education at colleges across Avistan, yet he retains an insatiable curiosity for the unknown, often asking pointed questions after concluding with pleasantries.',
    'The largest benefactor to the G.C.S., Earl Vibius typically pays them enough money to operate for a year in exchange for brief explorations of the Stasis Fields in the Bandu Hills, though he does not seem to do anything with the reports that return to him. Not a field man, he is funding the expedition entirely out of his own pocket, purely for the pursuit of knowledge.'
  ),
  ((SELECT id FROM npc_main 
      WHERE npc_name = 'Rotilius Havelar'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'An older man with a lifetime of military service, General Havelar keeps his grey hair and beard cropped short and neatly trimmed. His face is wrinkled and lined from decades of scowling, with a prominent scar across the left side of his face from a nearly-fatal encounter with an elephant''s tusk.',
    'Appointed to lead the expedition to Saventh-Yhi by Grand Custodian Utilinus, Rotilius Havelar is a general of the Sargavan Guard. A loyal supporter of the Grand Custodian, General Havelar is a stereotypical self-important colonial officer, with traditionalist views of the Mwangi natives. A military man through and through, he is a veteran of several battles, highly educated, a skilled warrior and strategist, and a man who can be counted on to follow orders. Despite his qualities, however, he lacks any true leadership ability.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Athyra "of the Jungle" Crinhouse'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Athyra stands nearly 6 feet tall with a perfectly muscled figure and stunning features, her hair woven into clumped tangles. Dressed in wild scraps of animal hide, she carries a glaive-like spear she crafted from the toothed jaw of some fearsome jungle beast.',
    'The sole survivor (and heir) of the disaster at the Fzumi Salt Mines, Athyra was raised by velociraptors in the <i>Screaming Jungle</i>, and is always seen alongside her best friend and clutch-mate, Jaji.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Aerys Mavato'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Aerys is a trim, athletic woman with short dark hair, tanned skin, and fierce blue eyes. She dresses in tightly fitted leather armor and favors dark clothing and tricorn hats.',
    'Aerys Mavato boarded the <i>Jenivere</i> at Port Peril, and immediately got in a fight with one of the ship''s crewmen when he made an ill-advised suggestion that he and Aerys could share bunks. Aerys soundly humiliated the crewman in the resulting scrap, preventing further trouble during the rest of the voyage but sending the brooding half-elf into a self-imposed isolation in her forward cabin where she spent much of her time half-drunk or passed out, filling the gaps between bouts of work on her secret passion — poetry. She has been crafting an epic poem she calls the Abendego Cantos for many years, and worries that she''ll not be able to finish it before she gets herself killed.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Cheiton Taralu'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Cheiton is a brawny dwarf, easily recognizable by the tattoo on his shoulder belonging to a specific mining outfit within the G.C.S. A jovial drinker and fond storyteller, the Skipper is particularly fond of puns, and its endless usage is something passengers aboard his steamer sometimes find exhaust-ing.',
    'A former miner in the Bandu Hills, Cheiton earned a modest living working for the G.C.S. Now, he makes his living organizing expeditions into the Mwangi interior for the foolhardy, and occasionally he enjoys taking up contracts from his former bosses at the G.C.S.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Gelik Aberwhinge'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Gelik is a spry, energetic gnome with blond hair and a neat goatee. He dresses like a noble at all times. With liberal use of <i>prestidigitation</i>, his fine clothes always seem freshly cleaned. Only the ink stains on his fingers break the illusion of a proper gnome nobleman.',
    'Gelik boarded the <i>Jenivere</i> at Magnimar in something of a rush — when a local merchant discovered that Gelik had sold him a fake Thassilonian relic, things quickly got out of hand and the Magnimar city guard became involved. After losing his pursuers in a market, Gelik found himself at the docks and secured passage on the first ship out of town he could — the <i>Jenivere</i>.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Ishirou'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Ishirou is a rugged Tian man who appears much older than he is, with graying hair worn in a ponytail and a perpetual scruffy beard. His clothing and armor are well kept and clean, but obviously of low quality. Only his sword, a beautiful katana, has any real value, and he is rightfully protective of it as his only material link to his cultural heritage.',
    'Ishirou grew up on his father''s ship, but grew to resent what he felt was a stolen childhood. In a foolish attempt to force his family to settle down, young Ishirou lit his father''s ship on fire, only to watch in horror as his father died trying to save it. Ishirou fled aboard an Aspis Consortium ship bound for Bloodcove, where he worked for ten years before boarding the <i>Jenivere</i> to seek a new life.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Jask Derindi'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Jask is a middle-aged, plain-looking Garundi man with hair starting to gray and watery eyes.',
    'A prisoner loaded at Corentyn, Jask was once employed by the Sargavan government. After uncovering evidence of corruption, he was betrayed and framed for the same crimes. He fled to Corentyn and lived as a scribe for a decade before being captured and placed aboard the <i>Jenivere</i> for return to Sargava — only for the shipwreck to leave him alive but bound.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Mindra Macini'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Unassuming and fair, Mindra wears long knit clothes and large bucket hats to keep the sun off her skin, never removing her thick layers even when working under the hot sun. Despite this, she has never been seen sweating or complaining about the heat, and those who assume she is frail have never seen her wrestle a bull into its pen.',
    'A Vidric native, Mindra was born and raised in Freehold after the traditions of her noble family. A champion of Mwangi rights, her large ranch is the halfway point between Eleder and Kalabuto. More than a hard worker and leader, she is a cunning politician who defends the heartlands with her well-armed shepherds and ranch-hands.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Nkechi "The Tempest"'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'The Tempest eschews wearing shirts, and his single pair of trousers is heavily worn and patched. His hair, beard, and eyebrows are permanently storm-strewn and losing color at the ends, and he is blind in his left eye. Despite this, he bears a fine holy symbol of his patron and always wears sturdy shoes.',
    'An aged shaman of Shimye-Magalla, Nkechi is called "The Tempest" by the Vidric natives of Eleder. Knowledgeable and wise but temperamental, he is prone to fits of rage and seeming madness. Hundreds have sought his counsel, earning him both followers and enemies. After surviving several attempts on his life, he has developed a healthy sense of paranoid vigilance.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Pezock "Crow Tooth"'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'This mad black tengu has seen too many days marooned on <i>Smuggler''s Shiv</i>, and the combination of heat and isolation has taken its toll. He wears ragged pants and strips of white cloth bandaged around his head, forearms, and tarses to keep cool while covering bites, cuts, and caught hooks.',
    'Pezock is the only survivor of the wreckage of the <i>Crow''s Tooth</i>. He was a passenger aboard the all-tengu vessel and close friend of Captain Eraka Zoventai, who gave Pezock his saw-toothed saber. All other survivors were killed by the Shiv''s cannibals.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Sasha Nevah'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Sasha has tousled red hair and mischievous green eyes, and is missing the pinky finger of her left hand. She bears a tattoo between her shoulder blades. Slender and athletic, Sasha never stands still or stays quiet for long.',
    'Sasha Nevah is a daughter of the Red Mantis. While she shows great promise as a fighter, her curiosity, rebellious streak, and love of animals make her unsuitable as an assassin. Her mother, a high-ranking Mantis, sent her to Sargava to assist with Mantis interests — a mission that is not technically exile, though Sasha understands the threat behind it. Rather than dwell on the danger, she sees it as a great opportunity for adventure.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Aycenia - The Spirit of the Hill'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'The dryad of the single, 60-ft banyan tree atop <i>Smuggler''s Shiv</i>, Aycenia has light-bark skin, rain-water eyes, and palm-frond hair. Her voice sounds like rustling leaves, and while she speaks eagerly, her language reflects someone who rarely has a companion for conversation.',
    'She is a tree. Her life is the life of the banyan that has stood on this hill for over a century. Young for a tree, yet older than most on the island, she pays little mind to the cannibals — she is a tree.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Ekubus'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'This small humanoid creature has thin, leathery wings, small horns, and a mischievous smile. Water drips constantly from his skin, rolling down his long ears and nose and leaving wet footprints wherever he walks.',
    'Ekubus is the sole survivor of the <i>Salty Strumpet</i>. Once the familiar of its captain, he took up the mantle of command after the shipwreck and now lives in the sunken vessel, wearing his master''s jaunty cap and giving orders to his crew of crabs, urchins, and fish.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Ieana'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Mysterious and scantily clad, Ieana uses scarves to both hide and highlight her features. Her charms and bracelets move asynchronously with her motions, giving her an odd combination of grace and awkwardness, as though she does not quite fit in her slender frame.',
    'A bookish Varisian scholar traveling to Sargava to explore ancient ruins. Rumors aboard the Jenivere suggest she might be the ship''s owner, a Chelish agent, or Captain Kovack''s secret lover. Ieana keeps mostly to herself and grows more intent on her studies as the ship nears Eleder.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Rambar Terillo'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Rail thin and incredibly jumpy, Ship''s Cook Terillo is most memorable for his shrill screams at the sight of bugs. Meticulously clean, he keeps his blond hair cropped short and his beard and thin mustache precisely trimmed.',
    'A taciturn man from Senghor, Ship''s Cook Terillo has served aboard several ships, though apparently not for his culinary skill, which seems limited to watery soups.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Alton Devers'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'A youthful but weathered man, First Mate Devers has an easygoing attitude paired with an impeccable sense of honor and duty, which he strives to impart to the crew.',
    'The Jenivere''s first mate is friendly with both passengers and crew, though he sometimes seems to chafe under Captain Kovack''s strict discipline.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Alizandru Kovack'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Smartly but practically dressed, Captain Kovack has a precisely trimmed beard and mustache, a crisp tricorn hat he wears above deck, and a particularly piercing gaze.',
    'A Chelish man whose family has made the Magnimar-Eleder run for generations, Captain Kovack is pleasant with passengers but a strict disciplinarian with his crew.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Klorak "the Red"'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Known as "the Red" for his vibrant hair and his glorying in blood, Klorak stands 7''2" with a muscular frame. He wears a necklace of teeth from those he has torn apart, and his chest bears a crude tattoo of a boiling cook-pot shaped like a skull.',
    'Klorak the Red is the seventh chieftain of the Thrunefangs, known for his bloodlust and his magically preserved scimitar. Despite his long rule, he has failed to sire an un-deformed child for years, leading the tribe to question his worthiness. He spends much of his time secluded, undergoing dubious herbal and alchemical “cures” from the tribe''s witch doctor.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Yarzoth'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Her slender frame and awkward grace are no longer incongruous now that her illusion has dropped. With two legs, clawed hands, and the head of a snake, she looks as treacherous as she behaves.',
    'Little is known of this serpentfolk''s past. She killed and replaced Ieana, enthralled Captain Kovack, poisoned the crew, and wrecked the Jenivere to reach an ancient Zura temple. There she pieced together a map to Saventh-Yhi.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Umagro'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Umagro wears a dark cloak and paints his face in tribal warrior patterns. His armor and weapons are new but styled after ancient Mwangi empires.',
    'Captured by slavers as a child, Umagro spent years in salt mines before being sold into a Chelish slave army. After escaping during a Mzali siege, he joined the Freeman''s Brotherhood and eventually turned it into a violent revolutionary movement.'
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Neiford "The Arrow" Sharrowsmith'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Once moderately attractive, Sharrowsmith now suffers from horrific swelling and painful growths across his body. His condition causes constant pain and involuntary muscle strain, leading to unpredictable mood swings.',
    'An acclaimed scout and explorer, Sharrowsmith left college to join a G.C.S. mapping team. Gifted at woodcraft and knowledgeable from partial academic training, he became known for leading dangerous expeditions—often alone when secrecy or speed was required.'
  )
ON CONFLICT (npc_id) DO NOTHING;
-- END NPC Social Seed

-- Start NPC Gallery Seed
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
)
INSERT INTO npc_gallery (
  npc_id,
  image_url,
  alt,
  is_main,
  is_hover,
  show_hover,
  is_tall
)
VALUES 
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Amivor Glaur'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/icon/icon-amivor-glaur.webp',
    'Faction Leader Iconic Profile',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Dargan Etters'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/icon/icon-dargan-etters.webp',
    'Faction Leader Iconic Profile',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Chivañe'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/icon/icon-chivane.webp',
    'Faction Leader Iconic Profile',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Kassata Lewynn'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/icon/icon-kassata-lewynn.webp',
    'Faction Leader Iconic Profile',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main 
      WHERE npc_name = 'Ortho Vibius'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/icon/icon-ortho-vibius.webp',
    'Faction Leader Iconic Profile',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main 
      WHERE npc_name = 'Rotilius Havelar'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-rotilius-havelar.webp',
    'Faction Leader Regular Profile',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Athyra "of the Jungle" Crinhouse'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-athyra.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Athyra "of the Jungle" Crinhouse'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-fanged-raptor.webp',
    'Spirit Totem',
    FALSE,
    TRUE,
    TRUE,
    FALSE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Aerys Mavato'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-aerys-mavato.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Aerys Mavato'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-poetic-raven.webp',
    'Spirit Totem',
    FALSE,
    TRUE,
    FALSE,
    FALSE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Cheiton Taralu'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-cheiton.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Cheiton Taralu'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-stone-badger.webp',
    'Spirit Totem',
    FALSE,
    TRUE,
    TRUE,
    FALSE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Gelik Aberwhinge'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-gelik-aberwhinge.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Gelik Aberwhinge'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-cerulean-lynx.webp',
    'Spirit Totem',
    FALSE,
    TRUE,
    TRUE,
    FALSE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Ishirou'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-ishirou.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Ishirou'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-onyx-gibbon.webp',
    'Spirit Totem',
    FALSE,
    TRUE,
    TRUE,
    FALSE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Jask Derindi'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-jask-derindi.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Jask Derindi'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-garnet-jackal.webp',
    'Spirit Totem',
    FALSE,
    TRUE,
    TRUE,
    FALSE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Mindra Macini'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-mindra-macini.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Mindra Macini'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-cream-bison.webp',
    'Spirit Totem',
    FALSE,
    TRUE,
    FALSE,
    FALSE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Nkechi "The Tempest"'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-nkechi.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Nkechi "The Tempest"'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-giant-crab.webp',
    'Spirit Totem',
    FALSE,
    TRUE,
    TRUE,
    FALSE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Pezock "Crow Tooth"'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-pezock.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Pezock "Crow Tooth"'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-olive-scorpion.webp',
    'Spirit Totem',
    FALSE,
    TRUE,
    TRUE,
    FALSE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Sasha Nevah'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-sasha-nevah.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Sasha Nevah'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-emerald-mantis.webp',
    'Spirit Totem',
    FALSE,
    TRUE,
    FALSE,
    FALSE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Aycenia - The Spirit of the Hill'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-aycenia.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Ekubus'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-ekubus.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Ieana'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-ieana.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Rambar Terillo'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-rambar-terillo.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Alton Devers'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-alton-devers.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Alizandru Kovack'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-alizandru-kovack.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Klorak "the Red"'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-klorak-the-red.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Yarzoth'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-yarzoth.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Umagro'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-umagro.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Neiford "The Arrow" Sharrowsmith'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/npc-neiford-sharrowsmith.webp',
    'NPC Profile Img',
    TRUE,
    FALSE,
    FALSE,
    TRUE
  ),
  ((SELECT id FROM npc_main
      WHERE npc_name = 'Neiford "The Arrow" Sharrowsmith'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem-walrus.webp',
    'Spirit Totem',
    FALSE,
    TRUE,
    TRUE,
    FALSE
  )
ON CONFLICT DO NOTHING;
-- END NPC Gallery Seed

-- Start Faction Main Seed
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
)
INSERT INTO factions (
  campaign_id,
  active_status_id,
  faction_name,
  is_identified,
  secret_name,
  show_secret_name,
  faction_type,
  description,
  secrets,
  pinned
)
VALUES
  ((SELECT campaign_id FROM c_id),
    2,
    'Gold Crown Shipping and Mining Company (G.C.S.)',
    TRUE,
    'Front for the Lion Blades',
    TRUE,
    'Major Faction',
    'Although primarily known for hauling cargo between Port Freedom and Eleder, the G.C.S. originally made its profits from mining operations in the Bandu Hills. They ship everything valuable, from pineapples to gold, on their swift, well-armed barges and armored wagon trains. They also outfit expeditions into the Mwangi interior, and while many turn back with losses, their dangerous missions bring in real money and never lack volunteers.',
    'Ortho Vibius is a member of the Kith, a network of Lion Blades affiliates. The Lion Blades have a controlling interest in G.C.S., using the Earl to launder money and fund scouting and intelligence missions.',
    TRUE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Charau-Ka',
    TRUE,
    NULL,
    FALSE,
    'Major Faction',
    'The feral charau-ka are the legendary ape-men of the Mwangi jungles. Savage and remorseless hunters, they are feared and hated by virtually every civilization that encounters them. They build no cities, have no concept of trade, and make war on all they meet. Most serve the Gorilla King and Angazhan, and even those tribes not under Usaro''s sway are considered monstrous.',
    NULL,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Ivory Cross',
    TRUE,
    'Front for the Aspis Consortium',
    TRUE,
    'Major Faction',
    'Sargava''s most organized guild, the Ivory Cross, began operations in Eleder only 30 years ago, but has quickly established itself as a force to be reckoned with. Nearly a hundred mercenary soldiers and officers operate under its badge, maintaining a visible presence in Eleder. Though they escort expeditions into the Bandu Hills, they are not treasure hunters—they seek to maintain security and order. Rumors suggest they use violence and coercion to force cooperation from ranches and Mwangi tribesmen who refuse favorable terms.',
    'The Ivory Cross is a front for the Aspis Consortium, allowing the consortium to profit within Sargava through mercenary contracts despite sanctions. This secret is closely guarded, and the Ivory Cross is too powerful for most to oppose.',
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Pathfinder Society',
    TRUE,
    NULL,
    FALSE,
    'Major Faction',
    'A loose-knit group of explorers, archeologists, and adventurers, the Pathfinder Society searches the globe for lost knowledge and ancient treasures. Some Pathfinders seek to unlock history''s secrets, others chase fame and fortune, and still others pursue the thrill of perilous adventure.',
    'Venture-Captain Finze Bellaugh believes Saventh-Yhi may hold the key to locating other ancient cities and relics. They suspect Old-Mage Jatembe may have visited the city after the Age of Darkness, and legendary Pathfinders have long failed to follow his footsteps. This is a chance to walk a path untouched for millennia.',
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Red Mantis',
    TRUE,
    NULL,
    FALSE,
    'Major Faction',
    'The Red Mantis are the most tenacious and efficient assassins in the world. They kill with sacred saw-toothed sabres, and no fortress or cavern is secure against them. Their prices vary wildly and are always nonnegotiable. They accept almost any job except regicide against a rightful monarch.',
    NULL,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Rivermen''s Guild',
    TRUE,
    NULL,
    FALSE,
    'Major Faction',
    'A coalition of barge sailors along the Korir River, the Rivermen''s Guild is open to anyone who makes their living on the waterways, though only barge owners may vote. Known as thugs, robbers, and thieves, they steal, sink, and hijack cargo from non-guild members—especially the G.C.S. Many join simply to avoid being targeted. Attempts to disband the guild have failed, as guards fear retaliation.',
    NULL,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Sargavan Custodial Government',
    TRUE,
    NULL,
    FALSE,
    'Major Faction',
    'Beset by devil-binding pilgrims, pirate debts, and resentment from the subjugated Mwangi peoples, Sargava remains a northern colonial enclave in the southern wilds. Financially weakened and cut off from northern allies, the colony faces rebellion inspired by the undead child-god of Mzali. The colonial minority maintains control, but the Mwangi know they have the Expanse at their backs, and the government is in no position to quell a revolt.',
    'Out of money, the Sargavan Custodial Government cannot afford further payments to the Hurricane King. This expedition may be their last chance, as they will default on their next payment. They also need funds to appease independence factions threatening civil war. Infrastructure is failing, the army is underpaid, and unrest is rising. Saventh-Yhi may be their last chance to stabilize the colony.',
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Bekyar Raiders',
    TRUE,
    NULL,
    FALSE,
    'Tribe',
    'Bekyar tend to be tall, with elaborate braided hairstyles often incorporating silk headwraps. Most hunt for game and raid other communities for food, resources, and people. What they do with their captives varies by tribe.',
    NULL,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Bonuwat Seafarers',
    TRUE,
    NULL,
    FALSE,
    'Tribe',
    'Bonuwat appear along coastlines, often shirtless or painted, with hair cropped short, in cornrows, or shaved for hydrodynamics. They have a strong seafaring heritage, forming communities wherever water and fish are plentiful.',
    NULL,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Chosen Caldaru',
    TRUE,
    NULL,
    FALSE,
    'Tribe',
    'With skin tones from olive to dark bronze, the Caldaru dress in long, flowing robes. Believing themselves a chosen people, many were enslaved or displaced when outsiders reached the Mwangi Expanse. Rather than assimilate, they absorbed outside knowledge while maintaining their identity, forming diaspora communities that trade and share expertise.',
    NULL,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Colonial Settlers',
    TRUE,
    NULL,
    FALSE,
    'Tribe',
    'Descended from Chelish colonists but born in Sargava, these people know only their homeland. While Inner Sea culture dominates, their lifestyle reflects local influences. Many speak Polyglot, and some incorporate Mwangi religious practices. Intermarriage, once scandalous, is now uncommon but accepted, and multi-toned children join their fair-skinned families in upper society.',
    NULL,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Mauxi Nomads',
    TRUE,
    NULL,
    FALSE,
    'Tribe',
    'The Mauxi wear head wraps to protect from the sun and favor colorful robes and textiles. They are typically peaceful nomads but ready to defend themselves. Their subgroups follow different herd animals across the expanse.',
    NULL,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Zenj Peoples',
    TRUE,
    NULL,
    FALSE,
    'Tribe',
    'The Zenj are divided between the matriarchal savannah-dwelling Zenje and the patriarchal jungle-dwelling Zenju. Despite differences, they see themselves as one people, trading, celebrating, and aiding each other. Legends say they split long ago over a dispute about hunting and diet.',
    NULL,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Brotherhood of Cheerful Service',
    TRUE,
    NULL,
    FALSE,
    'Sargavan',
    'A noble order of Mwangi elves and magical beasts, this dragon-led brotherhood safeguards impoverished villages from disease, famine, pestilence, and wild animals. Their well-intentioned aid often leads to misunderstandings, such as killing herds to “protect” villagers or replacing food stores with lizards believed to be more nutritious.',
    NULL,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Coils of Ydersius',
    TRUE,
    NULL,
    FALSE,
    'Sargavan',
    'Little is known of this secretive serpentfolk organization. Once thought extinct, serpentfolk have reappeared only recently. The group shares iconography with Ydersius, the long-dead serpentfolk god, and may believe they draw power from its severed skull.',
    NULL,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Freemen''s Brotherhood',
    TRUE,
    NULL,
    FALSE,
    'Sargavan',
    'A loose association of Mwangi natives led by ex-slaves, the Freemen''s Brotherhood is a radical abolitionist group. They seek to instill terror in foreigners and merchants they associate with the slave trade, sometimes viewing all colonials as “Imperialist Thieves.” Their lack of structure and quick anger make them prone to riots and violence.',
    NULL,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Order of the Coil',
    TRUE,
    NULL,
    FALSE,
    'Sargavan',
    'Originally part of the Hellknight Order of the Pyre, the Order of the Coil formed after a disastrous attempt to establish a headquarters in Sargava. Inspired by local vipers, the remaining Hellknights became zealously destructive, seeking to eradicate Mwangi cultures. Under Lictor Racnhe, they employ fire and poison to destroy settlements and historical sites, and attack archaeologists and explorers.',
    NULL,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Followers of the Sacred Serpent',
    TRUE,
    NULL,
    FALSE,
    'Saventh-Yhi',
    'An isolated tribe of Caldaru artisans who view sculpture as the highest form of art and worship. They preserve the ancient stonework of their district and revere the Radiant Muse, their spiritual guide, though they visit it only on holy days and always with tribute.',
    'The chief and some warriors have Taldan ancestors; survivors of a marble-skinned, blue-eyed, golden-haired band of soldiers once protected their tribe from Charau-Ka. Most returned to the jungle and vanished, but some remained, strengthening the tribe''s bloodline.',
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Toadies of the Green God',
    TRUE,
    NULL,
    FALSE,
    'Saventh-Yhi',
    'A tribe of boggards who control the flooded agricultural district. Their spiritual guide has vanished, leaving them unable to perform rituals or maintain protective wards. Desperate and fearful, they have become both pliable and dangerous.',
    NULL,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Vegepygmies of the Russet Mold',
    TRUE,
    NULL,
    FALSE,
    'Saventh-Yhi',
    'A large tribe of vegepygmies inhabiting the dreaming jungle of the former residential district. They revere the immense colony of russet mold growing on the district''s ziggurat as holy. Reasoning with mold-born creatures is difficult, though they may view humanoids similarly.',
    NULL,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Boarded in Cheliax',
    TRUE,
    'Carmine Hyena',
    TRUE,
    'Spirit Totem',
    'While you aren''t necessarily a native of Cheliax, you boarded the Jenivere at one of that country''s port cities. As the people of Cheliax generally know the Mwangi Expanse as a near legendary land home to strange beasts and exotic treasures, your views of the region have a distinctly romantic tinge, and the desire for fame, wealth, and adventure likely motivate your travels.',
    'b>Legendary Power:</b> You deal +1d6 extra points of damage on your first attack each round against a prone opponent.</p>',
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Boarded in Mediogalti',
    TRUE,
    'Verdant Spider',
    TRUE,
    'Spirit Totem',
    'Your travels have brought you to the Jenivere through the dangerous port of Ilizmagorti, home to both pirates and assassins. Perhaps you''re fleeing a price on your head, perhaps you''ve jumped ship, or perhaps you seek a new start where dangers are more obvious.',
    '<b>Legendary Power:</b> You become immune to poison, and gain a +2 bonus on all Fortitude saves.',
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Boarded in the Mwangi Expanse',
    TRUE,
    'Black Heron',
    TRUE,
    'Spirit Totem',
    'You boarded the Jenivere in the Mwangi Expanse, where you''ve lived or recently traveled. You harbor no illusions about the deadliness of the jungles, their creatures, or their peoples.',
    '<b>Legendary Power:</b> You deal +1d6 extra points of lethal or non-lethal damage to the target of your first combat maneuver each round, if the maneuver is successful. If the maneuver was a crit, deal critical damage as though this was an attack with a two handed x2 weapon.',
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Boarded in the Shackles',
    TRUE,
    'Whistling Kite',
    TRUE,
    'Spirit Totem',
    'Your last home was in the Shackles, a dangerous land of pirates and treachery but also of opportunity. A life on the sea has toughened you to many hardships.',
    '<b>Legendary Power:</b> When making a single ranged or melee attack from high ground against a single target, or a charge that starts 10 or more feet above your target, you deal double damage.',
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Boarded in Varisia',
    TRUE,
    'Azure Leopard',
    TRUE,
    'Spirit Totem',
    'Traveling from far to the north, you likely have little experience with the jungle or its strange forces. As Garund is exotic to you, so too are you to it.',
    '<b>Legendary Power:</b> You add half your Hit Dice to all Acrobatic checks, are always treated as if you had a running start, and never threaten from your first square of movement.',
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Colonial',
    TRUE,
    'White Bull',
    TRUE,
    'Spirit Totem',
    'You come from a long line of Sargavan colonists dating back to Cheliax''s expansion during the Everwar. Though Sargava''s power wanes, you maintain a hardy Chelish constitution and return home hoping to put Sargava back on the map.',
    NULL,
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Get the Cargo Through',
    TRUE,
    'Golden Snake',
    TRUE,
    'Spirit Totem',
    'Sea trade is never safe, especially near the Eye of Abendego. Your job is to ensure a precious cargo aboard the Jenivere reaches Eleder safely.',
    'You may either replace your normal natural armor bonus with that of your totem animal (as though shapechanged), or increase your legendary natural armor bonus from +2 to +4.',
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    '<i>Jenivere</i> Crew',
    TRUE,
    'Foraging Ibex',
    TRUE,
    'Spirit Totem',
    'This voyage is just one of many in your long career aboard the Jenivere. Whether crew, indentured servant, or aspiring captain, the ship is your home.',
    'You add half your Hit Dice to all Acrobatics checks, are always treated as if you had a running start, and never threaten from your first square of movement.',
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Mwangi Scholar',
    TRUE,
    'Chronicler Elephant',
    TRUE,
    'Spirit Totem',
    'You have long studied the Mwangi Expanse, one of the richest and most mysterious regions in Golarion. The Jenivere brings you to the very subject of your fascination.',
    'You deal +1d6 extra points of lethal or non-lethal damage to the target of your first combat maneuver each round, if successful. On a crit, deal critical damage as though using a two-handed x2 weapon.',
    FALSE
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    'Stowaway',
    TRUE,
    'Shifting Frog',
    TRUE,
    'Spirit Totem',
    'Not all passengers aboard the Jenivere are legal or known to the crew. Whether too poor for passage or hiding from authorities, you boarded in secret.',
    'You become immune to disease and gain +2 on all Fortitude saves. On a successful Fortitude save, you suffer no effects, recover instantly from lingering effects, and become immune to further uses of that effect for the duration of your legendary power.',
    FALSE
  )
ON CONFLICT (campaign_id, faction_name) DO NOTHING;
-- End Faction Main Seed

-- Start Faction Social Seed
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
)
INSERT INTO faction_social (
  faction_id,
  background,
  extra_details,
  hidden_details,
  reveal_hidden_details
)
VALUES
  ((SELECT id FROM factions
      WHERE faction_name = 'Gold Crown Shipping and Mining Company (G.C.S.)'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Although primarily known for hauling cargo between Port Freedom and Eleder, the G.C.S. originally made its profits from mining operations in the Bandu Hills. They ship everything valuable, from pineapples to gold, on their swift, well-armed barges and armored wagon trains. They also outfit expeditions into the Mwangi interior, and while many turn back with losses, their dangerous missions bring in real money and never lack volunteers.',
    'The wealthy noble Ortho Vibius regularly contracts expeditions into the Mwangi interior. His primary goal is to find the lost Sixth Army of Exploration and recover their relics, including the legendary Worldbreaker of Grand Prince Cyricus.',
    'Ortho Vibius is a member of the Kith, a network of Lion Blades affiliates. The Lion Blades have a controlling interest in G.C.S., using the Earl to launder money and fund scouting and intelligence missions.',
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Charau-Ka'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'The feral charau-ka are the legendary ape-men of the Mwangi jungles. Savage and remorseless hunters, they are feared and hated by virtually every civilization that encounters them. They build no cities, have no concept of trade, and make war on all they meet. Most serve the Gorilla King and Angazhan, and even those tribes not under Usaro''s sway are considered monstrous.',
    'The Chief High Girallon, Gorilla King Ruthazek, seeks to add Saventh-Yhi to his kingdom, enslave all within, and then move on to Kalabuto and Sargava.',
    NULL,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Ivory Cross'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Sargava''s most organized guild, the Ivory Cross, began operations in Eleder only 30 years ago, but has quickly established itself as a force to be reckoned with. Nearly a hundred mercenary soldiers and officers operate under its badge, maintaining a visible presence in Eleder. Though they escort expeditions into the Bandu Hills, they are not treasure hunters—they seek to maintain security and order. Rumors suggest they use violence and coercion to force cooperation from ranches and Mwangi tribesmen who refuse favorable terms.',
    'The Ivory Cross has been hired by Dargan Etters as a business venture, viewing Saventh-Yhi as a source of profit. Etters intends to maximize returns by selling valuable artifacts to select private collectors while controlling supply to keep prices high.',
    'The Ivory Cross is a front for the Aspis Consortium, allowing the consortium to profit within Sargava through mercenary contracts despite sanctions.',
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Pathfinder Society'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'A loose-knit group of explorers, archeologists, and adventurers, the Pathfinder Society searches the globe for lost knowledge and ancient treasures. Some Pathfinders seek to unlock history''s secrets, others chase fame and fortune, and still others pursue the thrill of perilous adventure.',
    'The Pathfinder Society seeks Saventh-Yhi for its lost knowledge, historical artifacts, and rumored wealth. With their lodge in Kalabuto recently destroyed, the Decemvirate also hopes Saventh-Yhi may serve as a new base of operations.',
    'Venture-Captain Finze Bellaugh believes Saventh-Yhi may hold the key to locating other ancient cities and relics, possibly tied to Old-Mage Jatembe''s travels after the Age of Darkness.',
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Red Mantis'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'The Red Mantis are the most tenacious and efficient assassins in the world. They kill with sacred saw-toothed sabres, and no fortress or cavern is secure against them. Their prices vary widely and are always nonnegotiable. They accept almost any job except regicide against a rightful monarch.',
    'The Red Mantis seek the rumored temple of Achaekek within Saventh-Yhi. They intend to claim its relics, including the head of an assassinated god, and kill any who trespass on this holy site.',
    NULL,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Rivermen''s Guild'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'A coalition of barge sailors along the Korir River, the Rivermen''s Guild is open to anyone who makes their living on the waterways, though only barge owners may vote. Known as thugs, robbers, and thieves, they steal, sink, and hijack cargo from non-guild members—especially the G.C.S. Many join simply to avoid being targeted. Attempts to disband the guild have failed, as guards fear retaliation.',
    'Captain Kassata Lewynn has struck a deal with the Rivermen''s Guild for barges and river knowledge to reach Saventh-Yhi. She hopes to recover enough treasure to buy the allegiance of pirate lords and make herself Hurricane King, folding the Rivermen into the Free Captains.',
    NULL,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Sargavan Custodial Government'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Beset by devil-binding pilgrims, pirate debts, and resentment from the subjugated Mwangi peoples, Sargava remains a northern colonial enclave in the southern wilds. Financially weakened and cut off from northern allies, the colony faces rebellion inspired by the undead child-god of Mzali. The colonial minority maintains control, but the Mwangi know they have the Expanse at their backs, and the government is in no position to quell a revolt.',
    'Sargava seeks to claim Saventh-Yhi to expand influence, deny rivals the same advantage, and access the city''s wealth and trade routes. Success could grant independence from the Free Captains—or failure could doom the colony entirely.',
    'Out of money, the Sargavan Custodial Government cannot afford further payments to the Hurricane King. They also need funds to appease independence factions threatening civil war. Infrastructure is failing, the army is underpaid, and unrest is rising. Saventh-Yhi may be their last chance to stabilize the colony.',
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Bekyar Raiders'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Bekyar tend to be tall, with elaborate braided hairstyles often incorporating silk headwraps. Most hunt for game and raid other communities for food, resources, and people. What they do with their captives varies by tribe.',
    '<i>Bandu -</i> Slavers who infest the Bandu Hills, dealing in human trafficking and sacrificing light-skinned captives to their nature spirits.
<br><i>Yemba -</i> A smaller, rarely encountered tribe rumored to be cannibals, found along the River of Lost Tears and known for ritual feasts presided over by “Yemba-bo” witch doctors.',
    NULL,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Bonuwat Seafarers'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Bonuwat appear along coastlines, often shirtless or painted, with hair cropped short, in cornrows, or shaved for hydrodynamics. They have a strong seafaring heritage, forming communities wherever water and fish are plentiful.',
    '<i>Ijo -</i> Friendly open-water fishers who dress simply and maintain cordial relations with colonials and tribespeople.<br><i>Ombo -</i> Merchants aligned with Shackles pirates, adopting their style and engaging in lucrative slave trading, sometimes preying on the Ijo.',
    NULL,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Chosen Caldaru'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'With skin tones from olive to dark bronze, the Caldaru dress in long, flowing robes. Believing themselves a chosen people, many were enslaved or displaced when outsiders reached the Mwangi Expanse. Rather than assimilate, they absorbed outside knowledge while maintaining their identity, forming diaspora communities that trade and share expertise.',
    NULL,
    NULL,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Colonial Settlers'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Descended from Chelish colonists but born in Sargava, these people know only their homeland. While Inner Sea culture dominates, their lifestyle reflects local influences. Many speak Polyglot, and some incorporate Mwangi religious practices. Intermarriage, once scandalous, is now uncommon but accepted.',
    NULL,
    NULL,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Mauxi Nomads'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'The Mauxi wear head wraps to protect from the sun and favor colorful robes and textiles. They are typically peaceful nomads but ready to defend themselves. Their subgroups follow different herd animals across the expanse.',
    NULL,
    NULL,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Zenj Peoples'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'The Zenj are divided between the matriarchal savannah-dwelling Zenje and the patriarchal jungle-dwelling Zenju. Despite differences, they see themselves as one people who trade, celebrate, and come to one another''s aid. Their split is said to date back to a disagreement over hunting and diet.',
    NULL,
    NULL,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Brotherhood of Cheerful Service'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'A noble order of Mwangi elves and magical beasts, this dragon-led brotherhood safeguards impoverished villages from disease, famine, pestilence, and wild animals. Their well-intentioned aid often leads to misunderstandings, such as killing herds or replacing food stores with lizards.',
    NULL,
    NULL,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Coils of Ydersius'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Little is known of this secretive serpentfolk organization. Once thought extinct, serpentfolk have reappeared only recently. The group shares iconography with Ydersius, the long-dead serpentfolk god, and may believe they draw power from its severed skull.',
    NULL,
    NULL,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Freemen''s Brotherhood'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'A loose association of Mwangi natives led by ex-slaves, the Freemen''s Brotherhood is a radical abolitionist group. They seek to instill terror in foreigners and merchants they associate with the slave trade, sometimes viewing all colonials as “Imperialist Thieves.” Their lack of structure and quick anger make them prone to riots and violence.',
    NULL,
    NULL,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Order of the Coil'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Originally part of the Hellknight Order of the Pyre, the Order of the Coil formed after a disastrous attempt to establish a headquarters in Sargava. Inspired by local vipers, the remaining Hellknights became zealously destructive, seeking to eradicate Mwangi cultures. Under Lictor Racnhe, they employ fire and poison to destroy settlements and historical sites.',
    NULL,
    NULL,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Followers of the Sacred Serpent'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'An isolated tribe of Caldaru artisans who view sculpture as the highest form of art and worship. They preserve the ancient stonework of their district and revere the Radiant Muse, their spiritual guide, though they visit it only on holy days and always with tribute.',
    NULL,
    'The chief and some warriors have Taldan ancestors; survivors of a marble-skinned, blue-eyed, golden-haired band of soldiers once protected their tribe from Charau-Ka. Most returned to the jungle and vanished, but some remained, strengthening the tribe''s bloodline.',
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Toadies of the Green God'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'A tribe of boggards who control the flooded agricultural district. Their spiritual guide has vanished, leaving them unable to perform rituals or maintain protective wards. Desperate and fearful, they have become both pliable and dangerous.',
    NULL,
    NULL,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Vegepygmies of the Russet Mold'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'A large tribe of vegepygmies inhabiting the dreaming jungle of the former residential district. They revere the immense colony of russet mold growing on the district''s ziggurat as holy. Reasoning with mold-born creatures is difficult, though they may view humanoids similarly.',
    NULL,
    NULL,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Boarded in Cheliax'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'While you aren''t necessarily a native of Cheliax, you boarded the Jenivere at one of that country''s port cities. As the people of Cheliax generally know the Mwangi Expanse as a near legendary land home to strange beasts and exotic treasures, your views of the region have a distinctly romantic tinge, and the desire for fame, wealth, and adventure likely motivate your travels.',
    'You begin the campaign with a detailed map of the Mwangi Expanse (granting +2 competence bonus on Knowledge [geography] checks regarding this region) and 200 gp worth of mundane equipment to aid your exploration.',
    '<b>Spirit Totem:</b> Red-Hued Canines (Hyena, Jackal, Wild Dog, etc.)
<br><b>Compatible Animal Shaman:</b> Wolf Shaman
<br><b>Compatible Rage Totems:</b> Beast, Cult, and Spirit Totems
<br><b>Totemic Skills:</b> Bluff, Perception, and Sleight of Hand.
<br><b>Totem Magic:</b> You gain the scent universal monster ability. Beginning at 12th level, you also gain the benefits of Deft Maneuvers (or Greater Trip, if you already have Deft Maneuvers) and may attempt a trip combat maneuver as a swift action.',
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Boarded in Mediogalti'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Your travels have brought you to the Jenivere through the dangerous port of Ilizmagorti, home to both pirates and assassins. Perhaps you''re fleeing a price on your head, perhaps you''ve jumped ship, or perhaps you seek a new start where dangers are more obvious.',
    'Your familiarity with subtle slayings and toxins grants you a +2 trait bonus on all saves against poison. You also gain immunity to one poison type of your choice.',
    '<b>Spirit Totem:</b> Green-Hued Carnivorous Vermin (Mantis, Spider, Wasp, etc.)
<br><b>Compatible Animal Shaman:</b> Bat Shaman
<br><b>Compatible Rage Totems:</b> Beast, Hive, and Spirit Totems
<br><b>Totemic Skills:</b> Climb, Stealth, and Survival.
<br><b>Totem Magic:</b> Your darkvision increases by 30 ft. At 12th level, once per day for 1 minute, you may discorporate into a swarm of diminutive creatures identical to your totem, functioning as swarm skin with modified rules.',
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Boarded in the Mwangi Expanse'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'You boarded the Jenivere in the Mwangi Expanse, where you''ve lived or recently traveled. You harbor no illusions about the deadliness of the jungles, their creatures, or their peoples.',
    'You gain Polyglot as a bonus language and a +1 trait bonus on Knowledge (nature) checks regarding the jungle.',
    '<b>Spirit Totem:</b> Dark-Hued Simian (Ape, Gorilla, Lemur, Monkey, etc.)
<br><b>Compatible Animal Shaman:</b> Ape Shaman
<br><b>Compatible Rage Totems:</b> Atavism, Beast, and Spirit Totems
<br><b>Totemic Skills:</b> Acrobatics, Climb, and Disable Device.
<br><b>Totem Magic:</b> You gain a climb speed equal to half your movement speed. At 12th level, you gain Unarmed Combatant (or Greater Grapple) and Throw Anything, and may throw weapons while climbing without penalty.',
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Boarded in the Shackles'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Your last home was in the Shackles, a dangerous land of pirates and treachery but also of opportunity. A life on the sea has toughened you to many hardships.',
    'Choose one saving throw category; you gain a +1 trait bonus on all saves of that type.',
    '<b>Spirit Totem:</b> Musical Bird (Eagle, Hawk, Owl, Vulture, etc.)
<br><b>Compatible Animal Shaman:</b> Eagle Shaman
<br><b>Compatible Rage Totems:</b> Beast, Celestial, and Spirit Totems
<br><b>Totemic Skills:</b> Appraise, Fly, and Perception.
<br><b>Totem Magic:</b> You gain +1 sacred bonus on ranged attacks and your ranged crit multiplier becomes 19-20/x3. At 12th level, once per day for 1 minute, you may sprout wings granting fly speed equal to half base speed (max 30 ft).',
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Boarded in Varisia'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Traveling from far to the north, you likely have little experience with the jungle or its strange forces. As Garund is exotic to you, so too are you to it.',
    'Choose either +2 Bluff against jungle inhabitants, or +1 caster level for mind-affecting spells against jungle natives.',
    '<b>Spirit Totem:</b> Blue-Hued Feline (Cheetah, Lion, Leopard, etc.)
<br><b>Compatible Animal Shaman:</b> Lion Shaman
<br><b>Compatible Rage Totems:</b> Beast, Chaos, and Spirit Totems
<br><b>Totemic Skills:</b> Disguise, Perception, and Stealth
<br><b>Totem Magic:</b> You gain a 1d8 bite attack. At 12th level, after a charge, AoO, or sneak attack, you may make a bite attack as an immediate action.',
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Colonial'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'You come from a long line of Sargavan colonists dating back to Cheliax''s expansion during the Everwar. Though Sargava''s power wanes, you maintain a hardy Chelish constitution and return home hoping to put Sargava back on the map.',
    '+1 trait bonus on Knowledge (local) checks relating to Sargavan settlements and politics, and +1 on saves vs. disease.',
    '<b>Spirit Totem:</b> Pale-Hued Hoofed Mammal (Antelope, Buffalo, Cow, Goat, etc.)
<br><b>Compatible Animal Shaman:</b> Boar Totem
<br><b>Compatible Rage Totems:</b> Beast, Daemon, and Spirit Totems
<br><b>Totemic Skills:</b> Handle Animal, Heal, and Survival
<br><b>Totem Magic:</b> You gain ferocity in active combat. At 12th level, you may move full speed in medium armor or medium load, and increase charge attack damage dice by one step.',
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Get the Cargo Through'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Sea trade is never safe, especially near the Eye of Abendego. Your job is to ensure a precious cargo aboard the Jenivere reaches Eleder safely.',
    'You begin with an additional 300 gp in starting wealth, or 10% more starting wealth by level.',
    '<b>Spirit Totem:</b> Yellow-Hued Reptilian (Crocodile, Dinosaur, Lizard, Turtle, etc.)
<br><b>Compatible Animal Shamans:</b> Dragon and Serpent Shamans
<br><b>Compatible Rage Totems:</b> Beast, Dragon, Spirit, and World Serpent Totems
<br><b>Totemic Skills:</b> Intimidate, Stealth, and Swim
<br><b>Totem Magic:</b> +2 sacred bonus on attacks of opportunity; +2 dodge bonus vs. AoOs you provoke. At 12th level, you may use full-round actions in surprise rounds and gain uncanny dodge using your HD as rogue level.',
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = '<i>Jenivere</i> Crew'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'This voyage is just one of many in your long career aboard the Jenivere. Whether crew, indentured servant, or aspiring captain, the ship is your home.',
    'Choose one skill (Acrobatics, Climb, Knowledge nature, Knowledge geography, Swim, or Survival). You gain +1 trait bonus and it becomes a class skill.',
    '<b>Spirit Totem:</b> Verbatious Camelid, Cervid, or Equine (Horse, Donkey, Zebra, etc.)
<br><b>Compatible Animal Shaman:</b> Saurian Shaman
<br><b>Compatible Rage Totems:</b> Beast, Fiend, Spire, and Spirit Totems
<br><b>Totemic Skills:</b> Diplomacy, Handle Animal, Ride
<br><b>Totem Magic:</b> +10 enhancement to base speed. At 12th level, move through any undergrowth without penalty and leap obstacles during movement or charge.',
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Mwangi Scholar'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'You have long studied the Mwangi Expanse, one of the richest and most mysterious regions in Golarion. The Jenivere brings you to the very subject of your fascination.',
    'You gain Polyglot as a bonus language and +1 trait bonus on Knowledge (history) checks regarding the Mwangi Expanse.',
    '<b>Spirit Totem:</b> Professional Large Mammal (Elephant, Hippo, Rhino, etc.)
<br><b>Compatible Animal Shaman:</b> Bear Shaman
<br><b>Compatible Rage Totems:</b> Ancestor, Beast, and Spirit Totems
<br><b>Totemic Skills:</b> Bluff, Intimidate, Survival
<br><b>Totem Magic:</b> +2 enhancement to natural armor. At 12th level, gain Powerful Maneuvers (or Greater Overrun) and the trample ability.',
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Stowaway'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Not all passengers aboard the Jenivere are legal or known to the crew. Whether too poor for passage or hiding from authorities, you boarded in secret.',
    '+1 trait bonus on Stealth checks and Survival checks to find food.',
    '<b>Spirit Totem:</b> Stealthy Small Mammal or Amphibian (Rat, Porcupine, Salamander, Weasel, etc.)
<br><b>Compatible Animal Shaman:</b> Shark Shaman
<br><b>Compatible Rage Totems:</b> Beast, Moon, and Spirit Totems
<br><b>Totemic Skills:</b> Climb, Escape Artist, Stealth
<br><b>Totem Magic:</b> You gain a swim speed equal to half your movement speed. Beginning at 12th level, you also gain the amphibious special quality and gain concealment while underwater against creatures that are above the water.',
    FALSE
  )
ON CONFLICT DO NOTHING;
-- End Faction Social Seed

-- Start Faction Attitude Seed
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
)
INSERT INTO faction_attitude (
  faction_id,
  attitude_id,
  enemies,
  enemies_visible,
  hostile_boon,
  unfriendly_boon,
  neutral_boon,
  friendly_boon,
  helpful_boon
)
VALUES
  ((SELECT id FROM factions
      WHERE faction_name = 'Gold Crown Shipping and Mining Company (G.C.S.)'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    4,
    'Rivermen''s Guild',
    TRUE,
    NULL,
    NULL,
    'The G.C.S. has knowledge of secret tunnels, roads, and shortcuts. Roll 1d6 instead of 1d4 on shortcuts. Each signatory also gains a 500 gp signing bonus.',
    'Utilizes forward scouts to discover areas more easily, providing an additional +5 bonus on Perception checks to discover new areas.',
    NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Charau-Ka'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    2,
    'Ruthazek believes that no grouping of man is worth considering a rival; they are too weak and short-lived to be any real concern.',
    TRUE,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Ivory Cross'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    1,
    'The Pathfinder Society and the Ivory Cross are often at odds, undertaking similar jobs while holding radically different values. This expedition is yet another likely to end in bloody collision.',
    TRUE,
    NULL,
    NULL,
    'The Ivory Cross treats land trade routes as highways. A selection of scrolls, potions, and wands worth 500 gp per person is provided as a signing bonus.',
    '+5 bonus on Diplomacy checks to secure alliances or trade routes.',
    NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Pathfinder Society'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    4,
    'The Pathfinder Society and the Ivory Cross are often at odds, undertaking similar jobs while holding radically different values. This expedition is yet another likely to end in bloody collision.',
    TRUE,
    NULL,
    NULL,
    'The Pathfinder Society can cross through settlements and ruins at 2x speed. Field commissions grant Wayfinders embedded with an ioun stone worth up to 400 gp.',
    '+4 bonus to exploration checks.',
    NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Red Mantis'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    2,
    'The Sargavan Custodial Government has no patience for Red Mantis assassins. While they wish to reach Saventh-Yhi first, they know they can at least tax the others'' findings; but the Red Mantis answer to no one, and only nations can compete with their power.',
    TRUE,
    NULL,
    NULL,
    'The Red Mantis can sabotage two groups at a time, always sabotage the leader, and their sabotage attempts never backfire. Signing bonus includes 500 gp worth of poisons, antitoxins, and healer''s kits.',
    'They gain a free condition (sow terror) to conquer each district within Saventh-Yhi.',
    NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Rivermen''s Guild'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    1,
    'Vessels belonging to the G.C.S. are frequently preyed upon by the Rivermen''s Guild, and the two attack each other on sight.',
    TRUE,
    NULL,
    NULL,
    'The Rivermen''s Guild moves twice as far along rivers and waterways on the day they embark. Signing bonus includes either a small crew of buccaneers or 500 gp worth of guns, powder, and shot.',
    '+4 bonus to supply and supply checks.',
    NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Sargavan Custodial Government'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    2,
    'The Sargavan Custodial Government has no patience for Red Mantis assassins. While they wish to reach Saventh-Yhi first, they know they can at least tax the others'' findings; but the Red Mantis answer to no one, and only nations can compete with their power.',
    TRUE,
    NULL,
    NULL,
    'The Sargavan Custodial Government can force certain people to provide shelter and lodging, opening more safe places to rest and resupply. Signing bonus includes a noble title, a tract of land, and a personal guard or servant.',
    '+4 defense to encampments provided by Sargavan military troops.',
    NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Bekyar Raiders'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    1, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Bonuwat Seafarers'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    4, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Chosen Caldaru'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Colonial Settlers'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Mauxi Nomads'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Zenj Peoples'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Brotherhood of Cheerful Service'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Coils of Ydersius'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    1, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Freemen''s Brotherhood'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    2, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Order of the Coil'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    2, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Followers of the Sacred Serpent'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    2, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Toadies of the Green God'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    2, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Vegepygmies of the Russet Mold'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    2, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Boarded in Cheliax'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Boarded in Mediogalti'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Boarded in the Mwangi Expanse'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Boarded in the Shackles'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Boarded in Varisia'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Colonial'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Get the Cargo Through'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = '<i>Jenivere</i> Crew'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Mwangi Scholar'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Stowaway'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    3, NULL, FALSE, NULL, NULL, NULL, NULL, NULL
  )
ON CONFLICT DO NOTHING;
-- End Faction Attitude Seed

-- Start Faction Gallery Seed
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
)
INSERT INTO faction_gallery (
  faction_id,
  image_url,
  alt,
  is_main,
  is_tall
)
VALUES
  ((SELECT id FROM factions
      WHERE faction_name = 'Gold Crown Shipping and Mining Company (G.C.S.)'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/icon/logo-gold-crown-shipping.webp',
    'Faction Logo',
    TRUE,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Charau-Ka'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/icon/icon-gorilla-king.webp',
    'Faction Logo',
    TRUE,
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Ivory Cross'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/icon/logo-ivory-cross.webp',
    'Faction Logo',
    TRUE,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Pathfinder Society'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/icon/logo-pathfinder-society-sargava.webp',
    'Faction Logo',
    TRUE,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Red Mantis'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/icon/logo-red-mantis.webp',
    'Faction Logo',
    TRUE,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Rivermen''s Guild'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/icon/logo-rivermens-guild.webp',
    'Faction Logo',
    TRUE,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Sargavan Custodial Government'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/icon/logo-sargava-custodial-government.webp',
    'Faction Logo',
    TRUE,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Bekyar Raiders'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/tribe-bekyar.webp',
    'Bekyar Tribeswoman',
    TRUE,
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Bonuwat Seafarers'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/tribe-bonuwat.webp',
    'Bekyar Tribesman',
    TRUE,
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Chosen Caldaru'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/tribe-caldaru.webp',
    'Caldaru Tribeswoman',
    TRUE,
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Colonial Settlers'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/tribe-sargavan.webp',
    'Colonial Settler',
    TRUE,
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Mauxi Nomads'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/tribe-mauxi.webp',
    'Mauxi Tribesman',
    TRUE,
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Zenj Peoples'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/npc/tribe-zenj.webp',
    'Zenj Tribesman',
    TRUE,
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Brotherhood of Cheerful Service'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/icon/logo-brotherhood-service.webp',
    'Minor Faction Logo',
    TRUE,
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Freemen''s Brotherhood'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/icon/logo-freemens-brotherhood.webp',
    'Minor Faction Logo',
    TRUE,
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Order of the Coil'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/icon/logo-order-of-the-coil.webp',
    'Minor Faction Logo',
    TRUE,
    TRUE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Boarded in Cheliax'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-carmine-hyena.webp',
    'Spirit Totem',
    TRUE,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Boarded in Mediogalti'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-verdant-bear.webp',
    'Spirit Totem',
    TRUE,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Boarded in the Mwangi Expanse'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-black-heron.webp',
    'Spirit Totem',
    TRUE,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Boarded in the Shackles'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-whistling-kite.webp',
    'Spirit Totem',
    TRUE,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Boarded in Varisia'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-azure-leopard.webp',
    'Spirit Totem',
    TRUE,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Colonial'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-white-bull.webp',
    'Spirit Totem',
    TRUE,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Get the Cargo Through'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-golden-snake.webp',
    'Spirit Totem',
    TRUE,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = '<i>Jenivere</i> Crew'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-ibex.webp',
    'Spirit Totem',
    TRUE,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Mwangi Scholar'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-elephant.webp',
    'Spirit Totem',
    TRUE,
    FALSE
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Stowaway'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    '/images/totem/totem-shifting-frog.webp',
    'Spirit Totem',
    TRUE,
    FALSE
  )
ON CONFLICT DO NOTHING;
-- End Faction Gallery Seed

-- Start Faction NPC Seed
WITH c_id AS (
  SELECT id AS campaign_id
  FROM campaigns
  WHERE campaign_name = 'Serpents 2026'
)
INSERT INTO faction_npcs (
  faction_id,
  npc_id,
  association_type
)
VALUES
  ((SELECT id FROM factions
      WHERE faction_name = 'Gold Crown Shipping and Mining Company (G.C.S.)'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM npc_main
      WHERE npc_name = 'Ortho Vibius'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Expedition Leader'
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Ivory Cross'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM npc_main
      WHERE npc_name = 'Dargan Etters'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Expedition Leader'
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Pathfinder Society'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM npc_main
      WHERE npc_name = 'Amivor Glaur'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Expedition Leader'
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Red Mantis'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM npc_main
      WHERE npc_name = 'Chivañe'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Expedition Leader'
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Rivermen''s Guild'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM npc_main
      WHERE npc_name = 'Kassata Lewynn'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Expedition Leader'
  ),
  ((SELECT id FROM factions
      WHERE faction_name = 'Sargavan Custodial Government'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    (SELECT id FROM npc_main
      WHERE npc_name = 'Rotilius Havelar'
      AND campaign_id = (SELECT campaign_id FROM c_id)),
    'Expedition Leader'
  )
ON CONFLICT DO NOTHING;
-- End Faction NPC Seed
-- END npcs.ejs SEED BLOCK

-- Save seed
COMMIT;
-- ROLLBACK;