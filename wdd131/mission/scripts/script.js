// This functions toggles the theme between light and dark mode

let themeSelector = document.getElementById("theme");
let logo = document.getElementById("logo");

function changeTheme() {
    let theme = document.getElementById("theme").value;
    if (theme === "dark") {
        document.body.className = "dark";
        document.getElementById("logo").src = "images/byui-logo_white.png";
    } else {
        document.body.className = "light";
        document.getElementById("logo").src = "images/byui-logo_blue.webp";
    }
}
themeSelector.addEventListener("change", changeTheme);