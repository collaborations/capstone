// Add toggle
$("button.filter").on("click", function(){
  btn = $(this);
  btn.toggleClass("selected");
  if( btn.hasClass("selected") ){
    btn.removeClass("selected");
  } else {
    btn.addClass("selected");
  }
})
