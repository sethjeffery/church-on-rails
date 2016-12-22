class PersonProcessAssignee < ApplicationRecord
  belongs_to :assignee, class_name: 'Person'
  belongs_to :person_process

  validates_presence_of :person_process, :assignee

  after_create :send_emails

  def send_emails
    ProcessMailer.assigned_to_process(self).deliver_now if assignee&.email.present?
  end
end
