class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :description
      t.references :person, foreign_key: true, index: true
      t.references :commentable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
