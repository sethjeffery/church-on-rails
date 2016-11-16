class AddNameToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string
    add_index :users, :first_name
    add_column :users, :last_name, :string
    add_index :users, :last_name
    add_column :users, :middle_name, :string
    add_column :users, :prefix, :string
    add_column :users, :suffix, :string
  end
end
