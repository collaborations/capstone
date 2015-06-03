// Sort current institutions by name
$("#btn-name").on("click", { selector: ".institution-name" } , sort);
$("#btn-distance").on("click", { selector: ".institution-distance" } , sort);
//Sort the institutions list in the view.
//Call using jQuery and pass in a CSS selector as 'selector'
function sort(event){
  var map = {};
  var sorted = [];
  
  $.each($(".institution"), function(k, v){
    if(event.data.selector == ".institution-distance"){
      var name = parseFloat($(v).find(event.data.selector)[0].innerHTML);
      console.log(name);
    }else{
      var name = $(v).find(event.data.selector)[0].innerHTML;
    }
    map[name] = $(v);
    sorted.push(name);
  });
  var container = $("#institutions_list");
  container.empty();
  if(event.data.selector == ".institution-distance"){
    sorted.sort(function(a,b) { return a - b;});
  }else{
    sorted.sort();
  }
  $.each(sorted, function(k, v){ container.append(map[v]); });
}


$(document).foundation({
  accordion: {
    // specify the class used for accordion panels
    content_class: 'content',
    // specify the class used for active (or open) accordion panels
    active_class: 'active',
    // allow multiple accordion panels to be active at the same time
    multi_expand: true,
    // allow accordion panels to be closed by clicking on their headers
    // setting to false only closes accordion panels when another is opened
    toggleable: true
  }
});