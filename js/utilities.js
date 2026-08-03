// This file contains all the utility scripts in one file, copied from my previous work.
// ---------------------------------------------------------------------------------------------

// This block handles the current date and version numbers displayed in the footer.
// [Start Date and Version Block]
const today = new Date();
const yyyy = today.getFullYear();

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
// [End Date and Version Block]

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