class AddIconToTeam < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :icon, :string, default: 'users'
    change_column :teams, :color, :string, default: '54aeea'
  end
end
