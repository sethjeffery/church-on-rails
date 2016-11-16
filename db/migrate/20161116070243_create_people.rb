class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.references :user
      t.string :first_name
      t.string :last_name
      t.string :prefix
      t.string :suffix
      t.string :middle_name
      t.date :dob

      t.timestamps
    end
    add_index :people, :first_name
    add_index :people, :last_name
  end
end
