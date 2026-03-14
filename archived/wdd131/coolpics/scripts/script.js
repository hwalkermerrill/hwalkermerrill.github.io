// This creates a dropdown hamburger menu
function toggleMenu() {
	document.getElementById("primaryNav").classList.toggle("hide");
}


// The below few functions all operate the .viewer class modular image viewer.
// This creates the template for the viewer class
function viewerTemplate(src, alt) {
	return `<div class="viewer" id="active-viewer">
      <button class="close-viewer" onclick="closeViewer()">X</button>
      <img src="${src}" alt="${alt}">
      </div>`;
}

// This function creates the .viewer class content
function viewHandler(event) {
	// 1. Create a variable to hold the element that was clicked on from event.target
	let clickedElement = event.target;

	if (clickedElement.tagName.toLowerCase() === 'img') {
		// 2. Get the src attribute from that element and 'split' it on the "-"
		let ogSrc = clickedElement.getAttribute('src');
		let alt = clickedElement.getAttribute('alt');
		let srcParts = ogSrc.split('-');

		// 3. Construct the new image file name by adding "-full.jpeg" to the first part of the array from the previous step
		let newSrc = srcParts[0] + '-full.jpeg';

		// 4. Insert the viewerTemplate into the top of the body element
		document.body.insertAdjacentHTML('afterbegin', viewerTemplate(newSrc, alt));

		// 5. Add a listener to the close button (X) that calls a function called closeViewer when clicked
		// document.getElementById('close-viewer').addEventListener('click', closeViewer);
	}
}

function closeViewer() {
	let viewer = document.getElementById('active-viewer');
	if (viewer) {
		viewer.remove();
	}
}

// // Get the .gallery section
// const gallery = document.querySelector('.gallery');

// // Add a click event listener to the .gallery section
// gallery.addEventListener('click', viewHandler);