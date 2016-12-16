module ChurchProcessHelper
  def all_church_processes
    ChurchProcess.all.order(:name)
  end

  def all_person_processes
    PersonProcess.active.includes(:church_process)
  end
end
