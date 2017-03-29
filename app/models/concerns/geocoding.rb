module Concerns
  module Geocoding
    extend ActiveSupport::Concern

    def full_address(with_name: false)
      arr = [address1, address2, postcode, country].select(&:present?)
      arr = [to_s] + arr if with_name
      arr << 'UK' if arr.present? && country.blank?
      arr.select(&:present?).join(', ')
    end

    def lat
      latitude
    end

    def lng
      longitude
    end

    included do
      geocoded_by :full_address
      after_validation :geocode, if: :should_geocode?
    end

    def should_geocode?
      return false if Rails.env.test? || Geocoder.config.lookup == :test
      return false if full_address.blank?
      lat.blank? || lng.blank? || address1_changed? || address2_changed? || postcode_changed?
    end
  end
end
