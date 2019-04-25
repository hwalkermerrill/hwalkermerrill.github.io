function clickLoad(clickClass) {
  $(clickClass).click(function() {
    $(clickClass).toggleClass( "click" );
  })
}