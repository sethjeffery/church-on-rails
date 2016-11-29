class AddBetterSettingsToChurch < ActiveRecord::Migration[5.0]
  def self.up
    add_column :churches, :can_sign_up, :boolean, default: true
    remove_column :churches, :settings, :text
  end

  def self.down
    add_column :churches, :settings, :text
    remove_column :churches, :can_sign_up, :boolean
  end
end
