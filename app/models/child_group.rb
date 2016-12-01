class ChildGroup < ApplicationRecord
  has_many :child_group_memberships,  dependent: :destroy
  has_many :people,                   through: :child_group_memberships

  validates_presence_of :name
  validates_uniqueness_of :name

  def to_s
    name
  end
end
