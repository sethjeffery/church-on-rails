class Setting < ApplicationRecord
  validates_uniqueness_of :key

  def self.store(key, value)
    write_cache(key, value)
    write_database(key, value)
  end

  def self.fetch(key)
    key = safe_key(key)

    if Rails.cache.exist?("Setting.#{key}")
      value = Rails.cache.read("Setting.#{key}")
    else
      record = where(key: key).first
      value = record.nil? ? ENV[key] : record.value
    end

    write_cache(key, value)
    value
  end

  def self.safe_key(key)
    key.to_s.underscore.upcase
  end

  private

  def self.write_cache(key, value)
    Rails.cache.write("Setting.#{safe_key(key)}", value)
  end

  def self.write_database(key, value)
    find_or_initialize_by(key: safe_key(key)).update(value: value)
  end
end
