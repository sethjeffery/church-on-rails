class Team < ApplicationRecord
  has_many :team_memberships
  has_many :people, through: :team_memberships

  scope :admins, -> { where(admin: true) }

  validates :name, presence: true, uniqueness: true
  validates :color, format: /\A[0-9a-f]{6}\z/, allow_nil: true

  def has_permissions?
    admin? || has_permissions_for?(:people)
  end

  def has_permissions_for?(resource)
    try(:"#{resource}_reader?") || try(:"#{resource}_editor?") || try(:"#{resource}_admin?")
  end

  def to_s
    name
  end
end
