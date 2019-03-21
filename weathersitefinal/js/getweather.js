function currentWeather(x) {
    var cid;
    if (x == 1) {cid = 5604473} // preston
    else if (x == 2) {cid = 5678757} // soda springs
    else if (x == 3) {cid = 5585010} // fish haven  
    var weatherObject = new XMLHttpRequest;
    weatherObject.open('GET','//api.openweathermap.org/data/2.5/weather?id=' + cid + '&appid=fb75400a87c1c698878761e1d3548782&units=imperial',true);
    weatherObject.send();
    weatherObject.onload = function pullWeather() {
        var weatherInfo = JSON.parse(weatherObject.responseText);
        console.log(weatherInfo);

        document.getElementById('currentType').innerHTML = weatherInfo.weather[0].description;
        document.getElementById('humidity').innerHTML = Math.round(weatherInfo.main.humidity);
        document.getElementById('lowTemp').innerHTML = Math.round(weatherInfo.main.temp_min);
        document.getElementById('highTemp').innerHTML = Math.round(weatherInfo.main.temp_max);

        var iconcode = weatherInfo.weather[0].icon;
        var icon_path = "//openweathermap.org/img/w/" + iconcode + ".png";
        //document.getElementById('weather_icon').src = icon_path;

        // Feels Like - Wind Chill
        var tempF = parseFloat(weatherInfo.main.temp);
        var windSpeed = parseFloat(weatherInfo.wind.speed);
        var windTemp = 35.74 + (0.6215 * tempF) - (35.75 * (Math.pow(windSpeed, 0.16))) + (0.4275 * tempF * (Math.pow(windSpeed, 0.16)));
        document.getElementById('windChill').innerHTML = Math.round(windTemp, 1)

}} // end of function