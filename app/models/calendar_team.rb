require 'google_calendar_service'

class CalendarTeam < ApplicationRecord
  delegate :summary, to: :google_calendar
  attr_writer :google_calendar

  belongs_to :team, optional: true # if nil, permission is public

  def public?
    team_id.nil?
  end

  def service
    GoogleCalendarService.instance
  end

  def events(start_date: nil)
    start_date ||= Date.current
    time_min = start_date.to_date.beginning_of_month.beginning_of_week
    time_max = (start_date.to_date.beginning_of_month + 1.month + 1.week).beginning_of_week

    service.events(calendar_id,
                   time_min: time_min.strftime('%FT%T%:z'),
                   time_max: time_max.strftime('%FT%T%:z'))
  end

  def google_calendar
    service.calendars.find{|c| c.id == calendar_id}
  end

  def self.for(person)
    team_ids = person.team_memberships.pluck(:team_id)
    CalendarTeam.where(team_id: team_ids + [nil])
  end
end
