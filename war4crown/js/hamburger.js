function toggleMenu() {
  document.getElementById("primaryNav").classList.toggle("hide");
}
/*function toggleDiv(x) {
  document.getElementById(x).classList.toggle(x + "hide");
}*/
function toggleClick(x){
  $( x ).click(function() {
    $( this ).toggleClass( "click" );
  });
}