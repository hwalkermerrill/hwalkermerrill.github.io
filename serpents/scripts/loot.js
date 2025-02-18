// This .js is meant to populate the resources and journal with session loot/notes

const loot = [
  {
    id: 1,
    type: "magic",
    name: "Convergent Cocoon Cloak",
    img: true,
    isTall: false,
    src: "/serpents/images/loot-convergent-cloak.webp",
    description: [
      "Placeholder here",
    ]
  },
  {
    id: 2,
    type: "dream1",
    name: "Placeholder",
    img: false,
    isTall: false,
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
    isTall: false,
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
    isTall: false,
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
    isTall: false,
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
    isTall: false,
    src: "/serpents/images/*.webp",
    description: [
      "Placeholder here",
    ]
  },
*/

// constants
const displayHide = "display: none;";

// Populates loot when called
function populateLoot(type) {

  // Only generate loot if type matches the type variable
  let filteredLoot = loot.filter(item => item.type === type);

  // If the type variable === "magic", sort loot alphabetically by name
  if (type === "magic") {
    filteredLoot = filteredLoot.sort((a, b) => a.name.localeCompare(b.name));
  }

  // for each matching item:
  filteredLoot.forEach(item => {
    const lootContainer = document.querySelector(`#${item.type}`);

    // This determines if the image is too tall and needs additional .css
    const imgClass = item.isTall ? "tooTall" : "wide";

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
          <img class="pointer ${imgClass}" src="/serpents/images/unknown.png" alt="${item.name}" loading="lazy">
        </picture>
        </li>
      `;
    }

    // Add the description to the lootElement
    lootElement.innerHTML += `
      <li style="${displayHide}">
        ${item.description}
      </li>
      <li class="clearfix" style="${displayHide}"></li>
    `;

    lootContainer.appendChild(lootElement);
  });

  // Call toggleLiVis after appending the elements
  // toggleLiVis(".toggleLiVis");
}