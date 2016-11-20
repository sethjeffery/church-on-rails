class AddLatitudeAndLongitudeToFamily < ActiveRecord::Migration[5.0]
  def change
    add_column :families, :latitude, :float
    add_column :families, :longitude, :float
  end
end
