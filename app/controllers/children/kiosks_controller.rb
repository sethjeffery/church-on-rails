class Children::KiosksController < ApplicationController
  before_action :load_and_authorize_child_group
  layout 'kiosk'

  private

  def load_and_authorize_child_group
    @child_group = ChildGroup.find(params[:child_group_id])
    authorize! :update, @child_group
  end
end
