class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :subject
      t.text :message
      t.references :sender, references: :people, index: true

      t.timestamps
    end

    add_foreign_key :messages, :people, column: :sender_id
  end
end
