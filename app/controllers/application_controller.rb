class ApplicationController < ActionController::Base
  include UsersHelper

  PAGE_SIZE = 20

  protect_from_forgery with: :exception
  helper_method :current_person

  protected

  def current_person
    current_user&.person
  end

  def blanks_to_nil(strong_params)
    strong_params.to_h.map{|k, v| v.blank? ? [k, nil] : [k, v]}.to_h.with_indifferent_access if strong_params
  end

  def track(type, args={})
    Action.create!({ action_type: type }.merge(args))
  end
end
