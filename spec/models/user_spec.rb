require 'rails_helper'

RSpec.describe User do
  subject { build(:user) }

  it { is_expected.to be_valid }
  it_behaves_like 'a named model', :email

  context 'confirming' do
    it 'auto-connects with person' do
      person = create(:person, email: subject.email)
      subject.save

      expect {
        subject.confirm
      }.to change { person.reload.user }.to subject
    end
  end
end
