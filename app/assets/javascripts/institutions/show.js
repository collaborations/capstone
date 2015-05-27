var data;

if($("#institution-modal").length){
  initialize();
}

function initialize(){
  $("#select-all-options").on("click", function(){ $("#customization-options input").attr('checked', true); });
  $("#remove-all-options").on("click", function(){ $("#customization-options input").attr('checked', false); });
  $("button[name='email']").on("click", function(){
    $("#send-email").show();
    $("#email").attr("required", true);
    $("#send-text").hide();
    $("#sms").attr("required", false);
    $("#message_type")[0].value = "email";
    $("#institution-modal-form")[0].action = "/mailers/send"
    $("#sms").attr("aria-invalid", false);
  });

  $("button[name='text']").on("click", function(){
    $("#send-email").hide();
    $("#email").attr("required", false);
    $("#send-text").show();
    $("#sms").attr("required", true);
    $("#message_type")[0].value = "text";
    $("#institution-modal-form")[0].action = "/sms/info"
    $("#email").attr("aria-invalid", false);
  });
}
