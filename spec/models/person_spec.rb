require 'rails_helper'

RSpec.describe Person do
  subject { build(:person) }

  it { is_expected.to be_valid }
  it_behaves_like 'a named model', :full_name

  describe '#full_name' do
    it 'concats all name parts' do
      subject.prefix = 'Mr.'
      subject.first_name = 'Tom'
      subject.middle_name = 'Edward'
      subject.last_name = 'Kingsford'
      subject.suffix = 'Esq'
      expect(subject.full_name).to eq "Mr. Tom Edward Kingsford Esq"
    end

    it 'omits missing parts' do
      expect(subject.full_name).to eq "#{subject.first_name} #{subject.last_name}"
    end
  end

  describe '#gender' do
    it 'can be nil' do
      subject.gender = nil
      expect(subject).to be_valid
    end

    it 'can be m' do
      subject.gender = 'm'
      expect(subject).to be_valid
    end

    it 'can be f' do
      subject.gender = 'f'
      expect(subject).to be_valid
    end

    it 'cannot be other' do
      subject.gender = 'other'
      expect(subject).not_to be_valid
    end
  end

  describe '#start_family' do
    before do
      subject.start_family "Robinson"
    end

    it 'persists person' do
      expect(subject).not_to be_a_new_record
    end

    it 'starts a new family' do
      expect(Family.find_by(name: 'Robinson')).to be_present
    end

    it 'adds to the family' do
      expect(Family.find_by(name: 'Robinson').people).to include subject
    end
  end

  describe '#join' do
    it 'can join a family' do
      team = create(:team)
      subject.join team
      expect(team.people).to include subject
    end

    it 'can join a team' do
      family = create(:family)
      subject.join family
      expect(family.people).to include subject
    end

    it 'can join nothing else' do
      expect {
        subject.join 'the navy'
      }.to raise_error "Unexpected type String"
    end
  end

  context 'saving' do
    it 'capitalizes names' do
      subject.first_name = 'edward'
      subject.middle_name = 'a.'
      subject.last_name = "O'Donnel"
      subject.save
      expect(subject.full_name).to eq "Edward A. O'Donnel"
    end

    context 'changing email' do
      let!(:user) { create(:user, person: subject) }

      it 'copies email to user' do
        expect {
          subject.update_attributes email: 'test@example.com'
        }.to change { user.email }.to 'test@example.com'
      end
    end
  end

  context '#merge_into' do
    let(:target) { double }

    it 'uses MergePersonJob' do
      allow(MergePersonJob).to receive(:perform_now)
      subject.merge_into(target)
      expect(MergePersonJob).to have_received(:perform_now).with(subject, target)
    end
  end

  describe '#update_properties' do
    let(:property) { create(:property) }

    it 'expects a hash' do
      expect { subject.update_properties('oops') }.to raise_error(NoMethodError)
      expect { subject.update_properties({}) }.not_to raise_error
    end

    it 'adds flags' do
      expect {
        subject.update_properties({ property.id.to_s => "1" })
      }.to change {
        subject.properties.where(name: property.name).count
      }.by(1)
    end
  end

  describe '#track' do
    subject { create(:person) }

    it 'tracks a given event type for the person' do
      expect {
        subject.track(:new_action, data: { bar: 'baz' })
      }.to change {
        subject.actions.of_type(:new_action).count
      }.by(1)
    end
  end

  describe '#track_unique' do
    subject { create(:person) }

    it 'adds a new type for the person' do
      expect {
        subject.track_unique(:new_action, data: { bar: 'baz' })
      }.to change {
        subject.actions.of_type(:new_action).count
      }.by(1)
    end

    it 'updates an existing type for the person' do
      subject.track(:joined, data: { joined_at: Time.now - 1.day })
      action = subject.actions.of_type(:joined).first

      expect {
        subject.track_unique(:joined, data: { joined_at: Time.now })
      }.to change {
        action.reload.data[:joined_at]
      }
    end

    it 'does not add new actions of the same type for the person' do
      subject.track(:joined, data: { joined_at: Time.now - 1.day })

      expect {
        subject.track_unique(:joined, data: { joined_at: Time.now })
      }.not_to change {
        subject.actions.count
      }
    end
  end

  describe '#after_save' do
    it 'tracks joined_at' do
      expect {
        subject.update_attributes joined_at: Date.today
      }.to change {
        subject.actions.of_type(:joined).count
      }.by(1)

      expect(subject.actions.of_type(:joined).first.created_at).to eq Date.today.midnight
    end
  end
end
