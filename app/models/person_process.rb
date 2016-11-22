class PersonProcess < ApplicationRecord
  delegate :short_name, :name, to: :person
  delegate :icon, :color, to: :church_process

  belongs_to :person
  belongs_to :church_process
  has_many :process_assignees, class_name: 'PersonProcessAssignee'
  has_many :assignees, class_name: 'Person', through: :process_assignees

  serialize :steps

  scope :active,   -> { where("complete != ?", true) }
  scope :complete, -> { where(complete: true) }

  validates_presence_of :person, :church_process
  before_validation :set_complete

  def active?
    !complete?
  end

  def completed_step?(step)
    steps&.include?(step.parameterize)
  end

  def set_complete
    self.complete = !!church_process.steps&.all?{|step| completed_step? step }
  end

  def to_s
    person.to_s
  end
end
