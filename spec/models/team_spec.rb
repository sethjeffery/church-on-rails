require 'rails_helper'

RSpec.describe Team do
  subject { build(:team) }

  it { is_expected.to be_valid }
  it_behaves_like 'a named model'

  describe '#has_permissions_for?' do
    it 'checks if any permissions exist for the given resource' do
      subject.people_reader = true
      expect(subject).to have_permissions_for :people
      expect(subject).not_to have_permissions_for :snakes
    end
  end

  describe '#permissions?' do
    it 'checks if any permissions exist' do
      expect(subject).not_to have_permissions

      subject.people_reader = true
      expect(subject).to have_permissions

      subject.people_reader = false
      subject.admin         = true
      expect(subject).to have_permissions
    end
  end

  describe '#color' do
    it 'can be nil' do
      subject.color = nil
      expect(subject).to be_valid
    end

    it 'must otherwise be a hex color value in lower case' do
      subject.color = 'red'
      expect(subject).to_not be_valid

      subject.color = 'FFACDC'
      expect(subject).not_to be_valid

      subject.color = 'ffacdc'
      expect(subject).to be_valid
    end
  end
end
