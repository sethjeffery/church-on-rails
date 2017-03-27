require 'rails_helper'

RSpec.describe SettingsList, type: :model do
  subject { SettingsList.new({ foo: 'bar', baz: 'quz', true_like: '1', false_like: '0' }) }

  describe 'attributes' do
    it 'are accessed as methods' do
      expect(subject.foo).to eq 'bar'
      expect(subject.baz).to eq 'quz'
    end

    it 'can be undefined' do
      expect(subject.other).to be_nil
    end

    it 'are key-friendly' do
      expect(subject.FOO).to eq 'bar'
      expect(subject.TrueLike).to eq '1'
    end
  end

  describe '#truthy?' do
    it 'is true for true-like attributes' do
      expect(subject.truthy?(:true_like)).to be true
    end

    it 'is false for false-like attributes' do
      expect(subject.truthy?(:false_like)).to be false
    end
  end

  describe 'save', :caching do
    it 'stores the attributes as Settings' do
      expect {
        subject.save
      }.to change { Setting.count }.by(4)
    end
  end
end
