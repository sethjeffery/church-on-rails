module People
  class TeamsController < ApplicationController
    load_and_authorize_resource

    def index
      @teams = @teams.where("name LIKE ?", "%#{params[:q]}%") if params[:q]
      @teams = @teams.includes(:team_memberships, :people).order(:name).page(params[:page]).per(20)
    end

    def new
      @team.color = Team::COLORS.first
    end

    def create
      if @team.save
        redirect_to team_path @team
      else
        render :new
      end
    end

    def update
      if @team.update_attributes(create_params)
        redirect_to team_path @team
      else
        render :edit
      end
    end

    private

    def create_params
      if can? :manage, @team
        blanks_to_nil params.require(:team).permit :name, :description, :icon, :color,
                                                   :people_reader, :people_editor, :people_admin
      else
        blanks_to_nil params.require(:team).permit :name, :description
      end
    end
  end
end
