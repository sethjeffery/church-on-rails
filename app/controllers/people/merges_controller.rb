class People::MergesController < ApplicationController
  before_action :load_and_authorize_person

  def update
    if merge_params[:merger_id].present?
      merger = Person.find(merge_params[:merger_id])
      @person.merge_into(merger)
      redirect_to merger, notice: "Records merged successfully."
    else
      render :show
    end
  end

  private

  def merge_params
    params.require(:merge).permit(:merger_id)
  end

  def load_and_authorize_person
    @person = Person.find(params[:person_id])
    authorize! :manage, @person
  end
end
