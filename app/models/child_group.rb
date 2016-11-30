class ChildGroup < ApplicationRecord
  has_many :child_group_memberships, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
end
