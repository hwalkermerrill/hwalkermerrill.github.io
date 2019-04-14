function currentWeather(x) {
    var zip;
    if (x == 1) {zip = 46032} // noblesville indiana
    else if (x == 2) {zip = 96762} // laie hawaii
    else if (x == 3) {zip = 40014} // crestwood kentucky 
    else if (x == 4) {zip = 62354} // nauvoo illinois
    else if (x == 5) {zip = 92374} // redlands california
    else if (x == 6) {zip = 68112} // omaha nebraska
    var weatherObject = new XMLHttpRequest;
    weatherObject.open('GET','//api.openweathermap.org/data/2.5/weather?zip=' + zip + ',us&appid=fb75400a87c1c698878761e1d3548782&units=imperial',true);
    weatherObject.send();
    weatherObject.onload = function pullWeather() {
        var weatherInfo = JSON.parse(weatherObject.responseText);
        console.log(weatherInfo);
        if (weatherInfo.name == "Indianapolis") /* noblesville indiana */ {
            document.getElementById('currentType1').innerHTML = weatherInfo.weather[0].description;
            document.getElementById('mainTemp1').innerHTML = Math.round(weatherInfo.main.temp);
        }
        else if (x == 2) /* laie hawaii */ {
            document.getElementById('currentType2').innerHTML = weatherInfo.weather[0].description;
            document.getElementById('mainTemp2').innerHTML = Math.round(weatherInfo.main.temp);
        }
        else if (x == 3) /* crestwood kentucky */ {
            document.getElementById('currentType3').innerHTML = weatherInfo.weather[0].description;
            document.getElementById('mainTemp3').innerHTML = Math.round(weatherInfo.main.temp);
        }
        else if (x == 4) /* nauvoo illinois */ {
            document.getElementById('currentType4').innerHTML = weatherInfo.weather[0].description;
            document.getElementById('mainTemp4').innerHTML = Math.round(weatherInfo.main.temp);
        }
        else if (x == 5) /* redlands california */ {
            document.getElementById('currentType5').innerHTML = weatherInfo.weather[0].description;
            document.getElementById('mainTemp5').innerHTML = Math.round(weatherInfo.main.temp);
        }
        else if (x == 6) /* omaha nebraska */ {
            document.getElementById('currentType6').innerHTML = weatherInfo.weather[0].description;
            document.getElementById('mainTemp6').innerHTML = Math.round(weatherInfo.main.temp);
        }
    }
} // end of function line