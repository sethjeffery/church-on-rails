class AddProcessPermissionsToTeam < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :process_editor, :boolean
    add_column :teams, :process_reader, :boolean
    add_column :teams, :process_admin,  :boolean
    add_column :teams, :event_editor, :boolean
    add_column :teams, :event_reader, :boolean
    add_column :teams, :event_admin,  :boolean
  end
end
