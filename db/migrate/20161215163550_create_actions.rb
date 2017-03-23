class CreateActions < ActiveRecord::Migration[5.0]
  def change
    create_table :actions do |t|
      t.string :action_type
      t.references :actor, references: :people, index: true
      t.references :actionable, polymorphic: true, index: true
      t.text :data

      t.timestamps
    end

    add_foreign_key :actions, :people, column: :actor_id

    add_index :actions, [:action_type, :created_at]
    add_index :actions, [:actor_id,   :action_type]
  end
end
