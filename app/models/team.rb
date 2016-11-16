class Team < ApplicationRecord
  has_many :team_memberships
  has_many :people, through: :team_memberships

  scope :admins, -> { where(admin: true) }

  validates :name, presence: true, uniqueness: true

end
