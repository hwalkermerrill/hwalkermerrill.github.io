function forecastDate(x) {
    var today = new Date();
    var dw = today.getDay() + 1 + x;
    var swap;

    if (dw > 7) {
        swap = dw - 7;
        dw = swap;
    }

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

    document.write(dw);
}