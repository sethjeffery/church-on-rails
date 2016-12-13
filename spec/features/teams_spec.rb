require "rails_helper"

RSpec.describe "Teams" do
  it_behaves_like "an authenticated feature", "/teams"
  it_behaves_like "an authorized feature", "/teams"

  context 'with access' do
    let(:user)  { create(:user, :person) }
    before { login_as user }

    context 'with read permissions' do
      before do
        user.person.join create(:team, people_reader: true)
      end

      it 'can browse teams' do
        team1 = create(:team, name: 'Team1', description: Faker::Lorem.paragraph)
        team2 = create(:team, name: 'Team2')
        create_list(:person, 5).each{|member| member.join team1 }

        visit '/teams'

        expect(page).to have_content team1.name
        expect(page).to have_content team2.name

        fill_in 'q', with: 'Team1'
        click_on 'Search'
        expect(page).to have_no_content team2.name

        click_on team1.name

        expect(page).to have_content 'Details'
        expect(page).to have_content team1.description

        # members
        team1.people.each do |member|
          expect(page).to have_content member.name
        end

        # no write access
        expect(page).to have_no_selector 'a.nav-link', text: /Edit/
        expect(page).to have_no_selector 'a.nav-link', text: /Add person/
        expect(page).to have_no_selector 'a.nav-link', text: /Add team event/

        person = team1.people.first
        click_on person.name
        expect(page).to have_content "Full name #{person.full_name}"
      end
    end

    context 'with write permissions' do
      before do
        user.person.join create(:team, people_reader: true, people_editor: true)
      end

      it 'can edit teams' do
        team1 = create(:team, name: 'Team1', description: Faker::Lorem.paragraph)
        create_list(:person, 5).each{|member| member.join team1 }

        visit "/teams/#{team1.id}"
        expect(page).to have_content 'Details'

        # no event access
        expect(page).to have_no_selector 'a.nav-link', text: /Add team event/

        click_on 'Edit'
        fill_in 'team_name', with: 'Administrators'
        fill_in 'team_description', with: 'A good team'
        expect(page).to have_no_content 'Permissions'

        click_on 'Save changes'

        expect(page).to have_content 'Administrators'
        expect(page).to have_content 'A good team'
      end
    end

    context 'with manage permissions' do
      before do
        user.person.join create(:team, people_reader: true, people_editor: true, people_admin: true)
      end

      it 'can manage team permissions' do
        team1 = create(:team, name: 'Team1', description: Faker::Lorem.paragraph)

        visit "/teams/#{team1.id}"
        expect(page).to have_content 'Details'

        click_on 'Edit'
        expect(page).to have_content 'Permissions'
        check(nil, name: "team[people_reader]")
        check(nil, name: "team[people_editor]")
        check(nil, name: "team[people_admin]")
        click_on 'Save changes'

        expect(page).to have_content 'People, Teams, Families View Edit Manage'
      end

      it 'can remove people from teams' do
        team = create(:team)
        member = create(:person)
        member.join team

        visit "/teams/#{team.id}"
        find(:css, '.list-group-item form.button_to button').click

        expect(page).to have_no_content member.name
        expect(team.reload.people).not_to include member
      end

      it 'can destroy teams' do
        team = create(:team)

        visit "/teams/#{team.id}"
        click_on 'Remove'
        click_on 'Yes, do it.'

        expect(page).to have_content "#{team} has been removed"
        visit '/teams'
        expect(page).to have_no_content team.name
      end
    end

    context 'with event permissions' do
      before do
        user.person.join create(:team, people_reader: true, event_reader: true, event_editor: true)
      end

      it 'can create and view events' do
        team1 = create(:team, name: 'Team1', description: Faker::Lorem.paragraph)

        visit "/teams/#{team1.id}"

        click_on 'Add team event'
        fill_in 'event_name', with: 'Party'
        fill_in 'event_description', with: 'like it is 1999'

        click_on 'Create event'

        expect(page).to have_content "Date can't be blank"
        expect(page).to have_content "Time can't be blank"

        fill_in 'Date', with: '12 Dec 1999'
        fill_in 'Time', with: '23:59'

        click_on 'Create event'
        expect(page).to have_no_content "Date can't be blank"
        expect(page).to have_content 'Party'
      end
    end
  end

end
