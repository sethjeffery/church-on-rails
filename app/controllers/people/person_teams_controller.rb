class People::PersonTeamsController < ApplicationController
  before_action :load_and_authorize_person

  def update
    if @person.update_attributes update_params
      redirect_to person_path(@person)
    else
      render :new
    end
  end

  private

  def update_params
    blanks_to_nil params.require(:person).permit(:team_ids, team_ids: [])
  end

  def load_and_authorize_person
    @person = Person.find(params[:person_id])
    authorize! :update, @person
  end
end
