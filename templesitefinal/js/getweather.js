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

        document.getElementById('currentType').innerHTML = weatherInfo.weather[0].description;
        document.getElementById('mainTemp').innerHTML = Math.round(weatherInfo.main.temp);
    }
} // end of function