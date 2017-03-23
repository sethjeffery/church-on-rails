class Calendar::SettingsController < ApplicationController
  before_action :authorize_settings

  def show
    @settings = CalendarSettings.new
  end

  def update
    @settings = CalendarSettings.new
    if @settings.update_attributes(params[:calendar_settings])
      redirect_to calendar_path, notice: 'Calendar settings updated!'
    else
      render :show
    end
  end

  private

  def authorize_settings
    authorize! :update, Calendar
  end
end
