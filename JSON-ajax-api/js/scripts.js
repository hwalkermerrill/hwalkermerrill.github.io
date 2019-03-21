var weatherObject = new XMLHttpRequest;
weatherObject.open('GET','http://api.openweathermap.org/data/2.5/weather?zip=84653,us&appid=fb75400a87c1c698878761e1d3548782&units=imperial',true);

weatherObject.send();

weatherObject.onload = function() {
    var weatherInfo = JSON.parse(weatherObject.responseText);
    console.log(weatherInfo);

} // end of function