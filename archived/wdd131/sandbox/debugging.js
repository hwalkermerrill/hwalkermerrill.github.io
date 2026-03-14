const PI = 3.14;
let area = 0;
function circleArea(radius) {
    const area = radius * PI;
    return area
}
area = circleArea(3);
console.log("Area1:", area);
// Area 4
area = circleArea(4);
console.log("Area2:", area);