class ChildGroupMembership < ApplicationRecord
  belongs_to :child_group
  belongs_to :person

  has_many :child_group_checkins, dependent: :destroy
end
