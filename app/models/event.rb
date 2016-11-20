class Event < ApplicationRecord
  include Concerns::Geocoding

  acts_as_schedulable :schedule
  belongs_to :team
  belongs_to :author, class_name: 'Person'

  validates_presence_of :name

  def to_s
    name
  end
end
