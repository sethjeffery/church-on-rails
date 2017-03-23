class CreateCalendarTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :calendar_teams do |t|
      t.references :team, foreign_key: true, index: true
      t.string :calendar_id

      t.timestamps
    end
  end
end
