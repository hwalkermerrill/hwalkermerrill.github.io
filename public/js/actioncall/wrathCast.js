// Data for THIS page's action call only
const castGroups = [
	{
		label: "Benjamin Bricker",
		entries: [
			{ label: "Palamedes (Lv 1 → ?)" }
		]
	},
	{
		label: "Ruben Escobar",
		entries: [
			{ label: "Palamedes (Lv 1 → ?)" }
		]
	},
	{
		label: "Benjamin Hebert",
		entries: [
			{ label: "Ravamir Briarstride (Lv 1 → ?)" }
		]
	},
	{
		label: "Mike Hutchinson",
		entries: [
			{ label: "Dorian Kalder (Lv 1 → ?)" }
		]
	},
	{
		label: "Nickolas Iglesias",
		entries: [
			{ label: "Bukka (Lv 1 → ?)" }
		]
	},
	{
		label: "Nick Inglss",
		entries: [
			{ label: "Syre Forvirre (Lv 1 → ?)" }
		]
	},
	{
		label: "Alice Merrill",
		entries: [
			{ label: "Serenity Dragomir (Lv 1 → ?)" }
		]
	}
	// {
	// 	label: "Harrison Merrill",
	// 	entries: [
	// 		{ label: "Game Master" }
	// 	]
	// }
];

function renderCastActionCall(groups) {
	const container = document.querySelector("#cast-container");
	if (!container) return;

	let html = "";

	groups.forEach((group, index) => {
		const count = group.entries.length;

		html += `
      <div class="collapse-toggle" data-index="${index}">
        <h6 class="pointer">
          ${group.label} — <span class="ac-total">${count} pc${count !== 1 ? "s" : ""}</span>
        </h6>

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