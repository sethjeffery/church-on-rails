module EventsHelper
  def map_for(item, width: '100%', height:, icon: nil, items: [])
    return if Rails.env.test?

    map = GMaps.new(lat: item.lat, lng: item.lng)
    map.directives << { name: 'addMarker',
                        args: [{ lat: item.lat,
                                 lng: item.lng,
                                 icon: icon,
                                 infoWindow: ({ content: "<div>#{item.full_address(with_name: true).gsub(/,\s*/, "<br/>")}</div><a target='_blank' href='http://maps.google.com/maps?&z=10&q=#{item.full_address}'>View in Google Maps</a>" } if item.address1.present?),
                                 title: item.to_s }] }
    items.each do |other|
      if other.lat && other.lng
        map.directives << { name: 'addMarker',
                            args: [{ lat: other.lat,
                                     lng: other.lng,
                                     icon: { url: image_url('map-user.png'), scaledSize: { width: 20, height: 30 } },
                                     infoWindow: ({ content: "<div>#{other.full_address(with_name: true).gsub(/,\s*/, "<br/>")}</div><a target='_blank' href='http://maps.google.com/maps?&z=10&q=#{other.full_address}'>View in Google Maps</a>" } if other.address1.present?),
                                     title: other.to_s }] }
      end
    end

    map_div map, style: "width: #{width}; height: #{height}"
  end

  def two_event_columns?
    @event.full_address.present? || can?(:manage, @event)
  end
end
