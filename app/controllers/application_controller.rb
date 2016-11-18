class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def blanks_to_nil(strong_params)
    strong_params.to_h.map{|k, v| v.blank? ? [k, nil] : [k, v]}.to_h.with_indifferent_access
  end
end
