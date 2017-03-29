class AddSearchNameToFamilies < ActiveRecord::Migration[5.0]
  def change
    add_column :families, :search_name, :string

    # update records
    Family.all.each(&:save)
  end
end
