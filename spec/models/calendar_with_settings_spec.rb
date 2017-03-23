require 'rails_helper'
require 'google_calendar_service'

RSpec.describe CalendarWithSettings, type: :model do
  let(:calendar) { double(id: 'calendar', summary: 'A calendar') }
  subject { CalendarWithSettings.new(calendar) }

  it 'is not a real ActiveRecord model' do
    expect(subject).not_to respond_to :save
  end

  it 'delegates to calendar' do
    expect(subject.id).to eq 'calendar'
    expect(subject.summary).to eq 'A calendar'
  end

  describe '#visibility' do
    it 'can be preset' do
      subject.visibility = :blah
      expect(subject.visibility).to eq :blah
    end

    context 'with no calendar_teams' do
      it 'is :none' do
        expect(subject.visibility).to eq :none
      end
    end

    context 'with calendar_team without team' do
      it 'is :all' do
        create(:calendar_team, calendar_id: 'calendar')
        expect(subject.visibility).to eq :all
      end
    end

    context 'with calendar_team with specific team' do
      it 'is :teams' do
        create(:calendar_team, calendar_id: 'calendar', team: create(:team))
        expect(subject.visibility).to eq :teams
      end
    end
  end

  describe 'update_attributes' do
    let(:old_team) { create(:team) }

    before do
      create(:calendar_team, calendar_id: 'calendar')
      create(:calendar_team, calendar_id: 'calendar', team: old_team)
      create(:calendar_team, calendar_id: 'unrelated')
    end

    describe 'visibility=all' do
      let(:update) { subject.update_attributes(visibility: 'all', team_ids: []) }

      it 'sets only one calendar_team for public' do
        update
        expect(CalendarTeam.where(calendar_id: 'calendar').pluck(:team_id)).to eq([nil])
      end

      it 'does not touch unrelated calendar_teams' do
        expect { update }.not_to change {
          CalendarTeam.where(calendar_id: 'unrelated').count
        }
      end
    end

    describe 'visibility=teams' do
      let(:new_team) { create(:team) }
      let(:update) { subject.update_attributes(visibility: 'teams', team_ids: [new_team.id]) }

      it 'adds calendar_teams for the given team_ids' do
        expect { update }.to change {
          CalendarTeam.where(calendar_id: 'calendar', team_id: new_team.id).count
        }.by(1)
      end

      it 'destroys calendar_teams not for the given team_ids' do
        expect { update }.to change {
          CalendarTeam.where(calendar_id: 'calendar', team_id: old_team.id).count
        }.by(-1)
      end

      it 'destroys public calendar_teams' do
        expect { update }.to change {
          CalendarTeam.where(calendar_id: 'calendar', team_id: nil).count
        }.by(-1)
      end

      it 'does not touch unrelated calendar_teams' do
        expect { update }.not_to change {
          CalendarTeam.where(calendar_id: 'unrelated').count
        }
      end
    end

    describe 'visibility=none' do
      let(:update) { subject.update_attributes(visibility: 'none', team_ids: []) }

      it 'destroys all calendar_teams for this calendar' do
        expect{ update }.to change{
          CalendarTeam.count
        }.by(-2)
      end

      it 'does not touch unrelated calendar_teams' do
        expect { update }.not_to change {
          CalendarTeam.where(calendar_id: 'unrelated').count
        }
      end
    end
  end
end
