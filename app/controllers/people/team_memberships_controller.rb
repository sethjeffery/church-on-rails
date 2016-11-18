module People
  class TeamMembershipsController < ApplicationController
    load_and_authorize_resource
    before_action :load_and_authorize_team

    def index
      redirect_to team_path(@team)
    end

    def create
      if @team_membership.save
        redirect_to team_path(@team)
      else
        render :new
      end
    end

    def destroy
      @team_membership.destroy
    end

    private

    def create_params
      params.require(:team_membership).permit(:person_id, :team_id)
    end

    def load_and_authorize_team
      @team = Team.find(params[:team_id])
      authorize! :edit, @team
    end
  end
end
