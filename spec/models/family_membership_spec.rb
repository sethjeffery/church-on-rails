require 'rails_helper'

RSpec.describe FamilyMembership do
  context 'in family' do
    let(:family) { create(:family) }
    subject! { create(:family_membership, family: family) }

    context 'with other memberships' do
      before do
        create(:family_membership, family: family)
      end

      context 'on joining other family' do
        it 'does not destroy original family' do
          new_family = create(:family)
          expect {
            subject.update_attributes family: new_family
          }.not_to change { Family.count }
        end
      end

      context 'on destroying' do
        it 'does not destroy family' do
          expect {
            subject.destroy
          }.not_to change { Family.count }
        end
      end
    end

    context 'without other memberships' do
      context 'on joining other family' do
        it 'destroys original family' do
          new_family = create(:family)
          expect {
            subject.update_attributes family: new_family
          }.to change { Family.count }.by(-1)
        end
      end

      context 'on destroying' do
        it 'destroys family' do
          expect {
            subject.destroy
          }.to change { Family.count }.by(-1)
        end
      end
    end
  end
end
