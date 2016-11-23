class CreatePersonProcessAssignees < ActiveRecord::Migration[5.0]
  def change
    create_table :person_process_assignees do |t|
      t.references :assignee, references: :people
      t.references :person_process, foreign_key: true
      t.timestamps
    end

    add_foreign_key :person_process_assignees, :people, column: :assignee_id
  end
end
