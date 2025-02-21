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
  {
    id: 2,
    type: "dream1",
    name: "Placeholder",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "Placeholder here",
    ]
  },
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
  // {
  //   id: 12,
  //   type: "magic",
  //   name: "War Mask of Terror",
  //   img: true,
  //   src: "/serpents/images/loot-war-mask-terror.webp",
  //   description: [
  //     "Shamans and warriors of many of the indigenous tribes of western Garund add to their fierceness and mystique by wearing wooden masks that bear terrifying visages of demonic spirits. A war mask is considered sacred and personal, and is often handed down to the next generation when a wearer dies. Individual masks are often notorious, and many tribesfolk can readily identify masks of other tribes with a DC 15 Knowledge (local) check.",
  //     "A war mask of terror provides its wearer with a +2 competence bonus on Intimidate checks and a +1 deflection bonus to Armor Class. In addition, the wearer may cast scare once per day.",
  //   ]
  // },
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
      "<b>To Command the Very Tides to Rise Up and Eschew What Lies Below:</b>",
      "Empower the Four Sentinel Runes with the Blood of a Thinking Creature Tempered by the Kiss of a Serpent’s Tongue.",
      "Anoint the Tide Stone with Waters Brought from the Sea in a Vessel of Purest Metal.",
      "Invoke the Lord’s Sacred Name to Wrap His Coils around the Sea Itself that He Might Lay Bare What Lies Below and Cast Down Your Enemies on the Waves above.",
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
    let descriptionsHTML = '';
    item.description.forEach(description => {
      descriptionsHTML += `<li style="${displayHide}">${description}</li>`;
    });

    const lootElement = document.createElement('ul');
    lootElement.classList.add('toggleLiVis');
    lootElement.style.listStyleType = 'none';

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