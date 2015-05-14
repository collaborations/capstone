$("#select-all-options").on("click", function(){ $("#notify-options > input").attr('checked', true); });
$("#remove-all-options").on("click", function(){ $("#notify-options > input").attr('checked', false); });

$("#get-info").find("button").on("click", function(event){ $("#message_type")[0].value = event.target.name });
