class CreateChildGroupCheckins < ActiveRecord::Migration[5.0]
  def change
    create_table :child_group_checkins do |t|
      t.references :child_group_membership, foreign_key: true
      t.datetime :checked_in_at
      t.datetime :checked_out_at
      t.references :checked_in_by, references: :people
      t.references :checked_out_by, references: :people

      t.timestamps
    end

    add_foreign_key :child_group_checkins, :people, column: :checked_in_by_id
    add_foreign_key :child_group_checkins, :people, column: :checked_out_by_id
  end
end
