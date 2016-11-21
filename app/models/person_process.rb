class PersonProcess < ApplicationRecord
  delegate :short_name, :name, to: :person

  belongs_to :person
  belongs_to :church_process
  has_many :assignees, class_name: 'PersonProcessAssignee'

  serialize :steps

  scope :active,   -> { where("complete != ?", true) }
  scope :complete, -> { where(complete: true) }

  validates_presence_of :person, :church_process

  def active?
    !complete?
  end

  def to_s
    person.to_s
  end
end
