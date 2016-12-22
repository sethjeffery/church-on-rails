class ProcessMailer < ApplicationMailer
  def assigned_to_process(person_process_assignee)
    @assignee = person_process_assignee.assignee
    @person_process = person_process_assignee.person_process
    mail(to: @assignee.email, subject: 'Assigned to process')
  end

  def completed_process(person_process_assignee)
    @assignee = person_process_assignee.assignee
    @person_process = person_process_assignee.person_process
    mail(to: @assignee.email, subject: 'Completed process')
  end
end
