class Event < ApplicationRecord
  include Concerns::Geocoding

  acts_as_schedulable :schedule
  belongs_to :team
  belongs_to :author, class_name: 'Person'

  scope :upcoming, -> { joins(:schedule).includes(:schedule).where('(until >= ? OR until IS NULL) AND (date >= ? OR rule != ?)', Time.zone.now, Time.zone.now, 'singular') }

  validates_presence_of :name

  def self.sort_by_closest
    all.sort_by{|event| event.schedule.next_datetime }
  end

  def to_s
    name
  end
end
