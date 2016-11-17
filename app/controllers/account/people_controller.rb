class Account::PeopleController < ApplicationController
  before_action :require_person, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def new
    @person = Person.new
    redirect_to edit_account_person_path if current_user.person.present?
  end

  def create
    @person = Person.new(create_params)
    @person.user = current_user

    if @person.save
      redirect_to account_person_path
    else
      render :new
    end
  end

  private

  def require_person
    redirect_to new_account_person_path unless current_user.person.present?
    @person = current_user.person
  end

  def create_params
    blanks_to_nil params.require(:person).permit(:first_name, :last_name, :prefix, :suffix, :dob, :gender, :phone)
  end
end
