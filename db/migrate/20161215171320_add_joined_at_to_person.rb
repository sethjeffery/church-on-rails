class AddJoinedAtToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :joined_at, :date
    add_index :people, :joined_at
  end
end
