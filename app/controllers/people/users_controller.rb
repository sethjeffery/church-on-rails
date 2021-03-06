class People::UsersController < ApplicationController
  load_and_authorize_resource
  before_action :load_and_authorize_person

  def new
    @user.email = @person.email unless @user.email.present?
  end

  def create
    # Admin created the user so we don't need confirmation email to be sent.
    @user.skip_confirmation!

    if @user.save
      @person.update_attributes user: @user
      redirect_to @person, notice: "Account created successfully"
    else
      render :new
    end
  end

  private

  def create_params
    params.require(:user).permit(:email, :password)
  end

  def load_and_authorize_person
    @person = Person.find(params[:person_id])
    authorize! :update, @person
  end
end
