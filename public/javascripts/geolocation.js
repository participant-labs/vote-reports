function togglePolygons(map, polygons) {
  jQuery.each(polygons, function() {
    if (this.getMap() == map) {
      this.setMap(null);
    } else {
      this.setMap(map);
    }
  });
}

;(function($) {
  $(function() {
    if(location_set) {
    } else if(navigator.geolocation) {
      // Try W3C Geolocation (Preferred)
      navigator.geolocation.getCurrentPosition(function(position) {
        $.post('/location', {
          autoloc: {
            lat: position.coords.latitude,
            lng: position.coords.longitude
          }
        });
      });
    } else if (google.gears) {
      // Try Google Gears Geolocation
      var geo = google.gears.factory.create('beta.geolocation');
      geo.getCurrentPosition(function(position) {
        $.post('/location', {
          autoloc: {
            lat: position.latitude,
            lng: position.longitude
          }
        });
      });
    }
  });
})(jQuery);
