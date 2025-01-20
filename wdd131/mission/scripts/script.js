// This functions toggles the theme between light and dark mode

// This section defines variables to make the function easier to read.
let themeSelector = document.getElementById("theme");
let logo = document.getElementById("logo");

function changeTheme() {
    let theme = themeSelector.value;
    // This loop swaps the documents theme to dark if selected, otherwise it leaves it light.
    if (theme === "dark") {
        document.body.className = "dark";
        logo.src = "images/byui-logo_white.png";
    } else {
        document.body.className = "light";
        logo.src = "images/byui-logo_blue.webp";
    }
}
themeSelector.addEventListener("change", changeTheme);