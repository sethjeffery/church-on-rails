class Kiosk::CheckInsController < ApplicationController
  before_action :load_and_authorize_child_group_membership
  layout 'kiosk'

  def show
    @child_group_checkin = @child_group_membership.child_group_checkins.new
  end

  def update
    checked_in_by = params[:checked_in_by_id] ? Person.find(params[:checked_in_by_id]) : nil
    if @child_group_membership.check_in(checked_in_by)
      respond_to do |format|
        format.html { redirect_to kiosk_child_group_path(@child_group_membership.child_group) }
        format.js
      end
    else
      render :show
    end
  end

  private

  def load_child_group_checkin
    @child_group_checkin = @child_group_membership.child_group_checkins.new
  end

  def load_and_authorize_child_group_membership
    @child_group_membership = ChildGroupMembership.find(params[:id])
    authorize! :update, @child_group_membership.child_group
  end
end
