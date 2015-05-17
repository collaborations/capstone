var data;

if($("#institution-modal").length){
  initialize();
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
    var requestURL = (data["message_type"] === "text") ? "/sms/info" : "/mailer/info";
    $.ajax({
      type: "POST",
      url: requestURL,
      data: data,
      success: function(response){
        alert("Success");
        $('#institution-modal').foundation('reveal', 'close');
      }
    });  
  });
}
