class Church < ApplicationRecord
  DEFAULT_SETTINGS = {
    signup_enabled: true
  }

  serialize :settings
  after_initialize :initialize_settings

  def can_sign_up?
    settings[:signup_enabled]
  end

  protected

  def initialize_settings
    self.settings ||= DEFAULT_SETTINGS
  end
end
