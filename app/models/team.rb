class Team < ApplicationRecord
  include Concerns::Commentable
  include Concerns::Capitalize

  ICONS = %w(team star laptop pencil music medkit briefcase bullhorn child heart thumbs-up cutlery home map-marker globe car)
  COLORS = %w(54aeea ea695c ea8e2b eccf0f 65d268 da1ae1 c0c0c0 606060)

  has_many :events,           dependent: :destroy
  has_many :team_memberships, dependent: :destroy
  has_many :people,           through: :team_memberships, inverse_of: :teams
  has_many :calendar_teams,   dependent: :destroy

  scope :admins, -> { where(admin: true) }

  validates :name, presence: true, uniqueness: true
  validates :color, format: /\A[0-9a-f]{6}\z/, allow_nil: true

  auto_capitalize :name

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
