class People::PasswordsController < ApplicationController
  before_action :load_and_authorize_person

  def update
    if @person.user.update_attributes(password: user_params[:password])
      bypass_sign_in(@person.user) if @person.user.id == current_user.id
      redirect_to person_path(@person), notice: "Password updated successfully."
    else
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:password)
  end

  def load_and_authorize_person
    @person = Person.find(params[:person_id])
    authorize! :manage, @person
  end
end
