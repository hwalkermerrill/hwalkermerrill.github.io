// public/js/homeActionCall.js

// Data for THIS page's action call only
const castGroups = [
  {
    label: "Benjamin Hebert",
    entries: [
      { label: "Ezekiel Thorne" },
      { label: "Johnathan 'The Lion Slayer' Kieran" },
      { label: "Antonio" },
      { label: "Antonio - The Clockwork Servant" }
    ]
  },
  {
    label: "Daniel Hutchinson",
    entries: [
      { label: "Ivy Whitebriar" }
    ]
  },
  {
    label: "Emma Hutchinson",
    entries: [
      { label: "Astra" },
      { label: "Alhemija" },
      { label: "Bellah" }
    ]
  },
  {
    label: "Mike Hutchinson",
    entries: [
      { label: "Loric Tidewalker" }
    ]
  },
  {
    label: "Alice Merrill",
    entries: [
      { label: "Dakota Ravenwood" }
    ]
  },
  {
    label: "Nick Inglss",
    entries: [
      { label: "Avarice de tu Sinclaire" },
      { label: "Mortimer" }
    ]
  },
];

function renderActionCall(groups) {
  const container = document.querySelector(".actioncall");
  if (!container) return;

  // let totalAll = 0;
  let html = `<h2>Starring</h2>`;

  groups.forEach((group, index) => {
    // const groupTotal = group.entries.reduce((sum, e) => sum + e.days, 0);
    // totalAll += groupTotal;

    html += `
      <div class="collapse-toggle" data-index="${index}">
        <h3 class="collapse-toggle pointer">
          ${group.label} — <span class="ac-total"></span>
        </h3>
        <div class="collapse-toggle-content">
          ${group.entries
        .map(e => `<p>${e.label}: ${e.days} days</p>`)
        .join("")}
        </div>
      </div>
    `;
  });

  // html += `<p class="ac-grand-total"><strong>Total Journey: ${totalAll} days</strong></p>`;

  container.innerHTML = html;
}

document.addEventListener("DOMContentLoaded", () => {
  renderActionCall(castGroups);
  makeCollapsible(".collapse-toggle", ".collapse-toggle-content"); // eslint-ignore
});
