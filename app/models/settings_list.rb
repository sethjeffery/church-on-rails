class SettingsList
  include ActiveModel::Model
  attr_reader :hash

  def initialize(hash)
    @hash = hash.to_h.map{|k,v| [safe_key(k), v]}.to_h
  end

  def persisted?
    true
  end

  def truthy?(key)
    hash[safe_key(key)].to_s.downcase.in? %w(true 1 yes)
  end

  def safe_key(key)
    key.to_s.underscore.upcase
  end

  def method_missing(name, *args, &block)
    hash[safe_key(name)]
  end

  def save
    hash.each do |key, value|
      Setting.store(key, value)
    end
  end
end
