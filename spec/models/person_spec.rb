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
end
