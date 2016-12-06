class Person < ApplicationRecord
  include Concerns::Naming
  include Concerns::Commentable
  attr_accessor :family_name

  belongs_to :user,                     dependent: :destroy, autosave: true
  has_many :family_memberships,         dependent: :destroy
  has_many :team_memberships,           dependent: :destroy
  has_many :events,                     dependent: :destroy, inverse_of: :author, foreign_key: :author_id
  has_many :person_processes,           dependent: :destroy
  has_many :person_process_assignees,   dependent: :destroy, inverse_of: :assignee, foreign_key: :assignee_id
  has_many :child_group_memberships,    dependent: :destroy
  has_many :child_group_checkins,       dependent: :destroy, inverse_of: :checked_in_by,  class_name: 'ChildGroupCheckin', foreign_key: :checked_in_by_id
  has_many :child_group_checkouts,      dependent: :destroy, inverse_of: :checked_out_by, class_name: 'ChildGroupCheckin', foreign_key: :checked_out_by_id
  has_many :families,                   through: :family_memberships, inverse_of: :people
  has_many :teams,                      through: :team_memberships, inverse_of: :people
  has_many :assigned_person_processes,  through: :person_process_assignees, class_name: 'PersonProcess', inverse_of: :assignees
  has_many :child_groups,               through: :child_group_memberships

  has_attached_file :avatar, styles: { xl: "192x192#", md: "72x72#", thumb: "48x48#" }

  validates_presence_of :first_name, :last_name
  validates_inclusion_of :gender, in: %w( m f ), allow_nil: true
  validates_format_of :facebook, with: /\A[\w\d\.]+\z/, allow_nil: true
  validates_format_of :twitter, with: /\A@[\w\d\._]+\z/, allow_nil: true
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  before_validation :copy_changes_to_user
  before_validation :sanitize_names
  before_validation :sanitize_facebook
  before_validation :sanitize_twitter

  def start_family(family_name)
    join Family.create(name: family_name), head: true
  end

  def join(group, args={})
    save if new_record?

    if group.is_a? Family
      join_family group, args

    elsif group.is_a? Team
      join_team group, args

    elsif group.is_a? ChildGroup
      join_child_group group, args

    else
      raise "Unexpected type #{group.class.name}"
    end
  end

  def avatar_url(size)
    if size >= 192
      avatar.url(:xl)
    elsif size >= 72
      avatar.url(:md)
    else
      avatar.url(:thumb)
    end
  end

  def age(t = Date.current)
    return unless dob
    months = (t.year * 12 + t.month) - (dob.year * 12 + dob.month)
    months -= 1 if t.day < dob.day

    # months / 12 will give the number of years
    # months % 12 will give the number of months
    readable_age(months / 12, months % 12)
  end

  def merge_into(target)
    MergePersonJob.perform_now(self, target)
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

  def join_child_group(group, args={})
    child_group_memberships.create({ child_group: group }.merge(args))
  end

  def capitalize(name)
    name.slice(0,1).capitalize + name.slice(1..-1)
  end

  def sanitize_facebook
    if facebook.present?
      self.facebook.gsub!(/^https?:\/\/(?:www\.)?(?:facebook|fb)\.com\/([\w\d\.]+).*$/, "\\1")
    else
      self.facebook = nil
    end
  end

  def sanitize_twitter
    if twitter.present?
      self.twitter.gsub!(/^https?:\/\/(?:www\.)?(?:twitter)\.com\/@?([\w\d\._]+).*/, "@\\1")
      self.twitter = "@" + twitter unless self.twitter.start_with?('@')
    else
      self.twitter = nil
    end
  end

  def readable_age(years, months)
    if years > 1
      "#{years} #{'year'.pluralize(years)} old"
    elsif years > 0
      "#{24 + months} months old"
    else
      "#{months} #{'month'.pluralize(months)} old"
    end
  end
end
