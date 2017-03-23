require 'rails_helper'
require 'google_calendar_service'

RSpec.describe CalendarTeam, type: :model do
  subject { build(:calendar_team, calendar_id: 'CALENDAR') }

  describe '#service' do
    it 'is a GoogleCalendarService' do
      expect(subject.service).to be_a GoogleCalendarService
    end
  end

  describe '#events' do
    around do |ex|
      Timecop.freeze(Time.local(2017, 3, 10)) { ex.run }
    end

    it 'returns calendar events for the team calendar' do
      service = double(:instance)
      allow(GoogleCalendarService).to receive(:instance) { service }
      allow(service).to receive(:events) { ['event'] }

      expect(subject.events).to eq ['event']
      expect(service).to have_received(:events).with subject.calendar_id,
                                                     time_min: '2017-02-27T00:00:00+00:00',
                                                     time_max: '2017-04-03T00:00:00+00:00'
    end
  end

  describe '#google_calendar' do
    it 'returns the google calendar for this item' do
      service = double(:instance)
      allow(GoogleCalendarService).to receive(:instance) { service }

      calendar_a = double(id: 'NOT')
      calendar_b = double(id: 'CALENDAR')
      allow(service).to receive(:calendars) { [calendar_a, calendar_b] }

      expect(subject.google_calendar).to eq calendar_b
    end
  end

  describe '#public' do
    context 'item has team' do
      it 'is false' do
        subject.update_attributes team: create(:team)
        expect(subject.public?).to be false
      end
    end

    context 'item has no team' do
      it 'is true' do
        subject.update_attributes team: nil
        expect(subject.public?).to be true
      end
    end
  end

  describe '.for' do
    let(:person) { create(:person) }
    let(:team) { create(:team)}
    before { person.join team }

    it "includes calendars for the person's teams" do
      calendar_team = create(:calendar_team, team: team)
      expect(CalendarTeam.for(person).all).to include calendar_team
    end

    it 'includes calendars for no specific team' do
      calendar_team = create(:calendar_team)
      expect(CalendarTeam.for(person).all).to include calendar_team
    end

    it 'does not include calendars for other teams' do
      calendar_team = create(:calendar_team, team: create(:team))
      expect(CalendarTeam.for(person).all).not_to include calendar_team
    end
  end
end
