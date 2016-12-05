class People::TeamsController < ApplicationController
  load_and_authorize_resource

  def index
    @teams = @teams.where("lower(name) LIKE ?", "%#{params[:q].downcase}%") if params[:q]
    @teams = @teams.includes(:team_memberships, :people).order(:name).page(params[:page]).per(20)
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

  def destroy
    @team.destroy
    redirect_to teams_path, notice: "#{@team} has been removed from the database."
  end

  private

  def create_params
    if can? :manage, @team
      blanks_to_nil params.require(:team).permit :name, :description, :icon, :color,
                                                 :people_reader,  :people_editor,   :people_admin,
                                                 :event_reader,   :event_editor,    :event_admin,
                                                 :process_reader, :process_editor,  :process_admin,
                                                 :comment_reader, :comment_editor,  :comment_admin
    else
      blanks_to_nil params.require(:team).permit :name, :description
    end
  end
end
