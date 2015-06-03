/* 
 * These functions are meant to be global function, used for creating flash messages on the screen.
 */
function flashMessage(type, message){
  _message = "<div data-alert class='alert-box " + type + " radius'>" + message + "<a href='#' class='close'>&times;</a></div>"
  $("#flash-message").append(_message);
  $(document).foundation('alert', 'reflow');
  $("html, body").animate({ scrollTop: 0 }, "slow");
}
