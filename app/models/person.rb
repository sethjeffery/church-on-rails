class Person < ApplicationRecord
  include Concerns::Naming
  attr_accessor :family_name

  belongs_to :user, autosave: true
  has_many :family_memberships
  has_many :families, through: :family_memberships, inverse_of: :people
  has_many :team_memberships
  has_many :teams, through: :team_memberships

  validates_presence_of :first_name, :last_name
  validates_inclusion_of :gender, in: %w( m f ), allow_nil: true
  before_validation :copy_changes_to_user
  before_validation :sanitize_names

  def start_family(family_name)
    family = Family.create! name: family_name
    FamilyMembership.create! person: self, family: family
  end

  protected

  def copy_changes_to_user
    user.email = email if email_changed? && email.present? && user.present?
  end

  def sanitize_names
    self.first_name  = capitalize(first_name)  if first_name
    self.middle_name = capitalize(middle_name) if middle_name
    self.last_name   = capitalize(last_name)   if last_name
  end

  def capitalize(name)
    name.slice(0,1).capitalize + name.slice(1..-1)
  end
end
