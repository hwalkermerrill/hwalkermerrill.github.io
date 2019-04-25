function clickLoad(clickClass) {
  $(clickClass).click(function() {
    $(this).toggleClass( "click" );
  })
}