class AddSearchNameToChurchProcesses < ActiveRecord::Migration[5.0]
  def change
    add_column :church_processes, :search_name, :string

    # update records
    ChurchProcess.all.each(&:save)
  end
end
