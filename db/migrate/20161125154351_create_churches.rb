class CreateChurches < ActiveRecord::Migration[5.0]
  def change
    create_table :churches do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :postcode
      t.string :country
      t.string :charity_number
      t.string :phone
      t.string :email
      t.text :settings

      t.timestamps
    end
  end
end
