// This file contains all the js code for written for pathfinder sites in one file.
// ---------------------------------------------------------------------------------------------

// This block handles the current date and version numbers displayed in the footer.
// [Start Date and Version Block]
const today = new Date();
const yyyy = today.getFullYear();
const versionIteration = "v1.6.2."

function writeLongDate() {
    let dwArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    let mmArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

    let dw = dwArray[today.getDay()];
    let mm = mmArray[today.getMonth()];
    let dd = today.getDate();
    if (dd < 10) { dd = '0' + dd }

    let longDate = dw + ", " + dd + " " + mm + " " + yyyy;
    document.write(longDate);
}

function writeCurrentVersion() {
    let yy = yyyy.toString().slice(2);
    let mn = today.getMonth() + 1;
    if (mn < 10) { mn = '0' + mn }

    let versionNumber = versionIteration + yy + mn;
    document.write(versionNumber);
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
function toggleMenu() {
    document.getElementById("primaryNav").classList.toggle("hide");
}

// This allows the user to hide all elements of a specific class (like 'locked')
function toggleVisible(className) {
    document.getElementsByClassName(className).classList.toggle("hide");
}

// This next block creates a button that returns the user to the top of the page.
// [START #returnTopBtn BLOCK]
let topButton = document.getElementById("returnTopBtn");

// When the user scrolls down 20px from the top of the document, show the button
function showTopBtn() {
    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
        topButton.style.display = "block";
    } else {
        topButton.style.display = "none";
    }
}
window.onscroll = function () { showTopBtn() };

// When the user clicks on the button, scroll to the top of the document.
function topFunction() {
    document.body.scrollTop = 0; // For Safari
    document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
}
// [End #returnTopBtn Block]

// These two snippets of code saves the user's position on screen when they refresh the page.
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

// These following code snippets require the jQuerry library to be loaded in the html file.
// CDL: <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
// ---------------------------------------------------------------------------------------------

// This function toggles the class "click" on the clicked element.
// Use this function to change the appearance of something when clicked.
// Call the script with something like this:
// {<script>$(document).ready(clickLoad('section'))</script>}
function clickLoad(clickClass) {
    $(clickClass).click(function () {
        $(this).toggleClass("click");
    })
}

// This function toggles the visibility of select classes.
//Call the script with something like this:
// <button onclick="toggleHide('.helpful')">Show/Hide Helpful NPC's</button>
function toggleHide(className) {
    $(className).toggle();
};

// This causes ul and ol elements (li) to with the specified class to toggle on and off when clicked.
// Call the script with something like this:
//<script>$(document).ready(toggleLiVis(".toggleLi"))</script>
function toggleLiVis(className) {
    $(className).click(function () {
        $("li", this).toggle();
    });
}

// This function auto-loads and turns a series of images into an automatically rotating carousel.
// Apply this function by adding 'id="slideshow"' to a figure, and then loading multiple src's into the figure.
$(function () {
    $('#slideshow img:gt(0)').hide();
    setInterval(function () {
        $('#slideshow :first-child')
            .fadeOut(1000)
            .next('img')
            .fadeIn(1000)
            .end()
            .appendTo('#slideshow');
    }, 4000);
});