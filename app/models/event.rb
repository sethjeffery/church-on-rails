class Event < ApplicationRecord
  include Concerns::Geocoding

  acts_as_schedulable :schedule
  belongs_to :team
  belongs_to :author, class_name: 'Person'

  scope :upcoming, -> { joins(:schedule).includes(:schedule).where('(until >= datetime(\'NOW\') OR until IS NULL) AND (date >= datetime(\'NOW\') OR rule != \'singular\')') }

  validates_presence_of :name

  def to_s
    name
  end
end
