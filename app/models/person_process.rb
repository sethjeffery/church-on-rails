class PersonProcess < ApplicationRecord
  include Concerns::Commentable

  delegate :short_name, :name, to: :person
  delegate :icon, to: :church_process

  belongs_to :person
  belongs_to :church_process
  has_many :process_assignees,  dependent: :destroy, class_name: 'PersonProcessAssignee', inverse_of: :person_process
  has_many :assignees,          through: :process_assignees, class_name: 'Person'

  serialize :steps

  scope :active,   -> { where(complete: nil) }
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
    if church_process&.steps&.all?{|step| completed_step? step }
      self.complete = true
    end
  end

  def to_s
    person.to_s
  end
end
