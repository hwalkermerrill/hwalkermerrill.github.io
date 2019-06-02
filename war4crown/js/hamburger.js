function toggleMenu() {
  document.getElementById("primaryNav").classList.toggle("hide");
}
function toggleVisible(className) {
  var elements = document.getElementsByClassName(className);
  n = elements.length;
  for (var i = 0; i < n; i++) {
    var e = elements[i]
    if(e.getElementsByClassName.display == 'block') {
      e.getElementsByClassName.display = 'none';
    } else {
      e.getElementsByClassName.display = 'block';
    }
  }
}
$(window).on("load", function(){
  $("ul").click(function(){
       $("li", this).toggle();
  });
});