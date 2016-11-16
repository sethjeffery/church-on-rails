class FamilyMembership < ApplicationRecord
  belongs_to :family
  belongs_to :person

  validates_presence_of :family_id, :person_id
  validates_uniqueness_of :person_id, scope: :family_id
end
