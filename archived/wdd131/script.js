function displayGreetings() {
  var name = document.getElementById('name').ariaValueMax;
  document.getElementById('personalGreeting').innerHTML = "Hello, " + name + "! It's a pleasure to meet you! Douzo Yoroshiku Onegaishimasu!";
}
// This function is to prove I can write a basic javascript function including math and a console log.
function testRunning() {
  const apples = 5;
  const oranges = 3;
  let total = apples + oranges;
  console.log("total", total);
}
// This function expands on the prior prove function.
function testRunning2() {
  const myApples = 4;
  const friendApples = 2;
  let total = myApples + friendApples;

  document.getElementById(myAppleElement).textContent = myApples;
  document.getElementById(friendAppleElement).textContent = friendApples;
  document.getElementById(totalApplesElement).textContent = total;
}