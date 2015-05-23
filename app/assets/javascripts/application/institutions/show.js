var data;

if($("#institution-modal").length){
  window.onload = initialize();
}

function initialize(){
  $("#select-all-options").on("click", selectAllOptions );
  $("#remove-all-options").on("click", deselectAllOptions );
  $("button[name='text']").on('click', function(){
    selectAllOptions();
    $("#message_type")[0].value = "text";
    $("#send-email").hide();
    $("#email").attr("required", false);
    $("#send-text").show();
    $("#sms").attr("required", true);
  });
  $("button[name='email']").on('click', function(){
    selectAllOptions();
    $("#message_type")[0].value = "email";
    $("#send-email").show();
    $("#email").attr("required", true);
    $("#send-text").hide();
    $("#sms").attr("required", false);
  });
  data = {};
  $('#institution-modal-form').on('valid.fndtn.abide', function(event) {
    console.log("submit");
    $.each($("#notify-options").find("input"), function(i, v){
      data[v.name] = (v.type === "checkbox") ? v.checked : v.value;     
    });
    var jqxhr = $.ajax({
      type: "POST",
      url: (data["message_type"] === "text") ? "/sms/info" : "/institution/email",
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

function selectAllOptions(){
  $("#customization-options input").attr('checked', true);
}

function deselectAllOptions(){
  $("#customization-options input").attr('checked', false);
}
