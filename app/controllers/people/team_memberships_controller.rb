class People::TeamMembershipsController < ApplicationController
  load_and_authorize_resource
  before_action :load_and_authorize_team

  def index
    redirect_to team_path(@team)
  end

  def create
    @team_membership.team = @team
    if @team_membership.save
      redirect_to team_path(@team)
    else
      render :new
    end
  end

  def destroy
    @team_membership.destroy

    respond_to do |format|
      format.html { redirect_to @team }
      format.js
    end
  end

  private

  def create_params
    params.require(:team_membership).permit(:person_id, :team_id)
  end

  def load_and_authorize_team
    @team = Team.find(params[:team_id])
    authorize! :update, @team
  end
end
