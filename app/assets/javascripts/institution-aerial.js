var geocoder;
var map;

function initialize(){
  geocoder = new google.maps.Geocoder();
  var latlng = new google.maps.LatLng(0, 0);
  var mapOptions = {
    zoom: 8,
    center: latlng
  }
  map = new google.maps.Map($("#institution-aerial-map")[0], mapOptions);
  codeAddress(gon.address);
}

function codeAddress(address){
  geocoder.geocode({'address': address}, function(results, status){
    if (status == google.maps.GeocoderStatus.OK) {
      map.setCenter(results[0].geometry.location);
      var marker = new google.maps.Marker({
          map: map,
          position: results[0].geometry.location
      });
    } else {
      alert("Geocode was not successful for the following reason: " + status);
    }
  });
}

window.onload = initialize;
