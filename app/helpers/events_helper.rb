module EventsHelper
  def map_for(event, width: '100%', height:)
    map = GMaps.new(lat: event.lat, lng: event.lng)
    map.directives << { name: 'addMarker',
                        args: [{ lat: event.lat,
                                 lng: event.lng,
                                 title: event.to_s }] }
    map_div map, style: "width: #{width}; height: #{height}"
  end
end
