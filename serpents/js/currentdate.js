// This long section and its related functions creates the current date and version number at the bottom of the page
var today = new Date();
var dw = today.getDay() + 1;
var dd = today.getDate();
var mm = today.getMonth() + 1;
var m2 = mm;
var yyyy = today.getFullYear();
var yy = yyyy - 2000;

if (m2 < 10) { m2 = '0' + m2 }
if (dd < 10) { dd = '0' + dd }

if (dw < 4) {
	if (dw == 1) { dw = "Sunday" }
	else if (dw == 2) { dw = "Monday" }
	else dw = "Tuesday"
}
else if (dw < 7) {
	if (dw == 4) { dw = "Wednesday" }
	else if (dw == 5) { dw = "Thursday" }
	else dw = "Friday"
}
else dw = "Saturday"

if (mm < 4) {
	if (mm == 1) { mm = "January" }
	else if (mm == 2) { mm = "February" }
	else mm = "March"
}
else if (mm < 7) {
	if (mm == 4) { mm = "April" }
	else if (mm == 5) { mm = "May" }
	else mm = "June"
}
else if (mm < 10) {
	if (mm == 7) { mm = "July" }
	else if (mm == 8) { mm = "August" }
	else mm = "September"
}
else if (mm == 11) { mm = "October" }
else if (mm == 12) { mm = "November" }
else mm = "December"

today = dw + ", " + dd + " " + mm + " " + yyyy;
document.write(today);

function minDate(dd, m2, yyyy) {
	minDate = yyyy + "-" + m2 + "-" + dd;
	return minDate;
}

function maxDate(dd, m2, yyyy) {
	yyyy++;
	maxDate = yyyy + "-" + m2 + "-" + dd;
	return maxDate;
}

function writeCurrentVersion() {
	var version = "v1.0." + yy + m2;
	document.write(version);
}

// This next chunk creates a button that returns the user to the top of the page
// #returnTopBtn:
let topbutton = document.getElementById("returnTopBtn");

// When the user scrolls down 20px from the top of the document, show the button
window.onscroll = function () { showTopBtn() };

function showTopBtn() {
	if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
		topbutton.style.display = "block";
	} else {
		topbutton.style.display = "none";
	}
}

// When the user clicks on the button, scroll to the top of the document
function topFunction() {
	document.body.scrollTop = 0; // For Safari
	document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
}

// These two snippets of code saves the user's position on screen when they refresh the page
// Save the scroll position before refresh
window.onbeforeunload = function () {
	localStorage.setItem('scrollPosition', window.scrollY);
};
// Restore the scroll position after refresh
window.onload = function () {
	if (localStorage.getItem('scrollPosition') !== null) {
		window.scrollTo(0, localStorage.getItem('scrollPosition'));
	}
};

