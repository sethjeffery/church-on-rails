class ChangeTeamIconDefault < ActiveRecord::Migration[5.0]
  def change
    change_column :teams, :icon, :string, default: 'team'
  end
end
