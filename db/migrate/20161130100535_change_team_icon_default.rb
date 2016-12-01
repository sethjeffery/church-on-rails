class ChangeTeamIconDefault < ActiveRecord::Migration[5.0]
  def self.up
    change_column :teams, :icon, :string, default: 'team'
  end

  def self.down
    change_column :teams, :icon, :string, default: 'users'
  end
end
