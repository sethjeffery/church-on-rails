# Handles all site settings with `fetch` and `store` convenience methods.
# Settings can be stored in the database, but can also be defaulted
# with ENV variables or in the config/application.yml file.
#
class Setting < ApplicationRecord
  validates_uniqueness_of :key

  # Stores a setting in the database.
  def self.store(key, value)
    unless Rails.cache&.read("Setting.#{safe_key(key)}") == value
      store_to_cache(key, value)
      store_to_database(key, value)
    end
  end

  # Reads a setting from the database, or from ENV.
  def self.fetch(key, default=nil)
    _fetch(key, default).tap{|value| store_to_cache(key, value)}
  end

  # Checks if the setting is truthy (on, true, yes, etc).
  def self.truthy?(key)
    fetch(key).to_s.downcase.in? %w(true 1 yes)
  end

  # Checks if the setting is not blank.
  def self.present?(key)
    fetch(key).present?
  end

  private

  # Converts a string to UPPER_SNAKECASE for consistency.
  def self.safe_key(key)
    key.to_s.underscore.upcase
  end

  def self.store_to_cache(key, value)
    Rails.cache&.write("Setting.#{safe_key(key)}", value)
  end

  def self.store_to_database(key, value)
    find_or_initialize_by(key: safe_key(key)).update(value: value)
  end

  def self._fetch(key, default=nil)
    key = safe_key(key)
    if Rails.cache&.exist?("Setting.#{key}")
      Rails.cache.read("Setting.#{key}")
    else
      record = find_by(key: key) rescue nil
      record ? record.value : ENV.fetch(key, default)
    end
  end
end
