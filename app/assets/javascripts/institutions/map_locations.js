// Define your locations: HTML content for the info window, latitude, longitude
var siberia = new google.maps.LatLng(60, 105);
var newyork = new google.maps.LatLng(40.69847032728747, -73.9514422416687);
var initialLocation;
var locations = gon.locations;

// Setup the different icons and shadows
var iconURLPrefix = 'http://maps.google.com/mapfiles/ms/icons/';

var icons = [
  iconURLPrefix + 'red-dot.png',
  iconURLPrefix + 'green-dot.png',
  iconURLPrefix + 'blue-dot.png',
  iconURLPrefix + 'orange-dot.png',
  iconURLPrefix + 'purple-dot.png',
  iconURLPrefix + 'pink-dot.png',      
  iconURLPrefix + 'yellow-dot.png'
]
var iconsLength = icons.length;

var map = new google.maps.Map(document.getElementById('map'), {
  mapTypeId: google.maps.MapTypeId.ROADMAP,
  mapTypeControl: false,
  streetViewControl: false,
  panControl: false,
  zoomControlOptions: {
     position: google.maps.ControlPosition.LEFT_BOTTOM
  }
});

// Try W3C Geolocation (Preferred)
if(navigator.geolocation) {
  browserSupportFlag = true;
  navigator.geolocation.getCurrentPosition(setInitialLocation, function() {
    handleNoGeolocation(browserSupportFlag);
  });
}
// Browser doesn't support Geolocation
else {
  browserSupportFlag = false;
  handleNoGeolocation(browserSupportFlag);
}

function setInitialLocation(position){
  initialLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
  map.setZoom(13);
  map.setCenter(initialLocation);
  gon.currentLocation = [position.coords.latitude,position.coords.longitude];
  setMarkers();
}

function handleNoGeolocation(errorFlag) {
  if (errorFlag == true) {
    alert("Geolocation service failed.");
    initialLocation = newyork;
  } else {
    alert("Your browser doesn't support geolocation. We've placed you in Siberia.");
    initialLocation = siberia;
  }
  map.setCenter(initialLocation);
}



var infowindow = new google.maps.InfoWindow({
  maxWidth: 160
});

var markers = new Array();

var iconCounter = 0;

function setMarkers(){
  // Add the markers and infowindows to the map
  for (var i = 0; i < locations.length; i++) {  
    destination = new google.maps.LatLng(locations[i][1], locations[i][2]);
    var marker = new google.maps.Marker({
      position: destination,
      map: map,
      icon: icons[iconCounter]
    });

    markers.push(marker);

    google.maps.event.addListener(marker, 'click', (function(marker, i) {
      return function() {
        infowindow.setContent(locations[i][0]);
        infowindow.open(map, marker);
      }
    })(marker, i));
    
    iconCounter++;
    // We only have a limited number of possible icon colors, so we may have to restart the counter
    if(iconCounter >= iconsLength) {
    	iconCounter = 0;
    }

    //calculate distances
    calculateDistances(initialLocation, destination);
  }
}

function autoCenter() {
  //  Create a new viewpoint bound
  var bounds = new google.maps.LatLngBounds();
  //  Go through each...
  for (var i = 0; i < markers.length; i++) {  
			bounds.extend(markers[i].position);
  }
  //  Fit these bounds to the map
  map.fitBounds(bounds);
}
autoCenter();

function calculateDistances(origin, destination) {
  var service = new google.maps.DistanceMatrixService();
  service.getDistanceMatrix(
    {
      origins: [origin],
      destinations: [destination],
      travelMode: google.maps.TravelMode.WALKING,
      unitSystem: google.maps.UnitSystem.IMPERIAL,
      avoidHighways: false,
      avoidTolls: false
    }, callback);
}

function callback(response, status) {
  if (status != google.maps.DistanceMatrixStatus.OK) {
    alert('Error was: ' + status);
  } else {
    var origins = response.originAddresses;
    var destinations = response.destinationAddresses;
  }
}

