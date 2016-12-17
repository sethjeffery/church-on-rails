class People::PersonProcessesController < ApplicationController
  load_and_authorize_resource
  before_action :load_and_authorize_person

  def new
    @person_process.person = @person
  end

  def create
    @person_process.person = @person
    if @person_process.save
      redirect_to @person
    else
      render :new
    end
  end

  def update
    if @person_process.update_attributes create_params
      redirect_to @person
    else
      render :show
    end
  end

  protected

  def create_params
    params.require(:person_process).permit(:church_process_id, :assignee_ids, :steps, assignee_ids: [], steps: []).tap{|hash|
      hash[:assignee_ids]&.select!(&:present?)
      hash[:steps]&.select!(&:present?)
    }
  end

  def load_and_authorize_person
    @person = Person.find(params[:person_id])
    authorize! :read, @person
  end
end
