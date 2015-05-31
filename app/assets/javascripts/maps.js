var currentLocation;
var geocoder;
var initialLocation;
var map;
var markers;
var pan;
var pins;
var iconURL = 'http://maps.google.com/mapfiles/ms/icons/purple-dot.png';
var cLocIconUrl = 'http://maps.google.com/mapfiles/ms/icons/red-dot.png';

window.onload = initializeGoogleMapsAPI;

function initializeGoogleMapsAPI(){
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp' +
      '&signed_in=true&callback=initialize';
  document.body.appendChild(script);
}

function googleMapsCallback(){
  google.maps.event.addDomListener(window, 'load', initializeMaps);
}

function initializeMaps(){
  setCurrentLocation();

  if(typeof(gon.latitude) !== 'undefined' && typeof(gon.longitude) !== 'undefined'){
    // Geocoordinates were provided
    initialLocation = new google.maps.LatLng(gon.latitude, gon.longitude);
    generateMap();
  } else if(typeof(gon.address) !== 'undefined'){
    // Need to lookup address
    addressLookup(gon.address);
  } else {
    alert("Error loading Google maps, please reload the page.");
  }
}

// Look up geocoordinates from an address and use that as the initial location.
function addressLookup(address){
  geocoder = new google.maps.Geocoder();

  geocoder.geocode({'address': address}, function(results, status){
    if (status == google.maps.GeocoderStatus.OK) {
      initialLocation = results[0].geometry.location;
      generateMap();
      var marker = new google.maps.Marker({
          map: map,
          position: initialLocation
      });
    } else {
      console.log("Geocode was not successful for the following reason: " + status);
    }
  });
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
  // Verify the streetview doesn't already exist on the page
  if(map === undefined){
    var mapOptions = {
      zoom: 12,
      center: initialLocation,
      scrollwheel: false
    }
    map = new google.maps.Map($("#google-map-aerial")[0], mapOptions);
  }

  if(gon.markers){
    markers = gon.markers;
    setMarkers();
  }
  if($("#google-map-street").length){
    generateStreetView()
  }
}

function generateStreetView(){
  // Verify the streetview doesn't already exist on the page
  if(pan === undefined){
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
}

function getCurrentLocation(){
  // Attempt to get geolocation
  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      function(position){ //Success
        // Convert to Google Maps Geocode
        currentLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
        setCurrentLocation();
      },
      function(error){    //Failure
        switch(error.code) {
          case error.PERMISSION_DENIED:
            console.log("User denied the request for Geolocation.");
            break;
          case error.POSITION_UNAVAILABLE:
            console.log("Location information is unavailable.");
            break;
          case error.TIMEOUT:
            console.log("The request to get user location timed out.");
            break;
          case error.UNKNOWN_ERROR:
            console.log("An unknown error occurred.");
            break;
        }
      });
  } else {
    console.log("Your browser does not support geolocation.");
  } 
}

function setCurrentLocation(){
  if(map === undefined){
    generateMap();
  }
  console.log(map)
  // Create marker
  var marker = new google.maps.Marker({
    position: currentLocation,
    map: map,
    title: 'Hello World!'
  });
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
      icon: iconURL
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
  }
  if (pins.length > 1) {
    autoCenter();  
  }
}
