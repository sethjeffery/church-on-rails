require 'google_calendar_service'

# This wraps CalendarTeam and GoogleCalendarService to present
# the calendar settings page in an intuitive format.

class CalendarSettings
  include ActiveModel::Model

  def persisted?
    true
  end

  def service
    GoogleCalendarService.instance
  end

  def calendars
    @calendars ||= service.calendars.map{|calendar|
      # This is the model that really determines the settings
      # for each Google Calendar.
      CalendarWithSettings.new(calendar)
    }
  end

  def update_attributes(attrs)
    calendars.all?{|c| c.update_attributes(attrs[c.id])}
  end
end
