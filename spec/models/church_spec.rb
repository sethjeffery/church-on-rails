require 'rails_helper'

RSpec.describe Church do
  describe '#can_sign_up?' do
    it 'defaults to true' do
      expect(subject.can_sign_up?).to be true
    end

    it 'is disabled via settings.signup_enabled' do
      subject.settings[:signup_enabled] = false
      expect(subject.can_sign_up?).to be false
    end
  end
end
