$(document).on 'turbolinks:load', ->
  $mapElements = $('[data-map]')
  for mapElement in $mapElements
    mapData = eval '(' + mapElement.dataset.map + ')'
    mapData.map.div = '#' + mapElement.id
    map = new GMaps(mapData.map)
    map[d.name].apply map, d.args for d in mapData.directives
