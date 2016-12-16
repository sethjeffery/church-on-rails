class AddGenderIndexToPeople < ActiveRecord::Migration[5.0]
  def change
    add_index :people, :gender
  end
end
