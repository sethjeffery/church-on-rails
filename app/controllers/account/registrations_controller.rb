class Account::RegistrationsController < Devise::RegistrationsController
  before_filter :authorize_church

  def new
    @user = User.new(email: params[:email])
  end

  protected

  def authorize_church
    redirect_to new_session_path(resource_name) unless current_church.can_sign_up?
  end

  def after_sign_up_path_for(resource)
    account_person_path
  end
end
