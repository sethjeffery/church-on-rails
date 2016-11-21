class Processes::ChurchProcessesController < ApplicationController
  load_and_authorize_resource

  def index
    @church_processes = @church_processes.includes(:person_processes).includes(:people)
  end

  def new
    @church_process.color = ChurchProcess::COLORS.sample
  end

  def create
    if @church_process.save
      redirect_to @church_process
    else
      render :new
    end
  end

  def update
    if @church_process.update_attributes create_params
      redirect_to @church_process
    else
      render :edit
    end
  end

  protected

  def create_params
    params.require(:church_process).permit(:name, :description, :icon, :color, steps: [])
  end
end
