class AddAdminToTeam < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :admin, :boolean, default: false
  end
end
