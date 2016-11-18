class AddPermissionsToTeam < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :people_editor, :boolean
    add_column :teams, :people_reader, :boolean
    add_column :teams, :people_admin,  :boolean
  end
end
