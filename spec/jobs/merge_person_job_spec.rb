require 'rails_helper'

RSpec.describe MergePersonJob, type: :job do
  let(:actor)  { create(:person) }
  let(:target) { create(:person) }
  subject(:perform_now) { described_class.perform_now(actor.reload, target.reload) }

  context 'person details' do
    it 'updates nils' do
      target.update_attributes prefix: nil,   middle_name: nil,    suffix: nil,   facebook: nil,    twitter: nil,      dob: nil,            phone: nil
      actor.update_attributes  prefix: 'Mrs', middle_name: 'Beta', suffix: 'Jnr', facebook: 'beta', twitter: 'tweeta', dob: Date.yesterday, phone: '67890'

      expect{ perform_now }.to change{ target.reload.as_json }

      expect(target.prefix).to eq       'Mrs'
      expect(target.middle_name).to eq  'Beta'
      expect(target.suffix).to eq       'Jnr'
      expect(target.facebook).to eq     'beta'
      expect(target.twitter).to eq      '@tweeta'
      expect(target.dob).to eq          Date.yesterday
      expect(target.phone).to eq        '67890'
    end

    it 'keeps existing' do
      target.update_attributes prefix: 'Mr', middle_name: 'Alpha', suffix: 'Snr', facebook: 'alpha', twitter: 'twalpha', dob: Date.today, phone: '12345'
      actor.update_attributes  prefix: 'Mrs', middle_name: 'Beta', suffix: 'Jnr', facebook: 'beta',  twitter: 'tweeta',  dob: Date.yesterday, phone: '67890'
      expect{ perform_now }.not_to change{ target.reload.as_json }
    end
  end

  context 'relations' do
    it 'merges families' do
      actor_family  = create(:family)
      target_family = create(:family)
      actor.join  actor_family
      target.join target_family

      expect{ perform_now }.to change{ target.reload.family_memberships.count }.by(1)
      expect(target.families).to contain_exactly(actor_family, target_family)
    end

    it 'ignores existing family joins' do
      family = create(:family)
      actor.join  family
      target.join family
      expect{ perform_now }.not_to change{ target.reload.family_memberships.count }
    end

    it 'merges teams' do
      actor_team  = create(:team)
      target_team = create(:team)
      actor.join  actor_team
      target.join target_team

      expect{ perform_now }.to change{ target.reload.team_memberships.count }.by(1)
      expect(target.teams).to contain_exactly(actor_team, target_team)
    end

    it 'ignores existing team joins' do
      team = create(:team)
      actor.join  team
      target.join team
      expect{ perform_now }.not_to change{ target.reload.team_memberships.count }
    end

    it 'merges processes' do
      create(:person_process, person: actor)
      create(:person_process, person: target)
      expect{ perform_now }.to change{ target.reload.person_processes.count }.by(1)
    end

    it 'ignores existing processes' do
      process = create(:church_process)
      create(:person_process, person: actor, church_process: process)
      create(:person_process, person: target, church_process: process)
      expect{ perform_now }.not_to change{ target.reload.person_processes.count }
    end

    it 'merges child_group_memberships' do
      create(:child_group_membership, person: actor)
      create(:child_group_membership, person: target)
      expect{ perform_now }.to change{ target.reload.child_group_memberships.count }.by(1)
    end

    it 'ignores existing child_groups' do
      group = create(:child_group)
      create(:child_group_membership, person: actor, child_group: group)
      create(:child_group_membership, person: target, child_group: group)
      expect{ perform_now }.not_to change{ target.reload.child_group_memberships.count }
    end

    it 'merges child_group_checkin references' do
      create(:child_group_checkin, checked_in_by: actor)
      create(:child_group_checkin, checked_in_by: target)
      expect{ perform_now }.to change{ target.reload.child_group_checkins.count }.by(1)
    end

    it 'ignores existing checkin references' do
      membership = create(:child_group_membership)
      create(:child_group_checkin, checked_in_by: actor, child_group_membership: membership)
      create(:child_group_checkin, checked_in_by: target, child_group_membership: membership)
      expect{ perform_now }.not_to change{ target.reload.child_group_checkins.count }
    end

    it 'merges child_group_checkout references' do
      create(:child_group_checkin, checked_out_by: actor)
      create(:child_group_checkin, checked_out_by: target)
      expect{ perform_now }.to change{ target.reload.child_group_checkouts.count }.by(1)
    end

    it 'ignores existing checkout references' do
      membership = create(:child_group_membership)
      create(:child_group_checkin, checked_out_by: actor, child_group_membership: membership)
      create(:child_group_checkin, checked_out_by: target, child_group_membership: membership)
      expect{ perform_now }.not_to change{ target.reload.child_group_checkouts.count }
    end

    it 'merges event authors' do
      create(:event, author: actor)
      create(:event, author: target)
      expect{ perform_now }.to change{ target.reload.events.count }.by(1)
    end

    it 'merges process assignees' do
      create(:person_process_assignee, assignee: actor)
      create(:person_process_assignee, assignee: target)
      expect{ perform_now }.to change{ target.reload.assigned_person_processes.count }.by(1)
    end

    it 'ignores existing assignees' do
      process = create(:person_process)
      create(:person_process_assignee, assignee: actor, person_process: process)
      create(:person_process_assignee, assignee: target, person_process: process)
      expect{ perform_now }.not_to change{ target.reload.assigned_person_processes.count }
    end
  end
end
