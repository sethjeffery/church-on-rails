class TeamsController < ApplicationController
  load_and_authorize_resource

  def index
    @teams.includes(:team_memberships)
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
    blanks_to_nil params.require(:team).permit(:name)
  end
end
