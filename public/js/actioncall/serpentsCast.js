// public/js/homeActionCall.js

// Data for THIS page's action call only
const castGroups = [
  {
    label: "Benjamin Hebert",
    entries: [
      { label: "Ezekiel Thorne (Lv 1 → 2)" },
      { label: "Johnathan 'The Lion Slayer' Kieran (Lv 1 → 2)" },
      { label: "Antonio (Lv 1 → 2)" },
      { label: "Antonio – The Clockwork Servant (Lv 1 → 2)" }
    ]
  },
  {
    label: "Daniel Hutchinson",
    entries: [
      { label: "Ivy Whitebriar (Lv 1 → 2)" }
    ]
  },
  {
    label: "Emma Hutchinson",
    entries: [
      { label: "Astra (Lv 1 → 2)" },
      { label: "Alhemija (Lv 1 → 2)" },
      { label: "Bellah (Lv 1 → 2)" }
    ]
  },
  {
    label: "Mike Hutchinson",
    entries: [
      { label: "Loric Tidewalker (Lv 1 → 2)" }
    ]
  },
  {
    label: "Alice Merrill",
    entries: [
      { label: "Dakota Ravenwood (Lv 1 → 2)" }
    ]
  },
  {
    label: "Nick Inglss",
    entries: [
      { label: "Avarice de tu Sinclaire (Lv 1 → 2)" },
      { label: "Mortimer (Lv 1 → 2)" }
    ]
  }
];

function renderCastActionCall(groups) {
  const container = document.querySelector("#cast-container");
  if (!container) return;

  let html = "";

  groups.forEach((group, index) => {
    const count = group.entries.length;

    html += `
      <div class="collapse-toggle" data-index="${index}">
        <h4 class="pointer">
          ${group.label} — <span class="ac-total">${count} character${count !== 1 ? "s" : ""}</span>
        </h4>

        <div class="collapse-toggle-content">
          ${group.entries
        .map(e => `<p>${e.label}</p>`)
        .join("")}
        </div>
      </div>
    `;
  });

  container.innerHTML = html;
}

document.addEventListener("DOMContentLoaded", () => {
  renderCastActionCall(castGroups);
  makeCollapsible(".collapse-toggle", ".collapse-toggle-content");
});
