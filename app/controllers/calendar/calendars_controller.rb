require 'google/apis/calendar_v3/event'

class Calendar::CalendarsController < ApplicationController
  before_action :require_refresh_token, only: :show

  def show
    client = Signet::OAuth2::Client.new({
      client_id: Setting.fetch(:google_client_id),
      client_secret: Setting.fetch(:google_client_secret),
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
    })

    client.update!(refresh_token: Setting.fetch(:google_refresh_token))
    client.grant_type = 'refresh_token'

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    start_date = (params[:start_date].try(:to_date) || Date.current).beginning_of_month.beginning_of_week
    end_date   = (start_date + 1.month + 1.week).beginning_of_month.beginning_of_week

    @calendars = service.list_calendar_lists
    @events = @calendars.items.each_with_index.flat_map{|calendar, index|
      service.list_events(calendar.id,
                          time_min: start_date.strftime('%FT%T%:z'),
                          time_max: end_date.strftime('%FT%T%:z')).items.map{|item|
        item.calendar_index = index
        item
      }
    }
  end

  def redirect
    client = Signet::OAuth2::Client.new({
      client_id: Setting.fetch(:google_client_id),
      client_secret: Setting.fetch(:google_client_secret),
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      scope: [Google::Apis::CalendarV3::AUTH_CALENDAR, "https://www.googleapis.com/auth/userinfo.profile"],
      redirect_uri: calendar_callback_url,
      access_type: :offline,
      prompt: 'consent'
    })

    redirect_to client.authorization_uri.to_s
  end

  def callback
    client = Signet::OAuth2::Client.new({
      client_id: Setting.fetch(:google_client_id),
      client_secret: Setting.fetch(:google_client_secret),
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: calendar_callback_url,
      code: params[:code]
    })

    # Get token data and keep the refresh_token so we stay forever logged in
    client.fetch_access_token!
    Setting.store(:google_refresh_token, client.refresh_token) if client.refresh_token

    redirect_to calendars_url
  end

  private

  def require_refresh_token
    redirect_to '/' unless Setting.present?(:google_refresh_token)
  end
end
