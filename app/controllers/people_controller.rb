class PeopleController < ApplicationController
  load_and_authorize_resource

  def create
    if @person.save
      @person.assign_families create_params[:family_ids]
      @person.assign_teams create_params[:team_ids]
      redirect_to person_path(@person)
    else
      render :new
    end
  end

  def update
    if @person.update_attributes(update_params)
      redirect_to person_path(@person)
    else
      render :edit
    end
  end

  private

  def create_params
    blanks_to_nil params.require(:person).permit(:first_name, :last_name, :prefix, :suffix, :dob, :gender, :email, :phone,
                                                 :family_ids, :team_ids, family_ids: [], team_ids: [])
  end

  def update_params
    blanks_to_nil params.require(:person).permit(:first_name, :last_name, :prefix, :suffix, :dob, :gender, :email, :phone)
  end
end
