class CreateTeamMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :team_memberships do |t|
      t.references :person, foreign_key: true
      t.references :team, foreign_key: true

      t.timestamps
    end
  end
end
