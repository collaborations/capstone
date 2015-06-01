if($("#sms_index").length){
  window.onload = initializeSMS;
}

function initializeSMS(){
  $("#sms-mass-text-form")
    .on("ajax:success", function(e, data, status, xhr){
      $("#institution-modal").foundation('reveal', 'close');
      flashMessage("success", "Message has been sent!");
    })
    .on("ajax:failure", function(e, data, status, xhr){
      flashMessage("warning", "Message failed!");
    })
}
