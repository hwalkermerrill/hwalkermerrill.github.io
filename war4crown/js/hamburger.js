function toggleMenu() {
  document.getElementById("primaryNav").classList.toggle("hide");
}
$(window).on("load", function(){
  $("ul").click(function(){
       $("li", this).toggle();
  });
});