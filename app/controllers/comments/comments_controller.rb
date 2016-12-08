class Comments::CommentsController < ApplicationController
  load_and_authorize_resource

  def create
    @comment.person = current_person
    @comment.save
  end

  protected

  def create_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :description)
  end
end
