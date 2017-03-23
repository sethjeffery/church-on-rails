require 'rails_helper'
require 'google_calendar_service'

RSpec.describe CalendarSettings, type: :model do
  subject { CalendarSettings.new }

  it 'is not a real ActiveRecord model' do
    expect(subject).not_to respond_to :save
  end

  it 'has calendars' do
    google_calendar = double
    allow(GoogleCalendarService.instance).to receive(:calendars) { [google_calendar] }

    expect(subject.calendars.length).to eq 1
    expect(subject.calendars.first.calendar).to eq google_calendar
  end

  describe '#update_attributes' do
    it 'updates each calendar' do
      calendar_a = double(id: :a)
      calendar_b = double(id: :b)
      allow(calendar_a).to receive(:update_attributes) { true }
      allow(calendar_b).to receive(:update_attributes) { true }
      allow(subject).to receive(:calendars) { [calendar_a, calendar_b] }

      expect(subject.update_attributes({ a: 1, b: 2})).to be true
      expect(calendar_a).to have_received(:update_attributes).with(1)
      expect(calendar_b).to have_received(:update_attributes).with(2)
    end
  end
end
