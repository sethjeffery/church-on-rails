class Account::PeopleController < ApplicationController
  before_action :require_confirmation, except: [:show]
  before_action :require_person, only: [:show, :edit, :update]

  def show
    render :unconfirmed unless current_user.confirmed?
  end

  def edit
    render :new
  end

  def new
    @person = Person.new
    redirect_to edit_account_person_path if current_person.present?
  end

  def create
    @person = Person.new(create_params)
    @person.user = current_user
    @person.email ||= current_user.email

    if @person.save
      if Person.count == 1 && !Team.exists?
        FirstPersonJob.perform_now(@person)
        redirect_to account_welcome_path
      else
        redirect_to account_path
      end
    else
      render :new
    end
  end

  private

  def require_confirmation
    redirect_to account_person_path unless current_user.confirmed?
  end

  def require_person
    redirect_to new_account_person_path if current_person.blank? && current_user.confirmed?
    @person = current_person
  end

  def create_params
    blanks_to_nil params.require(:person).permit(:first_name, :last_name, :prefix, :suffix, :dob, :gender, :phone)
  end
end
