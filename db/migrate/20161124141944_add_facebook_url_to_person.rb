class AddFacebookUrlToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :facebook, :string
    add_column :people, :twitter, :string
  end
end
