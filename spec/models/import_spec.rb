require 'rails_helper'

RSpec.describe Import do
  context 'by default' do
    it 'has no header' do
      expect(subject.has_header).to be false
    end

    it 'has empty column matches' do
      expect(subject.column_matches).to eq []
    end
  end

  describe '#destroy' do
    it 'deletes the temp file' do
      allow(File).to receive(:delete)
      subject.id = 'abc'
      subject.destroy
      expect(File).to have_received(:delete).with("#{Rails.root}/tmp/import-abc.xlsx")
    end
  end
end
