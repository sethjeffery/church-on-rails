class CreateFamilyMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :family_memberships do |t|
      t.references :family, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
