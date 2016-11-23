module People
  class PeopleController < ApplicationController
    load_and_authorize_resource

    def index
      @people = @people.where("first_name LIKE ? OR last_name LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q]
      @people = @people.includes(:teams).order(:first_name, :last_name).page(params[:page]).per(20)
    end

    def create
      if @person.save
        if create_params[:family_name].present? && @person.families.blank?
          @person.start_family(create_params[:family_name])
        end

        redirect_to show_path
      else
        render :new
      end
    end

    def update
      if @person.update_attributes(create_params)
        redirect_to show_path
      else
        render :edit
      end
    end

    private

    def new_params
      params.require(:person).permit(:first_name, :last_name)
    end

    def create_params
      fields      = [ :first_name, :middle_name, :last_name, :prefix, :suffix, :dob, :gender, :email, :phone ]
      fields.concat [ :family_name, :family_ids, family_ids: []]    if can? :create, FamilyMembership
      fields.concat [ :team_ids, team_ids: []]                      if can? :create, TeamMembership

      hash = blanks_to_nil(params.require(:person).permit(*fields))
      hash.delete(:family_ids) if hash[:family_ids] == "New"
      hash
    end

    def show_path
      if @person == current_user.person
        account_path
      else
        person_path(@person)
      end
    end
  end
end
