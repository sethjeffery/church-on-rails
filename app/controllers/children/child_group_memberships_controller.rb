class Children::ChildGroupMembershipsController < ApplicationController
  load_and_authorize_resource
  before_action :load_and_authorize_child_group

  def new
    @child_group_membership.person = Person.new
    @child_group_membership.child_group = @child_group
  end

  def index
    redirect_to @child_group
  end

  def create
    @child_group_membership.child_group = @child_group
    if @child_group_membership.save
      start_family if create_params[:person].try(:[], :family_name).present?
      redirect_to @child_group
    else
      @child_group_membership.person ||= Person.new
      render :new
    end
  end

  def destroy
    @child_group_membership.destroy

    respond_to do |format|
      format.html { redirect_to @child_group }
      format.js
    end
  end

  private

  def create_params
    hash = blanks_to_nil params.require(:child_group_membership).permit :person_id, person: [
      :first_name, :middle_name, :last_name, :gender, :dob, :family_ids, :family_name, family_ids: []
    ]

    hash[:person].delete(:family_ids) if hash[:person].try(:[], :family_ids) == "New"
    hash[:person] = blanks_to_nil hash[:person]
    hash.delete(:person) unless hash[:person_id] == "New"
    hash.delete(:person_id) if hash[:person_id] == "New"
    hash
  end

  def load_and_authorize_child_group
    @child_group = ChildGroup.find(params[:child_group_id])
    authorize! :update, @child_group
  end

  def start_family
    @child_group_membership.person.start_family(create_params[:person][:family_name]) if @child_group_membership.person.families.blank?
  end
end
