class Person < ApplicationRecord
  include Concerns::Naming

  belongs_to :user
  has_many :family_memberships
  has_many :families, through: :family_memberships, inverse_of: :people
  has_many :team_memberships
  has_many :teams, through: :team_memberships

  validates_presence_of :name

  def admin?
    teams.admins.present?
  end
end
