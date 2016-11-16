class AddAddressToFamily < ActiveRecord::Migration[5.0]
  def change
    add_column :families, :address1, :string
    add_column :families, :address2, :string
    add_column :families, :city, :string
    add_column :families, :postcode, :string
    add_column :families, :country, :string
  end
end
