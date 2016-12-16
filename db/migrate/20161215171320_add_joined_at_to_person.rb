class AddJoinedAtToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :joined_at, :date
  end
end
