require 'rails_helper'

RSpec.describe ChurchProcess do
  subject { build(:church_process) }

  it { is_expected.to be_valid }
  it_behaves_like 'a named model'

  describe 'initialization' do
    it 'starts with blank steps' do
      expect(ChurchProcess.new.steps).to eq ["", "", ""]
    end
  end

  describe 'saving' do
    it 'compacts steps' do
      subject.steps = ["", "Hello", ""]
      subject.save!
      expect(subject.steps).to eq ["Hello"]
    end
  end

  context do
    let(:complete_process) { build(:person_process, :complete) }
    let(:active_process)   { build(:person_process, :active) }

    before do
      subject.person_processes << complete_process
      subject.person_processes << active_process
    end

    describe '#active_processes' do
      it 'returns all active person_processes' do
        expect(subject.active_processes).to eq([active_process])
      end
    end

    describe '#active_processes_count' do
      it 'counts active person_processes' do
        expect(subject.active_processes_count).to eq 1
      end
    end
  end
end
