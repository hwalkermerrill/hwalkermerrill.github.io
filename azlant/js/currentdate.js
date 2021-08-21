var today = new Date();
var dw = today.getDay() + 1;
var dd = today.getDate();
var mm = today.getMonth() + 1;
var m2 = mm;
var yyyy = today.getFullYear();
var yy = yyyy - 2000;

if (m2 < 10) {m2 = '0' + m2}
if (dd < 10) {dd = '0'+dd} 

if (dw < 4) { 
  if (dw == 1) {dw = "Sunday"}
  else if (dw == 2) {dw = "Monday"}
  else dw = "Tuesday"
}
else if (dw < 7) {
  if (dw == 4) {dw = "Wednesday"}
  else if (dw == 5) {dw = "Thursday"}
  else dw = "Friday"
}
else dw = "Saturday"

if (mm < 4) {
  if (mm == 1) {mm = "January"}
  else if (mm == 2) {mm = "February"}
  else mm = "March"
}
else if (mm < 7) {
  if (mm == 4) {mm = "April"}
  else if (mm == 5) {mm = "May"}
  else mm = "June"
}
else if (mm < 10) {
  if (mm == 7) {mm = "July"}
  else if (mm == 8) {mm = "August"}
  else mm = "September"
}
else if (mm == 11) {mm = "October"}
else if (mm == 12) {mm = "November"}
else mm = "December" 

today = dw + ", " + dd + " " + mm + " " + yyyy;
document.write(today);

function minDate(dd,m2,yyyy){
  minDate = yyyy + "-" + m2 + "-" + dd;
  return minDate;
}

function maxDate(dd,m2,yyyy){
  yyyy++;
  maxDate = yyyy + "-" + m2 + "-" + dd;
  return maxDate;
}

function writeCurrentVersion(){
  var version = "v1.22." + yy + m2;
  document.write(version);
}