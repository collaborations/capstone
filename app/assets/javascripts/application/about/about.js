

if ($("#about_index").length) {

	var s = skrollr.init({
	  render: function(data) {
	    //Debugging - Log the current scroll position.
	    console.log(data.curTop);
	  }
	});
}	