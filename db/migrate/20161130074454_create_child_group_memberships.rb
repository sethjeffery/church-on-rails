class CreateChildGroupMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :child_group_memberships do |t|
      t.references :child_group, foreign_key: true, index: true
      t.references :person, foreign_key: true, index: true
      t.boolean :checked_in, default: false

      t.timestamps
    end
  end
end
