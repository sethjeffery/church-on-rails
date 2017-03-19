require 'rails_helper'

RSpec.describe MergeFamilyJob, type: :job do
  let(:actor)  { create(:family) }
  let(:target) { create(:family) }
  subject(:perform_now) { described_class.perform_now(actor.reload, target.reload) }

  it 'destroys the old family' do
    perform_now
    expect{ Family.find(actor.id) }.to raise_error ActiveRecord::RecordNotFound
  end

  context 'with memberships' do
    let(:person_1) { create(:person, first_name: 'A') }
    let(:person_2) { create(:person, first_name: 'B') }
    let(:person_3) { create(:person, first_name: 'C') }

    before do
      person_1.join actor
      person_2.join target
      person_3.join actor
      person_3.join target
    end

    it 'adds all people to the new family' do
      perform_now
      expect(person_1.reload.families).to contain_exactly target
      expect(person_2.reload.families).to contain_exactly target
      expect(person_3.reload.families).to contain_exactly target
    end
  end

  context 'with same person in both families' do
    let(:person_1) { create(:person, first_name: 'John') }
    let(:person_2) { create(:person, first_name: 'John') }
    let(:person_3) { create(:person, first_name: 'Eric') }

    before do
      person_1.join actor
      person_2.join target
      person_3.join actor
    end

    it 'merges people' do
      perform_now
      expect(target.reload.people).to contain_exactly(person_2, person_3)
      expect{Person.find(person_1.id)}.to raise_error ActiveRecord::RecordNotFound
    end
  end

  context 'with address changes' do
    let(:actor) { create(:family, address1: '1 The Grove', address2: 'London', postcode: 'AB1 2CD', country: 'UK') }

    it 'updates the address of the new family' do
      perform_now
      expect(target.address1).to eq '1 The Grove'
      expect(target.address2).to eq 'London'
      expect(target.postcode).to eq 'AB1 2CD'
      expect(target.country).to eq 'UK'
    end
  end

  context 'with existing address on target' do
    let(:actor)  { create(:family, address1: '1 The Grove', address2: 'London', postcode: 'AB1 2CD', country: 'UK') }
    let(:target) { create(:family, address1: '2 Nice Drive') }

    it 'does not update the address of the new family' do
      perform_now
      expect(target.address1).to eq '2 Nice Drive'
    end

    it 'does not update blank fields' do
      perform_now
      expect(target.address2).to be_blank
      expect(target.postcode).to be_blank
      expect(target.country).to be_blank
    end
  end
end
