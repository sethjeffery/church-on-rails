module EventsHelper
  def map_for(event, width: '100%', height:, address:)
    map = GMaps.new(lat: event.lat, lng: event.lng)
    map.directives << { name: 'addMarker',
                        args: [{ lat: event.lat,
                                 lng: event.lng,
                                 infoWindow: ({ content: "<div>#{address.gsub(/,\s*/, "<br/>")}</div><a target='_blank' href='http://maps.google.com/maps?&z=10&q=#{address}'>View in Google Maps</a>" } if address),
                                 title: event.to_s }] }
    map_div map, style: "width: #{width}; height: #{height}"
  end

  def two_event_columns?
    @event.full_address.present? || can?(:manage, @event)
  end
end
