var weatherObject = new XMLHttpRequest;
weatherObject.open('GET','//api.openweathermap.org/data/2.5/weather?zip=02111,us&appid=fb75400a87c1c698878761e1d3548782&units=imperial',true);

weatherObject.send();

weatherObject.onload = function() {
    var weatherInfo = JSON.parse(weatherObject.responseText);
    console.log(weatherInfo);

    document.getElementById('place').innerHTML = weatherInfo.name;
    document.getElementById('currentTemp').innerHTML = weatherInfo.main.temp;
    document.getElementById('currentWind').innerHTML = weatherInfo.wind.speed;

    var iconcode = weatherInfo.weather[0].icon;
    var icon_path = "//openweathermap.org/img/w/" + iconcode + ".png";
    document.getElementById('weather_icon').src = icon_path;

} // end of function