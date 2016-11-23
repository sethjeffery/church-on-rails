class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to account_path
    else
      if User.exists?
        redirect_to new_user_session_path
      else
        redirect_to new_user_registration_path
      end
    end
  end
end
