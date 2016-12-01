class Children::ChildGroupsController < ApplicationController
  load_and_authorize_resource

  def index
    @child_groups = @child_groups.page(params[:page]).per(20)
  end

  def create
    if @child_group.save
      redirect_to @child_group
    else
      render :new
    end
  end

  def update
    if @child_group.update_attributes create_params
      redirect_to @child_group
    else
      render :edit
    end
  end
  private

  def create_params
    params.require(:child_group).permit(:name, :age_group, :description)
  end
end
