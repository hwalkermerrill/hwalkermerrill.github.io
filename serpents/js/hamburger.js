function toggleMenu() {
  document.getElementById("primaryNav").classList.toggle("hide");
}
/*function toggleVisible(className) {
  className = className 
  document.getElementsByClassName("locked").classList.toggle("hide");
}*/
$(window).on("load", function(){
  $("ul").click(function(){
       $("li", this).toggle();
  });
});
$(window).on("load", function(){
  $("ol").click(function(){
       $("li", this).toggle();
  });
});