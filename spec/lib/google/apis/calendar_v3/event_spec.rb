require 'rails_helper'
require 'google/apis/calendar_v3/event'

RSpec.describe Google::Apis::CalendarV3::Event, type: :model do
  around do |ex|
    Timecop.freeze(Time.local(2017, 3, 10, 15, 30)) { ex.run }
  end

  context 'time-specific event' do
    subject { Google::Apis::CalendarV3::Event.new(:start => double(date_time: DateTime.now), :end => double(date_time: DateTime.now)) }

    describe '#start_time' do
      it 'is start as datetime' do
        expect(subject.start_time).to eq subject.start.date_time
      end
    end

    describe '#end_time' do
      it 'is end as datetime' do
        expect(subject.end_time).to eq subject.end.date_time
      end
    end

    describe '#all_day?' do
      it 'is false' do
        expect(subject.all_day?).to be false
      end
    end

    describe '#simple_time' do
      it 'is the start time as time only' do
        expect(subject.simple_time).to eq '3.30pm'
      end

      it 'can be without minutes' do
        Timecop.freeze(Time.local(2017, 3, 10, 15, 00)) do
          expect(subject.simple_time).to eq '3pm'
        end
      end
    end
  end

  context 'all-day event' do
    subject { Google::Apis::CalendarV3::Event.new(:start => double(date_time: nil, date: Date.today),
                                                  :end => double(date_time: nil, date: Date.tomorrow)) }

    describe '#start_time' do
      it 'is start as date' do
        expect(subject.start_time).to eq subject.start.date
      end
    end

    describe '#end_time' do
      it 'is 1 day before end as date' do
        expect(subject.end_time).to eq subject.end.date - 1.day
      end
    end

    describe '#all_day?' do
      it 'is true' do
        expect(subject.all_day?).to be true
      end
    end

    describe '#simple_time' do
      it 'is midnight' do
        expect(subject.simple_time).to eq '12am'
      end
    end
  end
end
