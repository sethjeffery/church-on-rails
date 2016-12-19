class Processes::ChurchProcessesController < ApplicationController
  load_and_authorize_resource

  def index
    @church_processes = @church_processes.includes(:person_processes).includes(:people).order(:search_name).page(params[:page]).per(20)
    @church_processes = @church_processes.where("search_name LIKE ?", "%#{params[:q].downcase}%") if params[:q]
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

  def destroy
    @church_process.destroy
    redirect_to church_processes_path, notice: "#{@church_process} has been removed from the database."
  end

  protected

  def create_params
    params.require(:church_process).permit(:name, :description, :icon, steps: [])
  end
end
