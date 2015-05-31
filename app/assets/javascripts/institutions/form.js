if($("#institutions_edit").length || $("#institutions_new").length ){
  window.onload = initialize;
}

function initialize(){
  $("#add-hours").on('click', function(){
    alert("Add another field");
  })
}
