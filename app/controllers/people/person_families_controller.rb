module People
  class PersonFamiliesController < ApplicationController
    before_action :load_and_authorize_person

    def update
      if @person.update_attributes update_params
        start_family if update_params[:family_name].present?
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
      authorize! :edit, @person
    end

    def start_family
      @person.start_family(update_params[:family_name]) if @person.families.blank?
    end
  end
end
