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
    name: "Placeholder",
    img: false,
    src: "/serpents/images/placeholder.webp",
    description: [
      "Placeholder here",
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
]
// type must match div names (magic, note1-6, dream1-6)
// img is true if there is an image to display
/*
  {
    id: *,
    type: "*",
    name: "*",
    img: true,
    src: "/serpents/images/*.webp",
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
  if (type === "magic") {
    filteredLoot = filteredLoot.sort((a, b) => a.name.localeCompare(b.name));
  }

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
        <b>Click to Read ${item.name}</b>
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
      <li class="clearfix" style="${displayHide}"></li>
    `;

    lootContainer.appendChild(lootElement);
  });

  // Call toggleLiVis after appending the elements
  // toggleLiVis(".toggleLiVis");
}