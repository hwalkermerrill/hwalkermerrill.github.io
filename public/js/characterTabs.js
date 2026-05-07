document.addEventListener("DOMContentLoaded", () => {
  //Constants on Top
  const tabs = document.querySelectorAll(".character-tabs a");
  const searchInput = document.getElementById("characterSearch");
  const sections = document.querySelectorAll(".character-section");

  if (!tabs.length || !searchInput || !sections.length) return;

  function showTab(tab) {
    // Clear search
    searchInput.value = "";

    // Update active tab
    tabs.forEach(t => t.parentElement.classList.remove("active"));
    const activeTab = document.querySelector(`[data-tab="${tab}"]`);
    if (activeTab) activeTab.parentElement.classList.add("active");

    // Show/hide sections
    sections.forEach(section => {
      const sectionType = section.dataset.section;
      const isMatch = (tab === "all" || sectionType === tab);
      section.style.display = isMatch ? "" : "none";

      // Reset card visibility inside visible sections
      section.querySelectorAll(".character-card").forEach(card => {
        card.style.display = "";
      });
    });
  }

  function applySearchFilter() {
    const term = searchInput.value.toLowerCase();

    // If empty, just reapply current tab filter
    if (!term) {
      const activeTab = document.querySelector(".character-tabs li.active a");
      const tab = activeTab ? activeTab.dataset.tab : "all";
      showTab(tab);
      return;
    }

    sections.forEach(section => {
      const cards = section.querySelectorAll(".character-card");
      let anyVisible = false;

      cards.forEach(card => {
        const haystack = (card.dataset.search || "").toLowerCase();
        const matches = haystack.includes(term);

        card.style.display = matches ? "" : "none";
        if (matches) anyVisible = true;
      });

      section.style.display = anyVisible ? "" : "none";
    });
  }

  tabs.forEach(tab => {
    tab.addEventListener("click", e => {
      e.preventDefault();
      showTab(tab.dataset.tab);
    });
  });

  searchInput.addEventListener("input", applySearchFilter);

  // Initial state
  showTab("all");
});
