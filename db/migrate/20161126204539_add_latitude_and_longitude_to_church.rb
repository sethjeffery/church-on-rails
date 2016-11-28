class AddLatitudeAndLongitudeToChurch < ActiveRecord::Migration[5.0]
  def change
    add_column :churches, :latitude, :float
    add_column :churches, :longitude, :float
  end
end
