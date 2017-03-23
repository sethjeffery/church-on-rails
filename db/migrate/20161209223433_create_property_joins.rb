class CreatePropertyJoins < ActiveRecord::Migration[5.0]
  def change
    create_table :property_joins do |t|
      t.references :propertyable, polymorphic: true, index: true
      t.references :property, foreign_key: true, index: true
      t.string :value

      t.timestamps
    end
  end
end
