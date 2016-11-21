class PersonProcessAssignee < ApplicationRecord
  belongs_to :assignee, class_name: 'Person'
  belongs_to :person_process

  validates_presence_of :person_process, :assignee
end
