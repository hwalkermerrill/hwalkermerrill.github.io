// Recap Switcher
function initSessionRecapSwitcher() {
	const items = document.querySelectorAll(".session-log-list-item");
	const recapContainer = document.getElementById("session-recap-content");

	if (!recapContainer) return;

	items.forEach(item => {
		item.addEventListener("click", () => {
			const title = item.dataset.title;
			const timeSpan = item.dataset.timeSpan;
			const sessionDate = item.dataset.sessionDate;
			const paragraphs = JSON.parse(item.dataset.paragraphs || "[]");
			const images = JSON.parse(item.dataset.images || "[]");

			// Scroll to recap
			document.getElementById("session-recap").scrollIntoView({ behavior: "smooth" });

			// Replace content
			recapContainer.innerHTML = "";

			const h3 = document.createElement("h3");
			h3.innerHTML = title;  // SECURITY NOTE: This requires the backend to sanitize text to prevent XSS
			recapContainer.appendChild(h3);

			if (timeSpan) {
				const p = document.createElement("p");
				p.innerHTML = `<strong>Time Span:</strong> ${timeSpan}`;
				recapContainer.appendChild(p);
			}

			if (sessionDate) {
				const p = document.createElement("p");
				p.innerHTML = `<strong>Session Date:</strong> ${sessionDate}`;
				recapContainer.appendChild(p);
			}

			// Render ALL images
			images.forEach(imgData => {
				const picture = document.createElement("picture");

				const source = document.createElement("source");
				source.srcset = imgData.url;
				source.type = "image/webp";

				const img = document.createElement("img");
				img.src = "/images/core/unknown.png";
				img.dataset.src = imgData.url;
				img.alt = imgData.alt || "Session Image";
				img.className = `pointer ${imgData.tall ? "tooTall" : "wide"}`;
				img.loading = "lazy";

				picture.appendChild(source);
				picture.appendChild(img);
				recapContainer.appendChild(picture);
			});

			// Render paragraphs
			paragraphs.forEach(text => {
				const p = document.createElement("p");
				p.innerHTML = text; // SECURITY NOTE: This requires the backend to sanitize text to prevent XSS
				recapContainer.appendChild(p);
			});
		});
	});
}

// Journal Tabs
function initJournalTabs() {
	const tabs = document.querySelectorAll(".journal-tabs a");
	const sections = document.querySelectorAll(".journal-tab");
	const searchInput = document.getElementById("journalSearch");

	if (!tabs.length || !sections.length) return;

	// Tab switching
	tabs.forEach(tab => {
		tab.addEventListener("click", (e) => {
			e.preventDefault();

			const target = tab.dataset.tab;

			// Update active tab
			tabs.forEach(t => t.parentElement.classList.remove("active"));
			tab.parentElement.classList.add("active");

			// Show correct section
			sections.forEach(section => {
				section.classList.toggle("active", section.id === target);
			});
		});
	});

	// Search filtering
	if (searchInput) {
		searchInput.addEventListener("input", () => {
			const query = searchInput.value.toLowerCase();

			document.querySelectorAll(
				".note-entry, .session-entry, .lore-entry"
			).forEach(entry => {
				const text = entry.dataset.search?.toLowerCase() || "";
				entry.style.display = text.includes(query) ? "" : "none";
			});
		});
	}
}

// Dom Content Loaded
document.addEventListener("DOMContentLoaded", () => {
	// Item body parsing
	document.querySelectorAll(".item-body").forEach(li => {
		const raw = li.dataset.body;
		if (!raw) return;

		let text;
		try {
			text = JSON.parse(raw);
		} catch {
			text = "";
		}

		const lines = text.split("\n").filter(l => l.trim() !== "");
		li.innerHTML = lines.map(line => `<p>${line}</p>`).join("");
	});

	toggleLiVis(".toggleLiVis"); // Defined in pathfinder.js
	initJournalTabs();
	initSessionRecapSwitcher();
});