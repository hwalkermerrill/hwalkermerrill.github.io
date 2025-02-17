// Imported from WDD 131

const steps = ["one", "two", "three"];
const grades = ["A", "B", "A"]
const listTemplate = (step) => `${step}`;

const stepsHtml = steps.map(listTemplate);
document.querySelector("#myList").innerHTML = stepsHtml.join();

function convertGradeToPoints(grade) {
  let points = 0;
  if (grade === "A") {
    points = 4;
  } else if (grade === "B") {
    points = 3;
  }
  return points;
}
const gpaPoints = grades.map(convertGradeToPoints);
const gpa = gpaPoints.reduce((total, item) => total + item) / gpaPoints.length;

// let new_array = arr.map(function callback(currentValue[, index[, array]]) {
//     // return element for new_array
//   }[, thisArg])