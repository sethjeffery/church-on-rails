class AddContactToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :email, :string
    add_column :people, :phone, :string
  end
end
