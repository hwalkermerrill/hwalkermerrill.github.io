// This file contains all the js code for written for pathfinder sites in one file.
// ---------------------------------------------------------------------------------------------

// This block handles the current date and version numbers displayed in the footer.
// [Start Date and Version Block]
const today = new Date();
const yyyy = today.getFullYear();
const versionIteration = "v1.6.2."

function writeLongDate() { // eslint-disable-line no-unused-vars
	let dwArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
	let mmArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

	let dw = dwArray[today.getDay()];
	let mm = mmArray[today.getMonth()];
	let dd = today.getDate();
	if (dd < 10) { dd = "0" + dd }

	let longDate = `${dw}, ${dd} ${mm} ${yyyy}`;
	document.getElementById("longDate").textContent = longDate;
}

function writeCurrentVersion() { // eslint-disable-line no-unused-vars
	let yy = yyyy.toString().slice(2);
	let mn = today.getMonth() + 1;
	if (mn < 10) { mn = "0" + mn }

	let versionNumber = versionIteration + yy + mn;
	document.getElementById("versionNumber").textContent = versionNumber;
}
// [End Date and Version Block]

// These next two are depreciated but preserved for reference.
/*function minDate(dd, m2, yyyy) {
		minDate = yyyy + "-" + m2 + "-" + dd;
		return minDate;
}
function maxDate(dd, m2, yyyy) {
		yyyy++;
		maxDate = yyyy + "-" + m2 + "-" + dd;
		return maxDate;
}*/

// This creates a dropdown hamburger menu
function toggleMenu() { // eslint-disable-line no-unused-vars
	document.getElementById("primaryNav").classList.toggle("hide");
}

// This allows the user to hide all elements of a specific class (like 'locked')
function toggleVisible(className) { // eslint-disable-line no-unused-vars
	document.getElementsByClassName(className).classList.toggle("hide");
}

// This next block creates a button that returns the user to the top of the page.
// [START #returnTopBtn BLOCK]

// When the user scrolls down 720px from the top of the document, show the button
function showTopBtn() {
	const topButton = document.getElementById("returnTopBtn");
	if (document.body.scrollTop > 720 || document.documentElement.scrollTop > 720) {
		topButton.style.display = "block";
	} else {
		topButton.style.display = "none";
	}
}
window.onscroll = function () { showTopBtn() };

// When the user clicks on the button, scroll to the top of the document.
function topFunction() { // eslint-disable-line no-unused-vars
	document.body.scrollTop = 0; // For Safari
	document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
}
// [End #returnTopBtn Block]

// These two snippets of code saves the user's position on screen when they refresh the page.
// Save the scroll position before refresh
window.onbeforeunload = function () {
	localStorage.setItem("scrollPosition", window.scrollY);
};
// Restore the scroll position after refresh
window.onload = function () {
	if (localStorage.getItem("scrollPosition") !== null) {
		window.scrollTo(0, localStorage.getItem("scrollPosition"));
	}
};

// The next few functions toggle displayed content on the page:
// [Begin Toggle Block]

// This function toggles the class "click" on the clicked element.
// Call the script with something like this:
// <script>
// document.addEventListener("DOMContentLoaded", function () {
// clickLoad("section");
// });
// </script>
function clickLoad(clickClass) { // eslint-disable-line no-unused-vars
	document.querySelectorAll(clickClass).forEach(element => {
		element.addEventListener("click", function () {
			this.classList.toggle("click");
		});
	});
}

// This function toggles the visibility of select classes.
// Call the script with something like this:
// <button onclick="toggleHide('.helpful')">Show/Hide Helpful NPC's</button>
function toggleHide(className) { // eslint-disable-line no-unused-vars
	document.querySelectorAll(className).forEach(element => {
		const currentDisplay = getComputedStyle(element).display;
		element.style.display = currentDisplay === "none" ? "block" : "none";
	});
}

// This causes ul and ol elements (li) to with the specified class to toggle on and off when clicked.
// Call the script with something like this:
// <script>
// 	document.addEventListener("DOMContentLoaded", function () {
// 		toggleLiVis(".toggleLiVis");
// 	});
// </script>
function toggleLiVis(className) { // eslint-disable-line no-unused-vars
	document.querySelectorAll(className).forEach(element => {
		element.addEventListener("click", function () {
			this.querySelectorAll("li").forEach(li => {
				const currentDisplay = getComputedStyle(li).display;
				li.style.display = currentDisplay === "none" ? "list-item" : "none";
			});
		});
	});
}

// This function auto-loads and turns a series of images into an automatically rotating carousel.
// Apply this function by adding 'id="slideshow"' to a figure, and then loading multiple src's into the figure.
document.addEventListener("DOMContentLoaded", function () {
	const images = document.querySelectorAll("#slideshow img");
	let index = 0;

	if (images.length > 1) {
		images.forEach((img, i) => {
			if (i > 0) img.style.display = "none"; // Hide all images except the first
		});

		setInterval(() => {
			images[index].style.display = "none";
			index = (index + 1) % images.length; // Move to the next image
			images[index].style.display = "block";
		}, 4000);
	}
});


// The below three functions all operate the .viewer modular image viewer class.
// [Start .viewer Block]

// This function defines the actions of the event listener for .viewer
function listenViewer(event) {
	if (
		event.target.matches(".close-viewer") ||
		!event.target.closest("img")
	) { closeViewer(); }
}

// Call this function with an onclick="viewHandler(event)"
function viewHandler(event) { // eslint-disable-line no-unused-vars
	// Error solve: Stop the event from bubbling up to avoid immediate closure
	event.stopPropagation();
	// 1. Create a variable to hold the element that was clicked on from event.target
	let clickedElement = event.target;
	// 2. If statement allows the function to work on figures with embedded imgs
	if (clickedElement.tagName.toLowerCase() === "img") {
		// 3. Get the attribute's from the img element
		let src, alt;
		// Check if the clickedElement is an image within a picture element
		if (clickedElement.parentElement.tagName.toLowerCase() === "picture") {
			let pictureElement = clickedElement.parentElement;
			let sourceElement = pictureElement.querySelector("source");

			// If the source element exists and has a srcset attribute, use it
			if (sourceElement && sourceElement.hasAttribute("srcset")) {
				src = sourceElement.getAttribute("srcset");
			} else {
				src = clickedElement.getAttribute("src");
			}
			// Otherwise, use clickedElement's src attribute 
		} else {
			src = clickedElement.getAttribute("src");
		}
		alt = clickedElement.getAttribute("alt");

		// 4. USe the below to alter the path of the src, if needed
		// let srcParts = ogSrc.split('-');
		// let newSrc = srcParts[0] + '-full.jpeg';

		// 5. Insert the viewerTemplate into the top of the body element
		document.body.insertAdjacentHTML(
			"afterbegin", `<div class="viewer" id="active-viewer">
            <button class="close-viewer" id="close-viewer">X</button>
            <img src="${src}" alt="${alt}">
            </div>`
		);

		// Add the event listener for closing the viewer after a slight delay
		setTimeout(() => {
			document.addEventListener("click", listenViewer, false);
		}, 100);
	}
}

// This function is necessary to be able to close the viewer element
function closeViewer() {
	let viewer = document.getElementById("active-viewer");
	if (viewer) {
		viewer.remove();
		document.removeEventListener("click", listenViewer, false)
	}
}

// [End .viewer Block]
// [End Toggle Block]