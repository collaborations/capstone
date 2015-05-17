var data;

if($("#institution-modal").length){
  initialize();
}

if($("#institution_print").length){
  window.print()
}

function initialize(){
  $("#select-all-options").on("click", function(){ $("#customization-options input").attr('checked', true); });
  $("#remove-all-options").on("click", function(){ $("#customization-options input").attr('checked', false); });
  $("#get-info").find("button").on("click", function(event){ 
    var type = event.target.name;
    $("#message_type")[0].value = type;
    $sms = $("#send-email")
    $email = $("#email")
    if(type === "text"){
      $("#send-email").hide();
      $("#email").attr("required", false);
      $("#send-text").show();
      $("#sms").attr("required", true);
    } else if (type === "email"){
      $("#send-email").show();
      $("#email").attr("required", true);
      $("#send-text").hide();
      $("#sms").attr("required", false);
    } else if (type === "dgaf?")
  });
  data = {};
  $('#institution-modal-form').on('valid.fndtn.abide', function(event) {
    $.each($("#notify-options").find("input"), function(i, v){
      data[v.name] = (v.type === "checkbox") ? v.checked : v.value;     
    });
    var requestPath;
    switch (event.target.name){
      case ("text"):
        requestPath = "/sms/info";
        break;
      case ("email"):
        requestPath = "/mailer/info";
        break;
      case ("print"):
        requestPath = "/institution/print";
        break;
    }
    var jqxhr = $.ajax({
      type: "POST",
      url: requestPath,
      data: data,
      success: function(response){
        $('#institution-modal').foundation('reveal', 'close');
      }
    }); 
    jqxhr.fail(function(){
      alert("Sending the message failed.");
    });
  });
}
