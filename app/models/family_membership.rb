class FamilyMembership < ApplicationRecord
  belongs_to :family
  belongs_to :person

  validates_presence_of :family_id, :person_id
  validates_uniqueness_of :person_id, scope: :family_id

  after_save :dependent_destroy_family, if: -> { family_id_changed? && family_id_was.present? }
  after_destroy :dependent_destroy_family

  def dependent_destroy_family
    old_family = Family.find(family_id_was || family_id)
    old_family.delete unless old_family.family_memberships.where.not(id: id).exists?
  end
end
