class People::FamilyMembershipsController < ApplicationController
  load_and_authorize_resource
  before_action :load_and_authorize_family

  def index
    redirect_to family_path(@family)
  end

  def create
    @family_membership.family = @family
    if @family_membership.save
      redirect_to family_path(@family)
    else
      render :new
    end
  end

  def destroy
    @family_membership.destroy

    respond_to do |format|
      format.html { redirect_to @family }
      format.js
    end
  end

  def update
    @family_membership.update_attributes(create_params)
  end

  private

  def create_params
    params.require(:family_membership).permit(:person_id, :head)
  end

  def load_and_authorize_family
    @family = Family.find(params[:family_id])
    authorize! :update, @family
  end
end
