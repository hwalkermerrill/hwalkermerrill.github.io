var today = new Date();
var dw = today.getDay() + 1;
var dd = today.getDate();
var mm = today.getMonth() + 1;
var yyyy = today.getFullYear();

if (dw < 4) { 
        if (dw == 1) {dw = "Monday"}
    else if (dw == 2) {dw = "Tuesday"}
    else dw = "Wednesday"
    }
    else if (dw < 7) {
        if (dw == 4) {dw = "Thursday"}
        else if (dw == 5) {dw = "Friday"}
        else dw = "Saturday"
    }
    else dw = "Sunday"

if (dd < 10) {
    dd = '0'+dd
} 

if (mm < 4) {
        if (mm == 1) {mm = "January"}
        else if (mm == 2) {mm = "February"}
        else mm = "March"
    }
    else if (mm < 7) {
        if (mm == 4) {mm = "April"}
        else if (mm == 5) {mm = "May"}
        else mm = "June"
    }
    else if (mm < 10) {
        if (mm == 7) {mm = "July"}
        else if (mm == 8) {mm = "August"}
        else mm = "September"
    }
    else if (mm == 11) {mm = "October"}
    else if (mm == 12) {mm = "November"}
    else mm = "December" 

today = dw + ", " + dd + " " + mm + " " + yyyy;
document.write(today);