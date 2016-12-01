class ChildGroupMembership < ApplicationRecord
  delegate :to_s, :name, to: :person

  belongs_to :child_group
  belongs_to :person, autosave: true

  has_many :child_group_checkins, dependent: :destroy

  validates_presence_of :person, :child_group_id

  scope :checked_in, ->{ where(checked_in: true) }
  scope :checked_out, ->{ where(checked_in: false) }

  def check_in(check_in_by=nil)
    unless checked_in?
      child_group_checkins.create checked_in_by: check_in_by, checked_in_at: Time.now
      update_attributes checked_in: true
    end
  end

  def check_out(check_out_by=nil)
    unless checked_out?
      child_group_checkins.last.update_attributes checked_out_by: check_out_by, checked_out_at: Time.now
      update_attributes checked_in: false
    end
  end

  def checked_out?
    !checked_in?
  end

  def person=(person)
    if person.is_a?(Hash)
      super Person.new(person)
    else
      super
    end
  end
end
