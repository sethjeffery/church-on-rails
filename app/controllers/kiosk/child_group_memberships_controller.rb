class Kiosk::ChildGroupMembershipsController < Children::ChildGroupMembershipsController
  layout 'kiosk'

  def create
    @child_group_membership.child_group = @child_group
    if @child_group_membership.save
      start_family if create_params[:person].try(:[], :family_name).present?
      redirect_to kiosk_child_group_path(@child_group_membership.child_group)
    else
      @child_group_membership.person ||= Person.new
      render :new
    end
  end
end
