class Children::KioskCheckOutsController < ApplicationController
  before_action :load_and_authorize_child_group_membership
  layout 'kiosk'

  def show
    @child_group_checkin = @child_group_membership.child_group_checkins.last
  end

  def update
    checked_out_by = params[:checked_out_by_id] ? Person.find(params[:checked_out_by_id]) : nil
    if @child_group_membership.check_out(checked_out_by)
      respond_to do |format|
        format.html { redirect_to child_group_kiosk_path(@child_group_membership.child_group) }
        format.js { render "children/kiosk_check_ins/update" }
      end
    else
      render :show
    end
  end

  private

  def load_and_authorize_child_group_membership
    @child_group_membership = ChildGroupMembership.find(params[:id])
    authorize! :update, @child_group_membership.child_group
  end
end
