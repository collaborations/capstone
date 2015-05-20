if($("#institutions_edit").length || $("#institutions_new").length){
  initialize();
}

function initialize(){
  $("#form-general").find("input").on('change', function(){ $("#form-general-save").show() });
  $("#form-location").find("input").on('change', function(){ $("#form-location-save").show() });
  $("#form-amenities").find("input").on('change', function(){ $("#form-amenities-save").show() });

  

  $("#btn-add-restriction").on('click', function(){

  })
}
