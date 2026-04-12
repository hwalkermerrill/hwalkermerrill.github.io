document.addEventListener("DOMContentLoaded", () => {
  const gallery = document.querySelectorAll("[data-map-id]");

  gallery.forEach(item => {
    item.addEventListener("click", () => {
      const imageUrl = item.dataset.imageUrl;
      const alt = item.dataset.alt;
      const title = item.dataset.title;

      // Replace main map
      const mainWrapper = document.getElementById("main-map-wrapper");
      mainWrapper.innerHTML = `
        <picture class="lz-wrapper">
          <source srcset="${imageUrl}" type="image/webp">
          <img class="light-zoom" src="${imageUrl}" alt="${alt}">
        </picture>
        <figcaption><strong>${title}</strong></figcaption>
      `;

      // Reinitialize lightzoom
      const img = mainWrapper.querySelector("img.light-zoom");
      lightzoom([img], { // Defined in lightzoom.js
        zoomPower: 2,        // Default = 3
        glassSize: 270,      // Default = 270
        lineWidth: 3,        // Default 3
        lineColor: "magenta" // Default = 'red'
      });

      // Smooth scroll to top
      topFunction(); // Defined in pathfinder.js
    });
  });
});