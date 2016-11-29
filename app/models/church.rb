class Church < ApplicationRecord
  include Concerns::Geocoding

  has_attached_file :cover, styles: { md: "1200x600#" }

  SETTINGS = {
    signup_enabled: true
  }

  validates_presence_of :name
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/

  serialize :settings
  after_initialize :initialize_settings

  def can_sign_up?
    settings[:signup_enabled].in?([true, '1'])
  end

  def to_s
    name
  end

  protected

  def initialize_settings
    self.settings ||= SETTINGS
  end
end
