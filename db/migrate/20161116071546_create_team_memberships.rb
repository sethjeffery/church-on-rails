class CreateTeamMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :team_memberships do |t|
      t.references :person, foreign_key: true, index: true
      t.references :team, foreign_key: true, index: true

      t.timestamps
    end
  end
end
