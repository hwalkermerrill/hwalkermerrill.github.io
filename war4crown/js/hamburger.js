function toggleMenu() {
  document.getElementById("primaryNav").classList.toggle("hide");
}
function toggleLocked() {
  document.getElementsByClassName("locked").classList.toggle("hide");
}
$(window).on("load", function(){
  $("ul").click(function(){
       $("li", this).toggle();
  });
});