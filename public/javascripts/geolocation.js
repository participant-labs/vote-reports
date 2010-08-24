function togglePolygons(map, polygons) {
  jQuery.each(polygons, function() {
    if (this.getMap() == map) {
      this.setMap(null);
    } else {
      this.setMap(map);
    }
  });
}
