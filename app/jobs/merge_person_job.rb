class MergePersonJob < ApplicationJob
  queue_as :default

  def perform(actor, target)
    return if actor == target
    ActiveRecord::Base.transaction do
      target.user_id, actor.user_id = actor.user_id, nil if actor.user_id && !target.user_id

      target.prefix       ||= actor.prefix
      target.first_name   ||= actor.first_name
      target.middle_name  ||= actor.middle_name
      target.last_name    ||= actor.last_name
      target.suffix       ||= actor.suffix
      target.dob          ||= actor.dob
      target.email        ||= actor.email
      target.phone        ||= actor.phone
      target.gender       ||= actor.gender
      target.facebook     ||= actor.facebook
      target.twitter      ||= actor.twitter
      target.avatar       ||= actor.avatar
      target.joined_at    ||= actor.joined_at
      target.user_id      ||= actor.user_id

      actor.family_memberships      .where.not(family_id:                 target.family_memberships      .pluck(:family_id))                 .update_all(person_id: target.id)
      actor.team_memberships        .where.not(team_id:                   target.team_memberships        .pluck(:team_id))                   .update_all(person_id: target.id)
      actor.person_processes        .where.not(church_process_id:         target.person_processes        .pluck(:church_process_id))         .update_all(person_id: target.id)
      actor.person_process_assignees.where.not(person_process_id:         target.person_process_assignees.pluck(:person_process_id))         .update_all(assignee_id: target.id)
      actor.child_group_memberships .where.not(child_group_id:            target.child_group_memberships .pluck(:child_group_id))            .update_all(person_id: target.id)
      actor.child_group_checkins    .where.not(child_group_membership_id: target.child_group_checkins    .pluck(:child_group_membership_id)) .update_all(checked_in_by_id: target.id)
      actor.child_group_checkouts   .where.not(child_group_membership_id: target.child_group_checkouts   .pluck(:child_group_membership_id)) .update_all(checked_out_by_id: target.id)

      actor.events.update_all(author_id: target.id)

      target.save!
      actor.destroy
    end
  end
end
