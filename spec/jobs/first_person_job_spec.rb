require 'rails_helper'

RSpec.describe FirstPersonJob, type: :job do
  let(:person) { build(:person) }
  subject(:perform_now) { described_class.perform_now person }

  context 'with present teams and users' do
    it 'does nothing' do
      create(:team, admin: true)
      expect {
        perform_now
      }.not_to change { Team.count }
    end
  end

  context 'with blank database' do
    it 'creates admin team' do
      expect {
        perform_now
      }.to change { Team.where(admin: true).count }.by(1)
    end

    it 'adds person to team' do
      perform_now
      expect(person.teams).to eq Team.where(admin: true).all
    end
  end
end
