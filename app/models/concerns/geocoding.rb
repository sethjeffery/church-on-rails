module Concerns
  module Geocoding
    extend ActiveSupport::Concern

    def full_address
      arr = [address1, address2, postcode, country].select(&:present?)
      if arr.present?
        arr << 'UK' if country.blank?
        arr.join(', ')
      end
    end

    def lat
      latitude
    end

    def lng
      longitude
    end

    included do
      geocoded_by :full_address
      after_validation :geocode unless Rails.env.test?
    end
  end
end
