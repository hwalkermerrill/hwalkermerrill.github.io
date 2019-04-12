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
        document.getElementById('mainTemp').innerHTML = Math.round(weatherInfo.main.temp);
    }
} // end of function