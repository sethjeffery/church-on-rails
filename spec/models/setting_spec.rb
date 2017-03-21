require 'rails_helper'

RSpec.describe Setting, type: :model do
  describe '.store', :caching do
    it 'stores in cache' do
      expect {
        Setting.store(:something, 'Hello')
      }.to change {
        Rails.cache.read('Setting.SOMETHING')
      }.to('Hello')
    end

    it 'stores in database' do
      expect {
        Setting.store(:something, 'Hello')
      }.to change {
        Setting.where(key: 'SOMETHING').count
      }.by(1)
    end
  end

  describe '.fetch', :caching do
    it 'fetches from cache' do
      Rails.cache.write('Setting.SOMETHING', 'Hello')
      expect(Setting.fetch(:something)).to eq 'Hello'
    end

    it 'fetches from ENV' do
      stub_const('ENV', {'SOMETHING' => 'Bonjour'})
      expect(Setting.fetch(:something)).to eq 'Bonjour'
    end

    it 'fetches from database' do
      Setting.create!(key: 'SOMETHING', value: 'Hola')
      expect(Setting.fetch(:something)).to eq 'Hola'
    end
  end
end
