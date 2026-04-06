-- Database seed file for existing data and initial setup
BEGIN;

-- Seed campaign into structure for organization
INSERT INTO campaigns (campaign_name, description, start_date)
VALUES (
  'Serpents 2026',
  'Explore the endless jungle of the Mwangi Expanse in an Indiana-Jones style pulp adventure search for lost cities and ancient treasure.',
  '2024-06-08'
)
ON CONFLICT (campaign_name) DO NOTHING;

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
ON CONFLICT (campaign_id, book_number, session_number) DO NOTHING;

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
    '/images/loot/loot-exsanguinated-goat.webp',
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

-- Save seed
COMMIT;