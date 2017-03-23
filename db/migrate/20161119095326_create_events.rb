class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.references :author, index: true
      t.references :team, index: true
      t.string :name
      t.string :address1
      t.string :address2
      t.string :postcode
      t.string :country
      t.text :description

      t.timestamps
    end
  end
end
