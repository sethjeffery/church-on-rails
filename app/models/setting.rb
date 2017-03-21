# Handles all site settings with `fetch` and `store` convenience methods.
# Settings can be stored in the database, but can also be defaulted
# with ENV variables or in the config/application.yml file.
#
class Setting < ApplicationRecord
  validates_uniqueness_of :key

  # Stores a setting in the database.
  def self.store(key, value)
    store_to_cache(key, value)
    store_to_database(key, value)
  end

  # Reads a setting from the database, or from ENV.
  def self.fetch(key)
    _fetch(key).tap{|value| write_cache(key, value)}
  end

  private

  # Converts a string to UPPER_SNAKECASE for consistency.
  def self.safe_key(key)
    key.to_s.underscore.upcase
  end

  def self.store_to_cache(key, value)
    Rails.cache.write("Setting.#{safe_key(key)}", value)
  end

  def self.store_to_database(key, value)
    find_or_initialize_by(key: safe_key(key)).update(value: value)
  end

  def self._fetch(key)
    key = safe_key(key)
    if Rails.cache.exist?("Setting.#{key}")
      Rails.cache.read("Setting.#{key}")
    else
      record = where(key: key).first
      record.nil? ? ENV[key] : record.value
    end
  end
end
