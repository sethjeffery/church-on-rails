class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_person

  protected

  def current_person
    current_user&.person
  end

  def blanks_to_nil(strong_params)
    strong_params.to_h.map{|k, v| v.blank? ? [k, nil] : [k, v]}.to_h.with_indifferent_access
  end
end
