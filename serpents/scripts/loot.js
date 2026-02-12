// This .js is meant to populate the resources and journal with session loot/notes

const loot = [
  {
    id: 1,
    type: "magic",
    name: "Convergent Cocoon Cloak",
    img: true,
    src: "/serpents/images/loot-cocoon-cloak.webp",
    description: [
      "This ruffled silk cloak is incredibly durable despite its soft, delicate construction; the outer lining is lightweight and decorated with depictions of a great moth.",
      "This <i>Cocoon Cloak</i> appears to be connected to some being of the great beyond through some sort of magical convergence. As normal, anytime the wearer falls asleep (whether normally or they are forced unconscious), the cloak immediately transforms into sticky strands that envelop the wearer's body, hardening into a solid silk cocoon. While wrapped in the cocoon the wearer is not helpless, they gain a +4 enhancement bonus to their natural armor and CMD against attempts to move them, and they are protected from critical hits and sneak attacks as if subject to the light fortification armor ability.",
      "Only those who sleep wrapped in its silky strands can truly know what is experienced there, or what might emerge from the cocoon come dawn; the cocoon opens and transforms back into a cloak once the wearer wakes.",
    ]
  },
  // {
  //   id: 2,
  //   type: "dream1",
  //   name: "Placeholder",
  //   img: false,
  //   src: "/serpents/images/placeholder.webp",
  //   description: [
  //     "Placeholder here",
  //   ]
  // },
  {
    id: 3,
    type: "dream2",
    name: "Placeholder",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "Placeholder here",
    ]
  },
  {
    id: 4,
    type: "note1",
    name: "Captains Log of Alizandru Kovack of the <i>Jenivere</i>",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "An examination of this log reveals that the <i>Jenivere’s</i> captain seemed to be suffering from some sort of madness that grew over the course of the ship’s final voyage. Earlier entries from previous voyages are precise in recording progress and events along the way, as are entries from the first two-thirds of this last trip. Yet as one reads further, the more recent the entries get, the less common they become—in some cases, several days are missing entries. What entries do appear are strangely short, focusing more and more on one of the passengers—the Varisian scholar Ieana, with whom the captain seems to have become obsessed. Several entries are nothing more than poorly written love poems to Ieana, while others bemoan Captain Kovack’s inability to please her or catch her attention. Near the end, the entries begin to take on a more ominous tone with the captain starting to complain that other members of the crew are eyeing “his Ieana.” In particular, he suspects his first mate is in love with her, and writes several times about how he wishes Alton would just “have an accident.” The final entry is perhaps the most disturbing, for in it the captain writes of how he’s changed course for Smuggler’s Shiv at Ieana’s request. He hopes that the two of them can make a home on the remote island, but also notes that the crew are growing increasingly agitated at the ship’s new course. The captain muses that “something may need to be done about the crew” if their suspicions get any worse.",
    ]
  },
  {
    id: 5,
    type: "note2",
    name: "Placeholder",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "Placeholder here",
    ]
  },
  {
    id: 6,
    type: "magic",
    name: "Magnificent Golden Bow",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "This <i>+1 composite longbow</i> has a +2 strength rating and appears as though it is made from solid gold. The bow itself is magnificent to behold, and it - as well as its shots - look both powerful and impressive, even if they don't manage to be effective.",
    ]
  },
  {
    id: 7,
    type: "magic",
    name: "Kensuke",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "This <i>+1 adamantine machete</i> has the tentacled touch quirk, enabling it to deliver touch spells cast through it from an extra 5ft. away.",
    ]
  },
  {
    id: 8,
    type: "magic",
    name: "Sodden Cloak of Resistance",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "This <i>Cloak of Resistance +1</i> is permanently waterlogged, and wearing it causes the wearer to be damp, regardless of outside conditions.",
    ]
  },
  {
    id: 9,
    type: "magic",
    name: "Thirsty Headband of Alluring Charisma",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "This <i>+2 headband of alluring charisma</i> causes the bearer to be physically and socially thirsty. They require 3x the amount of water as a normal person, and are constantly on the lookout for gratification.",
    ]
  },
  {
    id: 10,
    type: "magic",
    name: "Yemba Iron Bell",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "This small, rusty iron bell contains great magic. Once per day, when the bell is rung as a standard action, all creatures within 60 feet who can hear the bell must make a DC 14 Will save or be compelled to seek out the source of the sound for 7 rounds, or until they find the source, moving at their normal speeds. If the sound leads its subjects into a dangerous area, each affected creature gets a second save. This is a mind affecting compulsion effect. The bell affects a maximum of 24 HD of creatures.",
    ]
  },
  {
    id: 11,
    type: "magic",
    name: "Zenj Spirit Fetish",
    img: true,
    src: "/serpents/images/loot-zenj-spirit-fetish.webp",
    description: [
      "The bearer of this shrunken monkey head can use it to cast dispel evil. While the spell is in effect, the bearer can make a melee touch attack with the head to banish an evil creature from another plane back to its home plane, or dispel one evil spell or one enchantment spell cast by an evil creature. This use discharges and ends the spell. When the spell ends, the fetish becomes a normal, non-magical monkey head.",
    ]
  },
  {
    id: 12,
    type: "magic",
    name: "War Mask of Terror",
    img: true,
    src: "/serpents/images/loot-war-mask-terror.webp",
    description: [
      "Shamans and warriors of many of the indigenous tribes of western Garund add to their fierceness and mystique by wearing wooden masks that bear terrifying visages of demonic spirits. A war mask is considered sacred and personal, and is often handed down to the next generation when a wearer dies. Individual masks are often notorious, and many tribesfolk can readily identify masks of other tribes with a DC 15 Knowledge (local) check.",
      "A war mask of terror provides its wearer with a +2 competence bonus on Intimidate checks and a +1 deflection bonus to Armor Class. In addition, the wearer may cast scare once per day.",
    ]
  },
  {
    id: 13,
    type: "note1",
    name: "Fragments of Captain Beliker's Log of the <i>Thrunefang</i>",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "...many survived, the Thrune’s Fang will never sail again. Sargava’s assimilation must proceed without...",
      "...fine hunting on the Shiv, but the bugs are a constant distraction. Nylithati’s skills at healing help fight the sickness, but I fear she has...",
      "...founded. Nylithati has seized control of my crew. They are hers now. And so I have abandoned...",
      " ...fine home. Fresh water nearby and I need not endure Nylithati’s ceaseless raving about...",
      "...will not be returning to that gray, silent island again. There is nothing there but horror...",
      " ...crew lurking about the area. They seem strange, almost feral. It has been almost a decade since the wreck. I wonder what strange beliefs Nylithati has...",
      "...changed. There was no sign of Nylithati in the camp, but the focus of their ceremony was a cauldron they must have salvaged from the Thrune’s Fang at the base of the ruined lighthouse. It was into this they threw the half-eaten body of the still screaming man...",
      " ...all around. I can hear them chanting in the green even now. They call Nylithati “Mother Thrunefang” now, and promise me immortality if I lay down my arms and submit. I know what their immortality consists of, and I’ll have no part of that corrupt life after...",
    ]
  },
  {
    id: 14,
    type: "note1",
    name: "Last Words of Captain Alizandru Kovack",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      " I am Captain Alizandru Kovack, betrayer of my crew and destroyer of the good ship Jenivere. Hell would be a welcome escape from what hideous un-life looms before me, but it is no less a punishment than I deserve. That I was enslaved mind and body to a serpentine demon who wore a Varisian’s skin does not pardon me. It is my weakness that led the <i>Jenivere</i>, her crew, and her passengers to their doom. That Ieana has abandoned me here is nothing more than the fate I deserve. I do not beg forgiveness, but I despair that she lives still, and that she seeks something dire on this forsaken isle — she seemed particularly interested in <i>Red Mountain</i>. If you read this and you be a kind soul, seek out what I have become and destroy me, and then seek out Ieana and slay her as well. And to those whose lives I have helped destroy, I can only apologize from this, my dark cradle and darker grave.",
    ]
  },
  {
    id: 15,
    type: "note1",
    name: "Red Mountain Ritual Notes",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "A low stone altar, its sides carved like coiling snakes and its top carved to resemble a yawning viper’s maw, sits in the center of this room. The walls of the chamber are carved with images of anthropomorphic serpents using strange, pointed megaliths of stone to work great feats of magic—transforming an army of humans into zombies, calling down flaming bolts of lightning from the stars, or parting the waters of the sea to dash human ships upon the exposed rocks of the seabed below. This final image seems to have been recently cleaned of dust, and several lines of text have been made more legible via the application of inks and perhaps blood.",
      "<br> The translation of the legible lines of text are reproduced as follows:<br><br>",
      "<b>To Command the Very Tides to Rise Up and Eschew What Lies Below:</b>",
      "Empower the Four Sentinel Runes with the Blood of a Thinking Creature Tempered by the Kiss of a Serpent’s Tongue.",
      "Anoint the Tide Stone with Waters Brought from the Sea in a Vessel of Purest Metal.",
      "Invoke the Lord’s Sacred Name to Wrap His Coils around the Sea Itself that He Might Lay Bare What Lies Below and Cast Down Your Enemies on the Waves above.",
    ]
  },
  {
    id: 16,
    type: "note1",
    name: "Venture-Captain Havner Ames' Log of the <i>Nightvoice</i>",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "Ravaged by mold and the strange fungus, only pieces of this log survive, but the entries were detailed enough to piece together the ship's tragic history. The <i>Nightvoice</i> was a Pathfinder Society exploration vessel that  was on its way back from an expedition around the horn of Garund, when a strange leathery pod they discovered in a seaside cavern burst open. Only Captain Havner Ames managed to resist the resultant infection, and as he watched his crew succumb, he knew he couldn't allow the strange bulb to reach the coast. It was all the captain could do to alter the ships course so that it would wreck on <ik>Smuggler's Shiv</i> instead of along the populous sargavan coastline. Delirious with fever, the captain's final log states he decided to 'carry the blasphemous pod up to the top of a rock spire on the east of the island,' with an attempt to find a cave where he could hide it away from humanity forever.",
    ]
  },
  {
    id: 17,
    type: "note1",
    name: "Rubbing of the Azlanti Runes in the Temple of Zura",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "Studying these runes is frustrating and difficult to translate because of the missing portions of wall that have cracked, coupled with the ancient inscriber’s fondness for awkward metaphor; however, four key bits of information can be gleaned from these carvings:",
      "This chamber was once a scriptorium where books and scrolls sacred to the worship of Zura were transcribed and illuminated.",
      "This temple was built over an even more ancient temple — one that was dedicated to a deity referred to only as the “Beheaded One,” an entity that was apparently an enemy to the ancient Zura cultists.",
      "Several prayers seem to indicate that the ancients made use of undead slaves created from both “humans culled from the unbelievers and slaves of the Beheaded One.”",
      "As much hatred as the Zura cultists had for the “slaves  of the Beheaded One,” they also seemed to despise their own kind—especially those they called the “misbegotten of Saventh-Yhi.”",
    ]
  },
  {
    id: 18,
    type: "note1",
    name: "Yarzoth's Notes on Saventh-Yhi",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "These notes are written in Aklo but are otherwise quite complete, being a careful translation of the murals above the altar in the temple of Zura:<br><br>",
      "The three large alcoves in this room once served as meditation chambers—the cultists would enter one, pull a curtain for privacy, and recite the complex prayers and parables carved on the walls here. These carvings, all written in Azlanti, tell the history of this particular Zura cult in three stages. ",
      "The southern alcove tells of the cult’s genesis in the city of Saventh-Yhi in the jungle, but is frustratingly vague when it comes to exact details on the legendary city apart from confirming that it was built by Azlanti — this section ends with the cult’s exile from Saventh-Yhi and how they made a dangerous overland journey that ended on the shores of a remote island far from their homeland.",
      "The northwestern alcove takes up the story at this point, detailing the cult’s exploration of this island (identifiable as Smuggler’s Shiv), their discovery and defeat of a large group of serpentfolk who had gone into hiding after the defeat of their kind many years before at Saventh-Yhi, and the creation of this temple. ",
      "The northeastern alcove plots the cult’s future plans, focusing on how they had hoped to earn the gift of vampirism from Zura by undertaking extensive and vile rituals, and once this gift was theirs, how they planned on making the journey back to Saventh-Yhi to 'awaken the city with Zura’s blessing.' The route back to the ancient city is similarly cryptic, and the portions that do make sense reference antiquated geography; however, it seems they ultimately intended to use something called the 'Light of Tazion' to return to the city through its protective wards.<br><br>",
      "In her notes, Yarzoth seems particularly intrigued by the possibility that Saventh-Yhi might be the exact spot where, so long ago, her god Ydersius was beheaded.",
    ]
  },
  {
    id: 19,
    type: "dream1",
    name: "First Nightmare",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "You’re back aboard the <i>Jenivere</i>, bent over the railing being seasick. After your latest bout of retching, you slump back and see the rest of the passengers and crew are on deck as well, all of them sick save for the captain and the quiet Varisian scholar Ieana. She whispers in the captain’s ear, then gives him a kiss on the cheek. At that point the captain holds up a wooden soup spoon, and you realize that you’re holding one as well. Everyone has a spoon. The ship is sinking, and the only way to stop it is to bail out the hold with your spoon! You work feverishly, but the waters keep rushing in. Just before you wake, you can see monstrous things with pincers in the water trying to claw their way into the ship...",
    ]
  },
  {
    id: 20,
    type: "dream1",
    name: "Second Nightmare",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "You’re sitting down in the galley aboard the <i>Jenivere</i>, getting ready for your meal. The ship’s cook has given you a steaming bowl of soup, but you drop your spoon. You see that the deck below is covered with seawater up to your ankles, and your dropped spoon has sunk into the water and washed out to sea through a hole. You’re forced to lift your delicious bowl of soup to your lips and drink. But something big goes into your mouth as you do so, and you feel a sharp bite on your tongue. You drop the bowl, only to reveal a serpent had hidden in your soup that now dangles from your tongue as it chews furiously. You start awake, biting your own tongue in an attempt to bite through the snake’s body.",
    ]
  },
  {
    id: 21,
    type: "dream1",
    name: "Third Nightmare",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "You’re in a rowboat on the open ocean at night. Sitting across you, rowing the boat, is First Mate Alton. He’s obviously dead, with the wounds and stings his body displays on the wreck of the <i>Jenivere</i>, but still he rows. Eventually, the boat reaches an island covered with snakes. Alton waits as you exit the boat, standing ankle-deep in snakes, and then he turns and rows back out to sea, you assume off to look for more survivors to ferry to shore. But Alton never returns, and you wake up just as the snakes start to bite...",
    ]
  },
  {
    id: 22,
    type: "dream1",
    name: "Wings in the Dark",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "You're laying on the floor looking up at the stars. In the sky above you, you note the constellations, counting each one that you know. All at once, a collection of stars form an obvious grouping; as you trace the stars with your eyes, lines form between the stars into the shape of a serpentine skull. Its mouth is open, as though speaking, but you cannot understand its whispers. You listen closer, trying to interpret the darkness it spews. Out of the corner of your eyes, you notice something large with blood-red eyes watching from the jungle's edge, but you cannot move, cannot scream, all that comes out is a rasping hiss...",
    ]
  },
  {
    id: 23,
    type: "magic",
    name: "Atlquipan",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "This golden azlanti serpentine idol appears inanimate, but it eagerly transforms into a <i>+1 monstrous humanoid bane returning trident</i> when grasped, its shaft decorated with the golden serpents twinning along its length. In addition to having the eager perk, it may be drawn as a non-action when initiative is rolled, as it springs into its owners hand, something it occasionally does on its own.",
      "As a standard action, the wielder can wrestle the serpent into twining around the shaft of another held trident or spear. This grants that other spear the <i>monstrous humanoid bane</i> ability; however, once that weapon is thrown, this weapon returns using its <i>returning</i> ability, leaving the weapon it was twined around behind.",
    ]
  },
  {
    id: 24,
    type: "magic",
    name: "Wavecutter",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "This unusual <i>+1 keen steel terbuje is made of sharp chunks of quarts embedded along a length of steel. Wavecutter may be used underwater without suffering any penalties, and its bearer may use attack rolls in place of swim checks to swim underwater.",
    ]
  },
  {
    id: 25,
    type: "magic",
    name: "Savage Sting",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "This +1 seeking blowgun is made of a hollowed piece of reed lacquered in vibrant orange hues and decorated with a fetish of brilliantly colored feathers. Up to three times per day, the wielder may envenom a dart fired from the blowgun with a virulent toxin, which functions as the poison spell.",
    ]
  },
  {
    id: 26,
    type: "magic",
    name: "Orb of the Kindred Flame",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "This glowing red orb acts as a pearl of power level 3, except it is usable up to three times per day and it can only restore spells with the fire descriptor.",
    ]
  },
]
// type must match div names (magic, note1-6, dream1-6)
// img is true if there is an image to display
/*
  {
    id: *,
    type: "*",
    name: "*",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "Placeholder here",
    ]
  },
*/

// Populates loot when called
function populateLoot(type) {

  // constants
  const displayHide = "display: none;";

  // Only generate loot if type matches the type variable
  let filteredLoot = loot.filter(item => item.type === type);

  // If the type variable === "magic", sort loot alphabetically by name
  // if (type === "magic") {
  filteredLoot = filteredLoot.sort((a, b) => a.name.localeCompare(b.name));
  // }

  // for each matching item:
  filteredLoot.forEach(item => {
    const lootContainer = document.querySelector(`#${item.type}`);

    // This constructs the descriptions for each item
    let descriptionsHTML = "";
    item.description.forEach(description => {
      descriptionsHTML += `<li style="${displayHide}">${description}</li>`;
    });

    const lootElement = document.createElement("ul");
    lootElement.classList.add("toggleLiVis");
    lootElement.style.listStyleType = "none";

    // add this to the lootElement:
    lootElement.innerHTML = `
      <li>
        <b>Click to Identify the ${item.name}</b>
      </li>
      <li style="${displayHide}">
        <b><i>${item.name}</i></b>
      </li>
      `;

    // run an if statement that determines if the loot item has an image
    if (item.img === true) {
      lootElement.innerHTML += `
        <li style="${displayHide}">
        <picture>
          <source srcset="${item.src}" type="image/webp">
          <img class="pointer tooTall" src="/serpents/images/unknown.png" alt="${item.name}" loading="lazy">
        </picture>
        </li>
      `;
    }

    // Add the description to the lootElement
    lootElement.innerHTML += `
      <li style="${displayHide}">
        ${descriptionsHTML}
      </li>
      <li style="${displayHide}">
       <br><i>&nbsp;&nbsp;~ Click to put the ${item.name} away...</i>
      </li>
      <li class="clearfix" style="${displayHide}"></li>
    `;

    lootContainer.appendChild(lootElement);
  });

  // Call toggleLiVis after appending the elements
  // toggleLiVis(".toggleLiVis");
}