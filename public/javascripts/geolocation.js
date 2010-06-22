function togglePolygon(map, polygon) {
  if (polygon.getMap() == map) {
    polygon.setMap(null);
  } else {
    polygon.setMap(map);
  }
}

;(function($) {
  $(function() {
    if(location_set) {
    } else if(navigator.geolocation) {
      // Try W3C Geolocation (Preferred)
      navigator.geolocation.getCurrentPosition(function(position) {
        $.post('location', {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        });
      });
    } else if (google.gears) {
      // Try Google Gears Geolocation
      var geo = google.gears.factory.create('beta.geolocation');
      geo.getCurrentPosition(function(position) {
        $.post('location', {
          lat: position.latitude,
          lng: position.longitude
        });
      });
    }
  });
})(jQuery);
