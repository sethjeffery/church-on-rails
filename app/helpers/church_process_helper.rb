module ChurchProcessHelper
  def all_church_processes
    ChurchProcess.all.order(:name)
  end
end
