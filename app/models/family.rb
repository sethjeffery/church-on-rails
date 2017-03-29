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

  before_validation :update_search_name

  def family_name
    name + ' Family'
  end

  def to_s
    family_name
  end

  def merge_into(target)
    MergeFamilyJob.perform_now(self, target)
  end

  # Loop through all families in the database and merge
  # any with the same name.
  def self.auto_merge!
    families = order(:search_name).all
    families.each_with_index do |family, index|
      unless index == families.length - 1
        next_family = families[index+1]
        if next_family.search_name == family.search_name
          family.merge_into next_family
        end
      end
    end
  end

  def update_search_name
    self.search_name = name.downcase
  end
end
