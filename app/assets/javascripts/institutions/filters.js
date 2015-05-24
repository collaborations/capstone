// Toggle filter button
$("li.toggle > button").on("click", function(){
  btn = $(this);
  id = btn.parent()[0].id.split('-')[1];
  console.log(btn.id);
  buttons = $("li#filter-" + id)[0].children;

  if( btn.hasClass("filter-btn-selected") ){
    btn.removeClass("filter-btn-selected");
    btn.addClass("filter-btn-deselected");
  } else {
    btn.removeClass("filter-btn-deselected");
    btn.addClass("filter-btn-selected");
  }
});

// toggles = $("li.toggle");
// for (var i = 0; i < toggles.length; i++) {
//   var first = toggles[i].children[1];
//   var second = toggles[i].children[2];
//   first.on("click", function() {
//     btn = $(this);
//     if( btn.hasClass("filter-btn-selected") ){
//       btn.removeClass("filter-btn-selected");
//       btn.addClass("filter-btn-deselected");
//     } else {
//       btn.removeClass("filter-btn-deselected");
//       btn.addClass("filter-btn-selected");
//     }

//   });

// }
// console.log(buttons);

// Sort current institutions by name
$("#btn-name").on("click", { selector: ".institution-name" } , sort);
$("#btn-distance").on("click", { selector: ".institution-distance" } , sort);

//Sort the institutions list in the view.
//Call using jQuery and pass in a CSS selector as 'selector'
function sort(event){
  console.log(event.data.selector);

  if(typeof event.data.selector === 'undefined'){
    console.log("Sort method for filters was not called properly. Selector is undefined");
  }
  // var x = event.data.selector.split("-")[1];
  // var button = $("#btn-" + x);
  // button.removeClass("filter-btn-deselected");
  // button.addClass("filter-btn-selected");
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
