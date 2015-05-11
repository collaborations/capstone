// Toggle filter button
$("li.filter > button").on("click", function(){
  btn = $(this);
  if( btn.hasClass("filter-btn-selected") ){
    btn.removeClass("filter-btn-selected");
    btn.addClass("filter-btn-deselected");
  } else {
    btn.removeClass("filter-btn-deselected");
    btn.addClass("filter-btn-selected");
  }
})
