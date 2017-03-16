class Family < ApplicationRecord
  include Concerns::Geocoding
  include Concerns::Commentable
  include Concerns::Capitalize

  has_many :family_memberships, dependent: :destroy
  has_many :people,             through: :family_memberships, inverse_of: :families
  has_many :head_memberships,   ->{ where(head: true) }, class_name: 'FamilyMembership'
  has_many :heads,              class_name: 'Person', through: :head_memberships, source: :person

  validates_presence_of :name
  auto_capitalize :name

  def family_name
    name + ' Family'
  end

  def to_s
    family_name
  end

  def merge_into(target)
    MergeFamilyJob.perform_now(self, target)
  end
end
