var coords;
var geocoder;
var map;
var pan;

function initialize(){
  geocoder = new google.maps.Geocoder();
  var latlng = new google.maps.LatLng(0, 0);
  var mapOptions = {
    zoom: 12,
    center: latlng
  }
  map = new google.maps.Map($("#institution-aerial-map")[0], mapOptions);
  geocoder.geocode({'address': gon.address}, generateMap);
}

function generateMap(results, status){
  if (status == google.maps.GeocoderStatus.OK) {
    coords = results[0].geometry.location;
    map.setCenter(coords);
    var marker = new google.maps.Marker({
        map: map,
        position: coords
    });
  } else {
    alert("Geocode was not successful for the following reason: " + status);
  }

  var panoramaOptions = {
    position: coords,
    pov: {
      heading: 34,
      pitch: 10
    }
  };
  pan = new google.maps.StreetViewPanorama($("#institution-street-view")[0], panoramaOptions);
  map.setStreetView(pan);
}

window.onload = initialize;
