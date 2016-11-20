class Team < ApplicationRecord
  ICONS = %w(users star laptop pencil music medkit briefcase bullhorn child heart thumbs-up cutlery home map-marker globe car)
  COLORS = %w(e34747 ea8e2b f1df12 1ac63b 1aa7e1 da1ae1 c0c0c0 606060)

  has_many :team_memberships
  has_many :people, through: :team_memberships
  has_many :events

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
