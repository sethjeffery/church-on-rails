class Person < ApplicationRecord
  include Concerns::Naming

  belongs_to :user
  has_many :family_memberships
  has_many :families, through: :family_memberships, inverse_of: :people
  has_many :team_memberships
  has_many :teams, through: :team_memberships

  validates_presence_of :first_name, :last_name
  validates_inclusion_of :gender, in: %w( m f ), allow_nil: true

  def admin?
    teams.admins.present?
  end

  def assign_families(family_ids)
    if family_ids.present?
      Array.wrap(family_ids).compact.each do |family_id|
        FamilyMembership.create user_id: id, family_id: family_id
      end
    end
  end

  def assign_teams(team_ids)
    if team_ids.present?
      Array.wrap(team_ids).compact.each do |team_id|
        TeamMembership.create user_id: id, team_id: team_id
      end
    end
  end
end
