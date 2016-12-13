class CreateProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :properties do |t|
      t.string :name
      t.string :format, default: 'flag'
      t.text :list
      t.string :icon, default: 'property'
      t.string :description

      t.timestamps
    end
  end
end
