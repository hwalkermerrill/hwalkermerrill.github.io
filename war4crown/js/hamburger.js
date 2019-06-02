function toggleMenu() {
  document.getElementById("primaryNav").classList.toggle("hide");
}
function toggleVisible(className) {
  document.getElementsByClassName(className).classList.toggle("hide");
}
$(window).on("load", function(){
  $("ul").click(function(){
       $("li", this).toggle();
  });
});