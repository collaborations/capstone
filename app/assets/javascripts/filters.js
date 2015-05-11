// Toggle filter button
$("li.toggle > button").on("click", function(){
  btn = $(this);
  if( btn.hasClass("filter-btn-selected") ){
    btn.removeClass("filter-btn-selected");
    btn.addClass("filter-btn-deselected");
  } else {
    btn.removeClass("filter-btn-deselected");
    btn.addClass("filter-btn-selected");
  }
});

// Sort current institutions by name
$("#btn-name").on("click", { selector: ".institution-name" } , sort);
$("#btn-distance").on("click", { selector: ".institution-distance" } , sort);

function sort(event){
  var map = {};
  var sorted = [];
  
  $.each($(".institution"), function(k, v){
    var name = $(v).find(event.data.selector)[0].innerHTML;
    map[name] = $(v);
    sorted.push(name);
  });
  var container = $("#institutions_list");
  container.empty();
  sorted.sort();
  $.each(sorted, function(k, v){ container.append(map[v]); });
}
