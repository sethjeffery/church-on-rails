module Concerns
  module Geocoding
    extend ActiveSupport::Concern

    def full_address(with_name: false)
      arr = [address1, address2, postcode, country].select(&:present?)
      arr = [to_s] + arr if with_name
      if arr.present?
        arr << 'UK' if country.blank?
        arr.select(&:present?).join(', ')
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
      after_validation :geocode, unless: ->{ Rails.env.test? || Geocoder.config.lookup == :test }
    end
  end
end
