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
<br><br>...fine hunting on the Shiv, but the bugs are a constant distraction. Nylithati''s skills at healing help fight the sickness, but I fear she has...
<br><br>...founded. Nylithati has seized control of my crew. They are hers now. And so I have abandoned...
<br><br>...fine home. Fresh water nearby and I need not endure Nylithati''s ceaseless raving about...
<br><br>...will not be returning to that gray, silent island again. There is nothing there but horror...
<br><br>...crew lurking about the area. They seem strange, almost feral. It has been almost a decade since the wreck. I wonder what strange beliefs Nylithati has...
<br><br>...changed. There was no sign of Nylithati in the camp, but the focus of their ceremony was a cauldron they must have salvaged from the Thrune''s Fang at the base of the ruined lighthouse. It was into this they threw the half-eaten body of the still screaming man...
<br><br>...all around. I can hear them chanting in the green even now. They call Nylithati “Mother Thrunefang” now, and promise me immortality if I lay down my arms and submit. I know what their immortality consists of, and I''ll have no part of that corrupt life after...'
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
<br><br><b>To Command the Very Tides to Rise Up and Eschew What Lies Below:</b>
<br><br>Empower the Four Sentinel Runes with the Blood of a Thinking Creature Tempered by the Kiss of a Serpent''s Tongue.
<br><br>Anoint the Tide Stone with Waters Brought from the Sea in a Vessel of Purest Metal.
<br><br>Invoke the Lord''s Sacred Name to Wrap His Coils around the Sea Itself that He Might Lay Bare What Lies Below and Cast Down Your Enemies on the Waves above.'
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
<br><br>This chamber was once a scriptorium where books and scrolls sacred to the worship of Zura were transcribed and illuminated.
<br><br>This temple was built over an even more ancient temple — one that was dedicated to a deity referred to only as the “Beheaded One,” an entity that was apparently an enemy to the ancient Zura cultists.
<br><br>Several prayers seem to indicate that the ancients made use of undead slaves created from both “humans culled from the unbelievers and slaves of the Beheaded One.”
<br><br>As much hatred as the Zura cultists had for the “slaves of the Beheaded One,” they also seemed to despise their own kind—especially those they called the “misbegotten of Saventh-Yhi.”'
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
<br><br>The three large alcoves in this room once served as meditation chambers—the cultists would enter one, pull a curtain for privacy, and recite the complex prayers and parables carved on the walls here. These carvings, all written in Azlanti, tell the history of this particular Zura cult in three stages.
<br><br>The southern alcove tells of the cult''s genesis in the city of Saventh-Yhi in the jungle, but is frustratingly vague when it comes to exact details on the legendary city apart from confirming that it was built by Azlanti — this section ends with the cult''s exile from Saventh-Yhi and how they made a dangerous overland journey that ended on the shores of a remote island far from their homeland.
<br><br>The northwestern alcove takes up the story at this point, detailing the cult''s exploration of this island (identifiable as Smuggler''s Shiv), their discovery and defeat of a large group of serpentfolk who had gone into hiding after the defeat of their kind many years before at Saventh-Yhi, and the creation of this temple.
<br><br>The northeastern alcove plots the cult''s future plans, focusing on how they had hoped to earn the gift of vampirism from Zura by undertaking extensive and vile rituals, and once this gift was theirs, how they planned on making the journey back to Saventh-Yhi to ''awaken the city with Zura''s blessing.'' The route back to the ancient city is similarly cryptic, and the portions that do make sense reference antiquated geography; however, it seems they ultimately intended to use something called the ''Light of Tazion'' to return to the city through its protective wards.
<br><br>In her notes, Yarzoth seems particularly intrigued by the possibility that Saventh-Yhi might be the exact spot where, so long ago, her god Ydersius was beheaded.'
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
    'This rod appears to be made of polished gold, and features three blown-glass onion-shaped domes at one end. It seems heavy enough to be wielded as a weapon, should the need arise.' 
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
  book_number,
  session_number,
  title,
  log_type
)
VALUES
  ((SELECT campaign_id FROM c_id),
    0,
    1,
    'Sargava at a Glance',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    1,
    2,
    'Smuggler''s Shiv',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    3,
    'Eleder',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    4,
    'Kalabuto',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    5,
    'Fort Bandu',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    6,
    'The Korir River',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    7,
    'The Screaming Jungle',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    8,
    'The Bandu Hills',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    2,
    9,
    'Ruins of Tazion',
    'location spotlight'
  ),
  ((SELECT campaign_id FROM c_id),
    3,
    10,
    'The Lost City of Saventh-Yhi',
    'location spotlight'
  )
ON CONFLICT DO NOTHING;
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
ON CONFLICT DO NOTHING;
-- End Session Spotlight Paragraphs
-- END maps.ejs SEED BLOCK

-- Save seed
COMMIT;