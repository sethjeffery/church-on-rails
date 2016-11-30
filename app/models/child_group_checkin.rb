class ChildGroupCheckin < ApplicationRecord
  belongs_to :child_group_membership
  belongs_to :checked_in_by, class_name: 'Person'
  belongs_to :checked_out_by, class_name: 'Person'
end
