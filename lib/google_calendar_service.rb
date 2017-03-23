require 'google_service'

# Manages connection to the Google Calendar API, retrieving calendars and events.
# It is a singleton-per-request in order to cache the requests.

class GoogleCalendarService < GoogleService
  def self.instance
    RequestStore.store[:google_calendar_service] ||= new
  end

  def service
    @service ||= Google::Apis::CalendarV3::CalendarService.new.tap{|s| s.authorization = client}
  end

  def events(calendar_id, time_max: nil, time_min: nil)
    service.list_events(calendar_id, time_max: time_max, time_min: time_min).items
  end

  def calendars
    @calendars ||= service.list_calendar_lists.items
  end
end
