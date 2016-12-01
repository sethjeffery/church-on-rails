class AddChildrenPermissionsToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :children_editor, :boolean
    add_column :teams, :children_reader, :boolean
    add_column :teams, :children_admin,  :boolean
  end
end
