require 'rails_helper'

RSpec.describe ChildGroupMembership, type: :model do
  describe '.checked_in' do
    it 'returns only checked in memberships' do
      in_membership = create(:child_group_membership, :checked_in)
      out_membership = create(:child_group_membership, :checked_out)
      expect(ChildGroupMembership.checked_in.to_a).to eq [in_membership]
    end
  end

  describe '.checked_out' do
    it 'returns only checked out memberships' do
      in_membership = create(:child_group_membership, :checked_in)
      out_membership = create(:child_group_membership, :checked_out)
      expect(ChildGroupMembership.checked_out.to_a).to eq [out_membership]
    end
  end

  describe '#check_in' do
    let(:membership) { create(:child_group_membership) }

    it 'updates checked_in status' do
      expect { membership.check_in }.to change { membership.checked_in? }.from(false).to(true)
    end

    it 'adds a check_in record' do
      expect { membership.check_in }.to change { membership.child_group_checkins.checked_in.count }.by(1)
    end

    it 'optionally checks in with a person' do
      adult = create(:person)
      membership.check_in adult
      expect(membership.child_group_checkins.first.checked_in_by).to eq adult
    end
  end

  describe '#check_out' do
    let(:membership) { create(:child_group_membership, :checked_in) }
    let!(:check_in)  { create(:child_group_checkin, :checked_in, child_group_membership: membership) }

    it 'updates checked_in status' do
      expect { membership.check_out }.to change { membership.checked_in? }.from(true).to(false)
    end

    it 'updates the check_in record' do
      expect { membership.check_out }.to change { membership.child_group_checkins.checked_out.count }.by(1)
      expect(check_in.reload.checked_out?).to be true
    end

    it 'optionally checks in with a person' do
      adult = create(:person)
      membership.check_out adult
      expect(check_in.reload.checked_out_by).to eq adult
    end
  end
end
