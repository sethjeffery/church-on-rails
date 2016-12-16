class AddSearchNameToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :search_name, :string

    # update records
    Person.all.each(&:save)
  end
end
