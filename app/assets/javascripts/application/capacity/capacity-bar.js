var capacities;

window.addEventListener('load', checkForCapacityBar);

function checkForCapacityBar(){
  console.log("Loaded");
  capacities = $(".capacity-bar");
  if(capacities.length > 0){
    getCapacities();
  }
}

function getCapacities(){
  var options = [];
  $.each(capacities, function(k, v){
    var id = v.id.split("-")[1];
    options.push(id);
  });
  console.log(options); 
  var request = $.post( "/capacity/get/ids", { capacity_ids: options }, populateCapacities)
  request.fail(function( jqXHR, textStatus ) {
    alert( "Request failed: " + textStatus );
  });
}

function populateCapacities(response){
  // console.log(response);
  $.each(response, function(k, v){
    id = v.id;
    data = v.data;
    $bar = $("#capacity-" + id);
    $bar.show();
    var filled = 0;
    $.each(data, function(k, prop){
      if(prop.type == 'available'){
        $bar.find("." + prop.type).width(Math.floor(prop.value) + "%").html(prop.value);
      } else {
        filled += prop.value;
      }
    });
    $bar.find(".filled").width(Math.floor(filled) + "%").html(filled);

  });
}
