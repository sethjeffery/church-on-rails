class ChurchProcess < ApplicationRecord
  include Concerns::Commentable

  ICONS = %w(arrow-right star link pencil music smile-o frown-o heart thumbs-up wheelchair home phone user-plus male female child)
  COLORS = %w(65d268)

  has_many :person_processes, dependent: :destroy
  has_many :people,           through: :person_processes

  serialize :steps

  validates :name, presence: true, uniqueness: true

  after_initialize :generate_steps
  after_validation :compact_steps
  before_validation :update_search_name

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

  def update_search_name
    self.search_name = name.downcase
  end
end
