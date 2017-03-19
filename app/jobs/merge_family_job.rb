class MergeFamilyJob < ApplicationJob
  queue_as :default

  def perform(actor, target)
    unless target.full_address.present?
      target.address1 = actor.address1
      target.address2 = actor.address2
      target.postcode = actor.postcode
      target.country = actor.country
    end

    existing_people = target.people

    actor.family_memberships.where.not(person_id: existing_people.map(&:id)).each do |membership|
      # Move member into new family
      membership.update_attributes(family_id: target.id)

      # Check if member already exists in family
      person = membership.person
      existing_person = existing_people.find{|existing_person| existing_person.first_name == person.first_name}
      person.merge_into existing_person if existing_person.present?
    end

    target.save!
    actor.destroy
  end
end
