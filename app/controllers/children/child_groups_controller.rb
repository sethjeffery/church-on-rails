class Children::ChildGroupsController < ApplicationController
  load_and_authorize_resource

  def index
    @child_groups = @child_groups.page(params[:page]).per(20)
  end
end
