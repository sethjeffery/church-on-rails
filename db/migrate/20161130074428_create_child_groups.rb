class CreateChildGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :child_groups do |t|
      t.string :name
      t.string :description
      t.string :age_group

      t.timestamps
    end
  end
end
