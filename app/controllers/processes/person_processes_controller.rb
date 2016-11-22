class Processes::PersonProcessesController < ApplicationController
  load_and_authorize_resource
  before_action :load_and_authorize_church_process

  def new
    @person_process.church_process = @church_process
  end

  def create
    @person_process.church_process = @church_process
    if @person_process.save
      redirect_to @church_process
    else
      render :new
    end
  end

  def update
    if @person_process.update_attributes create_params
      redirect_to @church_process
    else
      render :show
    end
  end

  protected

  def create_params
    params.require(:person_process).permit(:person_id, :assignee_ids, :steps, assignee_ids: [], steps: []).tap{|hash|
      hash[:assignee_ids].select!(&:present?)
      hash[:steps].select!(&:present?)
    }
  end

  def load_and_authorize_church_process
    @church_process = ChurchProcess.find(params[:church_process_id])
    authorize! :read, @church_process
  end
end
