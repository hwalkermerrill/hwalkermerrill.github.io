function currentWeather(x){
    var cid
    if (x == 1) {cid = 5604473} // preston
    else if (x == 2) {cid = 5678757} // soda springs
    else if (x == 3) {cid = 5585010} // fish haven  
    var weatherObject = new XMLHttpRequest;
    weatherObject.open('GET','//api.openweathermap.org/data/2.5/weather?id=' + cid + ',us&appid=fb75400a87c1c698878761e1d3548782&units=imperial',true);
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

}} // end of function