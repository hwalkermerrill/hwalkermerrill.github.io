document.addEventListener("DOMContentLoaded", () => {
  // Initialize lightzoom on initial main map
  const initialImg = document.querySelector("#main-map-wrapper img.light-zoom");
  if (initialImg && window.lightzoom) {
    window.lightzoom([initialImg], {
      zoomPower: 2,
      glassSize: 270,
      lineWidth: 3,
      lineColor: "magenta"
    });
  }

  // Attach click handlers to gallery figures
  const figures = document.querySelectorAll("figure[data-map-id]");
  figures.forEach(fig => {
    fig.addEventListener("click", () => {
      const imageUrl = fig.dataset.imageUrl;
      const alt = fig.dataset.alt;
      const title = fig.dataset.title;

      const mainWrapper = document.getElementById("main-map-wrapper");
      if (!mainWrapper) return;

      mainWrapper.innerHTML = `
        <picture class="lz-wrapper">
          <source srcset="${imageUrl}" type="image/webp">
          <img class="light-zoom" src="${imageUrl}" alt="${alt}">
        </picture>
        <figcaption><strong>${title}</strong></figcaption>
      `;

      // Reinitialize lightzoom
      const newImg = mainWrapper.querySelector("img.light-zoom");
      if (newImg && window.lightzoom) {
        window.lightzoom([newImg], { // Defined in lightzoom.js
          zoomPower: 2,        // Default = 3
          glassSize: 270,      // Default = 270
          lineWidth: 3,        // Default 3
          lineColor: "magenta" // Default = 'red'
        });
      }

      // Smooth scroll to top
      if (typeof topFunction === "function") {
        topFunction(); // Defined in pathfinder.js
      } else {
        window.scrollTo({ top: 0, behavior: "smooth" });
      }
    });
  });
});