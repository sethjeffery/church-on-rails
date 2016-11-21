class Events::EventsController < ApplicationController
  load_and_authorize_resource

  def index
    @events = @events.upcoming
  end

  def new
    @event.team_id = params[:team_id]
  end

  def create
    @event.author = current_user
    if @event.save
      redirect_to @event
    else
      render :new
    end
  end

  def update
    if @event.update_attributes create_params
      redirect_to @event
    else
      render :edit
    end
  end

  protected

  def create_params
    params.require(:event).permit(:author_id, :team_id, :name, :description, :address1, :address2, :postcode, :country, schedule_attributes: Schedulable::ScheduleSupport.param_names)
  end
end
