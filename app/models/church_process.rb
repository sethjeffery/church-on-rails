class ChurchProcess < ApplicationRecord
  ICONS = %w(arrow-right star link pencil music smile-o frown-o heart thumbs-up wheelchair home phone user-plus male female child)
  COLORS = %w(e34747 ea8e2b f1df12 1ac63b 1aa7e1 da1ae1 c0c0c0 606060)

  has_many :person_processes
  has_many :people, through: :person_processes

  serialize :steps

  validates :name, presence: true, uniqueness: true
  validates :color, format: /\A[0-9a-f]{6}\z/, allow_nil: true

  after_initialize :generate_steps
  after_validation :compact_steps

  def generate_steps
    self.steps ||= ["", "", ""]
  end

  def compact_steps
    self.steps.select!(&:present?) unless errors.present?
  end

  def active_processes_count
    active_processes.count
  end

  def active_processes
    person_processes.select(&:active?)
  end

  def to_s
    name
  end
end
