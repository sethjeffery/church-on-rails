class ChildGroupCheckin < ApplicationRecord
  belongs_to :child_group_membership
  belongs_to :checked_in_by, class_name: 'Person'
  belongs_to :checked_out_by, class_name: 'Person'

  scope :checked_in,  -> { where.not(checked_in_at: nil) }
  scope :checked_out, -> { where.not(checked_out_at: nil) }

  def checked_in?
    !!checked_in_at
  end

  def checked_out?
    !!checked_out_at
  end
end
