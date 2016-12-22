class People::PersonFamiliesController < ApplicationController
  before_action :load_and_authorize_person

  def update
    if update_params[:family_name].present?
      start_family
      redirect_to person_path(@person)
    elsif update_params[:family_ids].present?
      join_family
      redirect_to person_path(@person)
    else
      render :show
    end
  end

  private

  def update_params
    hash = blanks_to_nil params.require(:person).permit(:head, :family_name, :family_ids, family_ids: [])
    hash.delete(:family_ids) if hash[:family_ids] == "New"
    hash
  end

  def load_and_authorize_person
    @person = Person.find(params[:person_id])
    authorize! :update, @person
  end

  def start_family
    @person.start_family(update_params[:family_name]) if @person.families.blank?
  end

  def join_family
    Array.wrap(update_params[:family_ids]).each do |id|
      family = Family.find(id)
      @person.join family, head: @person.years_old.to_i >= 21
    end
  end
end
