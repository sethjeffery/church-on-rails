class RemoveNameFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_index :users, :first_name
    remove_column :users, :first_name, :string
    remove_index :users, :last_name
    remove_column :users, :last_name, :string
    remove_column :users, :middle_name, :string
    remove_column :users, :prefix, :string
    remove_column :users, :suffix, :string
  end
end
