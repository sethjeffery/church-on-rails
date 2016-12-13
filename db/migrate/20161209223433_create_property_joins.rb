class CreatePropertyJoins < ActiveRecord::Migration[5.0]
  def change
    create_table :property_joins do |t|
      t.references :propertyable, polymorphic: true
      t.references :property, foreign_key: true
      t.string :value

      t.timestamps
    end
  end
end
