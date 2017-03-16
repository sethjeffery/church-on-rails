class MergeFamilyJob < ApplicationJob
  queue_as :default

  def perform(actor, target)
    unless target.full_address.present?
      target.address1 = actor.address1
      target.address2 = actor.address2
      target.postcode = actor.postcode
      target.country = actor.country
    end

    existing_person_ids = target.family_memberships.pluck(:person_id)
    actor.family_memberships.where.not(person_id: existing_person_ids).update_all(family_id: target.id)

    target.save!
    actor.destroy
  end
end
