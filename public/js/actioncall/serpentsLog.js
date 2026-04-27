// public/js/homeActionCall.js

// Data for THIS page's action call only
const travelLogGroups = [
  {
    label: "Days aboard the <i>Jenivere</i>",
    entries: [
      { label: "In Port at Magnimar, Varisia", days: 2 },
      { label: "In Port at Kintargo, Cheliax", days: 3 },
      { label: "In Port at Pezzack, Cheliax", days: 7 },
      { label: "In Port at Corentyn, Cheliax", days: 2 },
      { label: "In Port at Ilizmagorti, Mediogalti Island", days: 7 },
      { label: "In Port at Ollo, The Shackles", days: 2 },
      { label: "In Port at Quent, The Shackles", days: 3 },
      { label: "In Port at Port Peril, The Shackles", days: 4 },
      { label: "In Port at Bloodcove, Mwangi Expanse", days: 3 },
      { label: "Total Days at Sea", days: 71 }
    ]
  },
  {
    label: "Days Castaway on Smuggler's Shiv",
    entries: [
      { label: "Camping by the Wreckage of the <i>Jenivere</i>", days: 8 },
      { label: "Sheltering in a Serpentine Cave (plus the Typhoon)", days: 12 },
      { label: "Resting under the Banyan Tree", days: 7 },
      { label: "Spelunking the Caves of the Mother and Red Mountain", days: 3 }
    ]
  },
  {
    label: "Days Searching for Saventh-Yhi",
    entries: [
      { label: "Establishing an Expedition", days: 15 },
      { label: "Racing to Kalabuto", days: 18 },
      { label: "Searching for a Moonstone", days: 15 },
      { label: "Winding up the Korrir River", days: 12 },
      { label: "Sailing through the Screaming Jungle", days: 12 },
      { label: "Traveling under the Serpents Pass", days: 9 },
      { label: "Venturing to Tazion", days: 3 },
      { label: "Following the Lights of Tazion", days: 7 }
    ]
  },
  {
    label: "Days exploring Saventh-Yhi",
    entries: [
      { label: "Establishing the First Camp", days: 8 },
      { label: "Claiming the First Spear", days: 7 },
      { label: "Clearing the First Vault", days: 1 },
      { label: "Establishing a Secured Camp on the Cliffs", days: 11 },
      { label: "Establishing Control over 50% of the City", days: 6 },
      { label: "Claiming the Seventh Spear", days: 6 },
      { label: "A Feast with the Gorilla King", days: 2 }
    ]
  }
];

function renderHomeTravelLog(groups) {
  const container = document.querySelector(".actioncall");
  if (!container) return;

  let totalAll = 0;
  let html = `<h2>Travel-Log</h2>`;

  groups.forEach((group, index) => {
    const groupTotal = group.entries.reduce((sum, e) => sum + e.days, 0);
    totalAll += groupTotal;

    html += `
      <div class="collapse-toggle" data-index="${index}">
        <h3 class="collapse-toggle pointer">
          ${group.label} — <span class="ac-total">${groupTotal} days</span>
        </h3>
        <div class="collapse-toggle-content">
          ${group.entries
        .map(e => `<p>${e.label}: ${e.days} days</p>`)
        .join("")}
        </div>
      </div>
    `;
  });

  html += `<p class="ac-grand-total"><strong>Total Journey: ${totalAll} days</strong></p>`;

  container.innerHTML = html;
}

document.addEventListener("DOMContentLoaded", () => {
  renderHomeTravelLog(travelLogGroups);
  makeCollapsible(".collapse-toggle", ".collapse-toggle-content");
});
