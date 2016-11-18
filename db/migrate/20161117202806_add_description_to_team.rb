class AddDescriptionToTeam < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :description, :text
    add_column :teams, :color, :string
  end
end
