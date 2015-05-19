var data;

if($("#institution-modal").length){
  initialize();
}

if($("#institutions_print").length){
  // window.onload = window.print();
}

function initialize(){
  $("#select-all-options").on("click", function(){ $("#customization-options input").attr('checked', true); });
  $("#remove-all-options").on("click", function(){ $("#customization-options input").attr('checked', false); });
  $("#get-info").find("button").on("click", function(event){ 
    var type = event.target.name;
    $("#message_type")[0].value = type;
    if(type === "text"){
      $("#send-email").hide();
      $("#email").attr("required", false);
      $("#send-text").show();
      $("#sms").attr("required", true);
    } else {
      $("#send-email").show();
      $("#email").attr("required", true);
      $("#send-text").hide();
      $("#sms").attr("required", false);
    }
  });
  data = {};
  $('#institution-modal-form').on('valid.fndtn.abide', function(event) {
    $.each($("#notify-options").find("input"), function(i, v){
      data[v.name] = (v.type === "checkbox") ? v.checked : v.value;     
    });
    var jqxhr = $.ajax({
      type: "POST",
      url: (data["message_type"] === "text") ? "/sms/info" : "/mailer/info",
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
