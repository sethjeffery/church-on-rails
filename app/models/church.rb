class Church < ApplicationRecord
  include Concerns::Geocoding

  SETTINGS = {
    signup_enabled: true
  }

  validates_presence_of :name

  serialize :settings
  after_initialize :initialize_settings

  def can_sign_up?
    settings[:signup_enabled]
  end

  def to_s
    name
  end

  protected

  def initialize_settings
    self.settings ||= SETTINGS
  end
end
