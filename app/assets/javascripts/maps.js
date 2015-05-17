var geocoder;
var initialLocation;
var map;
var markers;
var pan;
var pins;
var iconURLPrefix = 'http://maps.google.com/mapfiles/ms/icons/';
var icons = [
  iconURLPrefix + 'red-dot.png',
  iconURLPrefix + 'green-dot.png',
  iconURLPrefix + 'blue-dot.png',
  iconURLPrefix + 'orange-dot.png',
  iconURLPrefix + 'purple-dot.png',
  iconURLPrefix + 'pink-dot.png',      
  iconURLPrefix + 'yellow-dot.png'
];

$(document).on("page:change", function(){
  if($("#google-map-aerial").length){
    initializeMaps();
  }
});
  


function initializeMaps(){
  geocoder = new google.maps.Geocoder();
  if(gon.useCurrentLocation){
    // Try W3C Geolocation (Preferred)
    if(navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        function(position){
          initialLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
          generateMap();
        },
        function(){ geoLocationCallback(true) });
    } else {
      geoLocationCallback(false);
    }
  } else if(typeof(gon.address) !== 'undefined'){
    // Need to lookup coordinates
    geocoder.geocode({'address': gon.address}, function(results, status){
      if (status == google.maps.GeocoderStatus.OK) {
        initialLocation = results[0].geometry.location;
        generateMap();
        var marker = new google.maps.Marker({
            map: map,
            position: initialLocation
        });
      } else {
        alert("Geocode was not successful for the following reason: " + status);
      }
    });
  } else if(typeof(gon.latitude) !== 'undefined' && typeof(gon.longitude) !== 'undefined'){
    initialLocation = new google.maps.LatLng(gon.latitude, gon.longitude);
    generateMap();
  } else {
    alert("Address not specified");
  }
}

function autoCenter() {
  //  Create a new viewpoint bound
  var bounds = new google.maps.LatLngBounds();
  //  Go through each...
  for (var i = 0; i < markers.length; i++) {  
      bounds.extend(pins[i].position);
  }
  //  Fit these bounds to the map
  map.fitBounds(bounds);
}

function generateMap(){
  var mapOptions = {
    zoom: 12,
    center: initialLocation
  }
  map = new google.maps.Map($("#google-map-aerial")[0], mapOptions);
  if(gon.markers){
    markers = gon.markers;
    setMarkers();
  }
  if($("#google-map-street").length){
    generateStreetView()
  }
}

function generateStreetView(){
  var panoramaOptions = {
    position: initialLocation,
    pov: {
      heading: 34,
      pitch: 10
    }
  };
  pan = new google.maps.StreetViewPanorama($("#google-map-street")[0], panoramaOptions);
  map.setStreetView(pan);
}

function geoLocationCallback(errorFlag){
  alert((errorFlag) ? "Geolocation service failed." : "Your browser doesn't support geolocation. Defaulting to Seattle.");
  initialLocation = new google.maps.LatLng(47.614848,-122.3359058);
}

function setMarkers(){
  // Add the markers and infowindows to the map
  pins = new Array();
  var iconCounter = 0;
  for (var i = 0; i < markers.length; i++) {  
    var description = markers[i][0];
    var destination = new google.maps.LatLng(markers[i][1], markers[i][2]);
    var marker = new google.maps.Marker({
      position: destination,
      map: map,
      content: description,
      icon: icons[iconCounter]
    });
    pins.push(marker);
    var infowindow = new google.maps.InfoWindow({
      maxWidth: 160
    });
    google.maps.event.addListener(marker, 'click', (function(marker, i) {
      return function() {
        infowindow.setContent(marker.content);
        infowindow.open(map, marker);
      }
    })(marker, i));
    iconCounter++;
    // We only have a limited number of possible icon colors, so we may have to restart the counter
    if(iconCounter >= icons.length) {
      iconCounter = 0;
    }
  }
  autoCenter();
}
