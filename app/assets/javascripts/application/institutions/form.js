if($("#institutions_edit").length || $("#institutions_new").length){
  initialize();
}

function initialize(){
  $("#form-general").find("input").on('change', function(){ $("#form-general-save").show() });
  $("#form-location").find("input").on('change', function(){ $("#form-location-save").show() });
  $("#form-amenities").find("input").on('change', function(){ $("#form-amenities-save").show() });

  var requestURL = "http://localhost:3000/amenities/institutions/" + window.location.pathname.split("/")[2].toString();
  console.log(typeof requestURL);
  $.get(requestURL, populateAmenities);
  // $("#form-amenities-save").on('click', saveAmenities);
  // $("#form-restrictions-save").on('click', saveRestrictions);

  $("#btn-add-restriction").on('click', function(){

  });
}

function populateAmenities(data){
  $.each(data, function(i, data){
    var id = "#toggle-" + data.name.toLowerCase().replace(' ', '');
    $(id).attr('checked', true);
    console.log(id);
  });
}
