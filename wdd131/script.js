function displayGreetings() {
  document.getElementById('personalGreeting').innerHTML = "Hello, " + localStorage.getItem("name") + "! It's a pleasure to meet you! Douzo Yoroshiku Onegaishimasu!";
}