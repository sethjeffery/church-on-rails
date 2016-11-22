require 'rails_helper'

RSpec.describe PersonProcess do
  subject { build(:person_process) }

  it { is_expected.to be_valid }
  it_behaves_like 'a named model', :person

  describe 'saving' do
    context 'steps all done' do
      before do
        subject.church_process.steps = ["One", "Two", "Three"]
        subject.steps = ["one", "two", "three"]
        subject.save!
      end

      it 'marks as complete' do
        expect(subject).to be_complete
      end
    end

    context 'steps not all done' do
      before do
        subject.church_process.steps = ["One", "Two", "Three"]
        subject.steps = ["one", "two"]
        subject.save!
      end

      it 'does not mark as complete' do
        expect(subject).not_to be_complete
      end
    end
  end

  describe '#completed_step?' do
    it 'verifies if the given step is complete' do
      subject.steps = ["one"]
      expect(subject.completed_step?('One')).to be true
      expect(subject.completed_step?('Two')).to be false
    end
  end

  describe 'scopes' do
    let!(:active_process)   { create(:person_process, :active) }
    let!(:complete_process) { create(:person_process, :complete) }

    describe '.active' do
      it 'returns active processes only' do
        expect(described_class.active.all).to eq [active_process]
      end
    end

    describe '.complete' do
      it 'returns complete processes only' do
        expect(described_class.complete.all).to eq [complete_process]
      end
    end
  end
end
