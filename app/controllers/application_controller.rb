class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_person
  helper_method :current_church

  protected

  def current_person
    current_user&.person
  end

  def current_church
    @current_church ||= Church.first || Church.new(name: 'Church-on-Rails')
  end

  def blanks_to_nil(strong_params)
    strong_params.to_h.map{|k, v| v.blank? ? [k, nil] : [k, v]}.to_h.with_indifferent_access if strong_params
  end
end
