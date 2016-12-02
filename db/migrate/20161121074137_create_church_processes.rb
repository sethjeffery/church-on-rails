class CreateChurchProcesses < ActiveRecord::Migration[5.0]
  def change
    create_table :church_processes do |t|
      t.string :name
      t.string :icon, default: 'arrow-right'
      t.text :description
      t.text :steps

      t.timestamps
    end
  end
end
