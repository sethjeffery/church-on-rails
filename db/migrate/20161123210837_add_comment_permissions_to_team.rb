class AddCommentPermissionsToTeam < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :comment_editor, :boolean
    add_column :teams, :comment_reader, :boolean
    add_column :teams, :comment_admin, :boolean
  end
end
