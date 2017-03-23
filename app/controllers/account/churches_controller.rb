class Account::ChurchesController < ApplicationController
  before_action :load_current_church
  load_and_authorize_resource

  def update
    if @church.update_attributes(church_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def load_current_church
    @church = current_church
  end

  def church_params
    params.require(:church).permit(:name, :address1, :address2, :postcode, :country, :cover,
                                   :phone, :email, :charity_number, :can_sign_up)
  end
end
