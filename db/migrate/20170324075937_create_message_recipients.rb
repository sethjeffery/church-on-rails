class CreateMessageRecipients < ActiveRecord::Migration[5.0]
  def change
    create_table :message_recipients do |t|
      t.references :message, foreign_key: true, index: true
      t.references :recipient, references: :people
      t.boolean :email, null: false, default: false
      t.boolean :sms, null: false, default: false
      t.boolean :read, null: false, default: false

      t.timestamps
    end

    add_foreign_key :message_recipients, :people, column: :recipient_id
    add_index :message_recipients, [:recipient_id, :read]
  end
end
