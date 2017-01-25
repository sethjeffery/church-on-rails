class Person < ApplicationRecord
  include Concerns::Naming
  include Concerns::Commentable
  include Concerns::Capitalize

  attr_accessor :family_name, :family_address1, :family_address2, :family_postcode, :family_country

  belongs_to :user,                     dependent: :destroy, autosave: true
  has_many :family_memberships,         dependent: :destroy
  has_many :team_memberships,           dependent: :destroy
  has_many :events,                     dependent: :destroy, inverse_of: :author, foreign_key: :author_id
  has_many :person_processes,           dependent: :destroy
  has_many :person_process_assignees,   dependent: :destroy, inverse_of: :assignee, foreign_key: :assignee_id
  has_many :child_group_memberships,    dependent: :destroy
  has_many :child_group_checkins,       dependent: :destroy, inverse_of: :checked_in_by,  class_name: 'ChildGroupCheckin', foreign_key: :checked_in_by_id
  has_many :child_group_checkouts,      dependent: :destroy, inverse_of: :checked_out_by, class_name: 'ChildGroupCheckin', foreign_key: :checked_out_by_id
  has_many :property_joins,             dependent: :destroy, as: :propertyable
  has_many :actions,                    dependent: :nullify, inverse_of: :actor, foreign_key: :actor_id
  has_many :actionable_actions,         dependent: :nullify, as: :actionable, class_name: 'Action'
  has_many :families,                   through: :family_memberships, inverse_of: :people
  has_many :teams,                      through: :team_memberships, inverse_of: :people
  has_many :assigned_person_processes,  through: :person_process_assignees, class_name: 'PersonProcess', source: :person_process
  has_many :child_groups,               through: :child_group_memberships
  has_many :properties,                 through: :property_joins

  has_attached_file :avatar, styles: { xl: "192x192#", md: "72x72#", thumb: "48x48#" }

  validates_presence_of :first_name, :last_name
  validates_inclusion_of :gender, in: %w( m f ), allow_nil: true
  validates_format_of :facebook, with: /\A[\w\d\.]+\z/, allow_nil: true
  validates_format_of :twitter, with: /\A@[\w\d\._]+\z/, allow_nil: true
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  after_save        :track_joined, if: :joined_at_changed?
  after_create      :track_added
  before_validation :copy_changes_to_user
  before_validation :sanitize_facebook
  before_validation :sanitize_twitter
  before_validation :update_search_name

  auto_capitalize :first_name, :middle_name, :last_name

  def start_family(args)
    family_args = %i(name address1 address2 postcode country).map{|arg| [arg, args[:"family_#{arg}"]]}.to_h
    join(Family.create(family_args), head: true) if family_args[:name].present?
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
    self
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
    months = months_old(t)

    # months / 12 will give the number of years
    # months % 12 will give the number of months
    readable_age(months / 12, months % 12)
  end

  def months_old(t = Date.current)
    return unless dob
    months = (t.year * 12 + t.month) - (dob.year * 12 + dob.month)
    months -= 1 if t.day < dob.day
    months
  end

  def years_old(t = Date.current)
    return unless dob
    months_old(t) / 12
  end

  def merge_into(target)
    MergePersonJob.perform_now(self, target)
  end

  def update_properties(properties)
    properties.each do |id, value|
      property = Property.find(id)
      if value.blank? || (value == '0' && property.flag?)
        self.property_joins.where(property_id: id.to_i).delete_all
      else
        join = self.property_joins.find_or_initialize_by(property_id: id.to_i)
        join.propertyable = self
        join.value = value
        join.save
      end
    end
  end

  def has_property?(id)
    property_joins.where(property_id: id.to_i).exists?
  end

  def property(id)
    property_joins.where(property_id: id.to_i).first&.value
  end

  def start(church_process)
    person_processes.create({ church_process: church_process })
  end

  def icon
    icon = gender == 'f' ? :female : :male
    icon = :child if dob && years_old < 16
    icon
  end

  def track(type, args={})
    actions.create({ action_type: type }.merge(args))
  end

  def track_unique(type, args={})
    actions.of_type(type).first&.update_attributes(args) || track(type, args)
  end

  def name=(full_name)
    names = full_name.split(' ')
    self.first_name = names[0]
    self.last_name = names.last if names.length > 1
    self.middle_name = names.slice(1..-2).join(' ') if names.length > 2
  end

  protected

  def copy_changes_to_user
    user.email = email if email_changed? && email.present? && user.present?
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

  def track_joined
    if joined_at
      track_unique :joined, created_at: joined_at, data: { first_name: first_name, last_name: last_name, icon: icon }
    else
      actions.of_type(type).delete_all
    end
  end

  def track_added
    track_unique :added, created_at: created_at, data: { first_name: first_name, last_name: last_name, icon: icon }
  end

  def update_search_name
    self.search_name = name.downcase
  end
end
