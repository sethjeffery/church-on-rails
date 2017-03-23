class CreatePersonProcesses < ActiveRecord::Migration[5.0]
  def change
    create_table :person_processes do |t|
      t.references :person, foreign_key: true, index: true
      t.references :church_process, foreign_key: true, index: true
      t.boolean :complete
      t.text :steps

      t.timestamps
    end
  end
end
