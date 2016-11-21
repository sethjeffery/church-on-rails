class CreatePersonProcessAssignees < ActiveRecord::Migration[5.0]
  def change
    create_table :person_process_assignees do |t|
      t.references :assignee, foreign_key: true
      t.references :person_process, foreign_key: true

      t.timestamps
    end
  end
end
