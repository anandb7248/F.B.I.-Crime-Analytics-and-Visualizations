library(geojsonio)

states <- geojsonio::geojson_read("json/us-states.geojson", what = "sp")
class(states)

