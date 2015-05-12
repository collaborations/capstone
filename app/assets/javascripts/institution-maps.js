var geocoder;
var map;
var coords;

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
    map.setCenter(results[0].geometry.location);
    // pan.setCenter(location);
    var marker = new google.maps.Marker({
        map: map,
        position: results[0].geometry.location
    });
    // Success updating
    console.log(results[0].geometry.location);
    coords = results[0].geometry.location;
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
  var pan = new google.maps.StreetViewPanorama($("#institution-street-view")[0], panoramaOptions);
  map.setStreetView(pan);
}

window.onload = initialize;


// ====================

// function initialize() {
//   var fenway = new google.maps.LatLng(42.345573, -71.098326);
//   var mapOptions = {
//     center: fenway,
//     zoom: 14
//   };
//   var map = new google.maps.Map(
//       document.getElementById('map-canvas'), mapOptions);
//   var panoramaOptions = {
//     position: fenway,
//     pov: {
//       heading: 34,
//       pitch: 10
//     }
//   };
//   var panorama = new google.maps.StreetViewPanorama(document.getElementById('pano'), panoramaOptions);
//   map.setStreetView(panorama);
// }

// google.maps.event.addDomListener(window, 'load', initialize);
