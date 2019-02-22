function windchill(tempF, speed){
    var windTemp = 35.74 + (0.6215 * tempF) - (35.75 * (Math.pow(speed, 0.16))) + (0.4275 * tempF * (Math.pow(speed, 0.16)));
    document.write(windTemp);