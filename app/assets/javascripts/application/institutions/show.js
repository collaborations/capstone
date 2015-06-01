var data;

if($("#institution-modal").length){
  initializeInstitution();
}

function initializeInstitution(){
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

  $(".modal-close-button").on('click', function(){ $("#institution-modal").foundation('reveal', 'close'); });

  // Show alert when they successfully subscribe to a institution
  $("#sms-subscribe-form")
    .on('ajax:success', function(e, data, status, xhr){
      flashMessage("success", "Successfully subscribed to the mailing list.");
    })
    .on("ajax:failure", function(e, data, status, xhr){
      console.log("SMS subscription failed.")
    })

  // Close the modal form and flash a message.
  $("#institution-modal-form")
    .on("ajax:success", function(e, data, status, xhr){
      $("#institution-modal").foundation('reveal', 'close');
      flashMessage("success", "Message has been sent!");
    })
    .on("ajax:failure", function(e, data, status, xhr){
      console.log("Send info form failed.")
    })
}
