module Concerns
  module Geocoding
    extend ActiveSupport::Concern

    def full_address
      [address1, address2, postcode, country || 'UK'].select(&:present?).join(', ')
    end

    def lat
      latitude
    end

    def lng
      longitude
    end

    included do
      geocoded_by :full_address
      after_validation :geocode
    end
  end
end
