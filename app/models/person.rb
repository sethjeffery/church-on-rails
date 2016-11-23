class Person < ApplicationRecord
  include Concerns::Naming
  attr_accessor :family_name

  belongs_to :user, autosave: true
  has_many :family_memberships
  has_many :families, through: :family_memberships, inverse_of: :people
  has_many :team_memberships
  has_many :teams, through: :team_memberships, inverse_of: :people
  has_many :events, inverse_of: :author
  has_many :person_processes

  validates_presence_of :first_name, :last_name
  validates_inclusion_of :gender, in: %w( m f ), allow_nil: true
  before_validation :copy_changes_to_user
  before_validation :sanitize_names

  def start_family(family_name)
    join Family.create(name: family_name), head: true
  end

  def join(group, args={})
    save if new_record?

    if group.is_a? Family
      join_family group, args

    elsif group.is_a? Team
      join_team group, args

    else
      raise "Unexpected type #{group.class.name}"
    end
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

  def join_team(team, args={})
    team_memberships.create({ team: team }.merge(args))
  end

  def join_family(family, args={})
    family_memberships.create({ family: family }.merge(args))
  end

  def capitalize(name)
    name.slice(0,1).capitalize + name.slice(1..-1)
  end
end
