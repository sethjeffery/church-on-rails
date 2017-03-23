require 'google/apis/calendar_v3/event'
require 'google_calendar_service'

class Calendar::CalendarsController < ApplicationController
  before_action :require_refresh_token, only: :show

  def show
    @calendars = CalendarTeam.for(current_person)
    @events = @calendars.each_with_index.flat_map{|calendar, index|
      calendar.events(start_date: params[:start_date]).map{|item|
        item.calendar_index = index
        item
      }
    }
  end

  def redirect
    client = build_client({
      scope: [Google::Apis::CalendarV3::AUTH_CALENDAR, "https://www.googleapis.com/auth/userinfo.profile"],
      access_type: :offline,
      prompt: 'consent'
    })

    redirect_to client.authorization_uri.to_s
  end

  def callback
    store_access_token!
    redirect_to account_settings_path
  end

  private

  def store_access_token!
    # Get token data and keep the refresh_token so we stay forever logged in
    client = build_client(code: params[:code])
    client.fetch_access_token!
    Setting.store(:google_refresh_token, client.refresh_token) if client.refresh_token
  end

  def build_client(opts={})
    Signet::OAuth2::Client.new({
      client_id: Setting.fetch(:google_client_id),
      client_secret: Setting.fetch(:google_client_secret),
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: calendar_callback_url,
    }.merge(opts))
  end

  def require_refresh_token
    unless Setting.present?(:google_refresh_token)
      if can?(:update, Setting)
        redirect_to account_settings_path
      else
        redirect_to root_path
      end
    end
  end
end
