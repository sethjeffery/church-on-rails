class Account::SettingsController < ApplicationController
  before_action :authorize_settings

  def show
    settings = Setting.all.map{|setting| [setting.key, setting.value]}.to_h
    settings.reverse_merge!(ENV)
    @settings = SettingsList.new(settings)
  end

  def update
    @settings = SettingsList.new(settings_params)
    @settings.save
    flash.now[:info] = "Settings updated!"
    render :show
  end

  private

  def settings_params
    params.require(:settings_list).permit!
  end

  def authorize_settings
    authorize! :update, Setting
  end
end
