require "rails_helper"

RSpec.describe "People" do
  it_behaves_like "an authenticated feature", "/people"
  it_behaves_like "an authorized feature", "/people"

  context 'with access' do
    let(:user)  { create(:user, :person) }
    before { login_as user }

    context 'with read permissions' do
      before do
        user.person.join create(:team, people_reader: true)
      end

      it "can browse people" do
        create_list(:person, 25)
        people = Person.all.order(:first_name, :last_name)

        visit "/people"

        within '.container .list-group' do
          people[0...20].each do |other|
            expect(page).to have_text other.name
          end
          people[21...25].each do |other|
            expect(page).to have_no_text other.name
          end
        end

        # next page
        click_on '2'

        within '.container .list-group' do
          people[0...20].each do |other|
            expect(page).to have_no_text other.name
          end
          people[21...25].each do |other|
            expect(page).to have_text other.name
          end
        end

        # search
        person = people[0] == user.person ? people[1] : people[0]
        person.update_attributes first_name: 'xxxxx', last_name: 'yyyyy'
        fill_in 'q', with: 'xxxxx'
        click_on 'Search'
        expect(page).to have_text person.name

        within '.container .list-group' do
          people.select{|other_person| other_person != person}.each do |other|
            expect(page).to have_no_text other.name
          end
        end

        # click on person
        team = create(:team)
        person.join team
        find("a", :text => /#{person.name}/).click

        # view person details
        expect(page).to have_content "Full name #{person.full_name}"
        expect(current_path).to eq "/people/#{person.id}"
        expect(page).to have_content "Teams"
        expect(page).to have_content team.name

        # no editing access
        expect(page).to have_no_selector 'a.nav-link', :text => /Edit/
        expect(page).to have_no_selector 'a.nav-link', :text => /Join teams/
        expect(page).to have_no_selector 'a.nav-link', :text => /Join a family/

        # no processes access
        expect(page).to have_no_content "Processes"
        expect(page).to have_no_selector 'a.nav-link', :text => /Start/
      end

      it 'can edit own account' do
        visit "/people/#{user.person.id}"
        expect(page).to have_selector 'a.nav-link', :text => /Edit/
      end

      it 'can view family members' do
        family  = create(:family)
        person  = create(:person)
        sibling = create(:person)
        person.join family
        sibling.join family

        visit "/people/#{person.id}"
        expect(page).to have_content "Full name #{person.full_name}"
        expect(page).to have_content person.name
        expect(page).to have_content sibling.name

        click_on sibling.name
        expect(page).to have_content "Full name #{sibling.full_name}"
      end

      it 'can view teams' do
        team   = create(:team)
        person = create(:person)
        mate   = create(:person)
        person.join team
        mate.join team

        visit "/people/#{person.id}"
        expect(page).to have_content "Full name #{person.full_name}"
        expect(page).to have_content team.name

        click_on team.name
        expect(page).to have_content "Members"
        expect(page).to have_content person.name
        expect(page).to have_content mate.name
      end
    end

    context 'with process permissions' do
      before do
        user.person.join create(:team, people_reader: true, process_reader: true)
      end

      it 'can view processes' do
        person = create(:person)
        church_process = create(:church_process)
        person_process = create(:person_process, church_process: church_process, person: person)

        visit "/people/#{person.id}"
        expect(page).to have_content "Full name #{person.full_name}"
        expect(page).to have_content "Processes"
        expect(page).to have_content church_process.name

        # cannot start processes
        expect(page).to have_no_content "Start"
      end
    end

    context 'with write permissons' do
      before do
        user.person.join create(:team,
                                people_reader: true, people_editor: true,
                                process_reader: true, process_editor: true)
      end

      it 'can edit details' do
        person = create(:person)
        team = create(:team)
        person.join team

        visit "/people/#{person.id}"
        expect(page).to have_content "Full name #{person.full_name}"
        expect(page).to have_content team.name
        expect(page).to have_selector 'a.nav-link', :text => /Join a family/
        expect(page).to have_selector 'a.nav-link', :text => /Join teams/
        expect(page).to have_selector 'a.nav-link', :text => /Start/
        expect(page).to have_selector 'a.nav-link', :text => /Edit/

        # cannot do admin stuff
        expect(page).to have_no_selector 'Remove person'
        expect(page).to have_no_selector 'Change password'

        click_on 'Edit'
        fill_in 'First name', with: 'aaaaaa'
        fill_in 'Middle name', with: 'bbbbbb'
        fill_in 'Last name', with: 'cccccc'
        select 'Mr', from: 'Prefix'
        fill_in 'Email', with: 'new@example.com'
        fill_in 'Phone', with: '01234567890'
        click_on 'Save changes'

        expect(page).to have_content "Full name Mr Aaaaaa Bbbbbb Cccccc"
        expect(page).to have_content "Email new@example.com"
        expect(page).to have_content "Phone 01234567890"
      end
    end

    context 'with manage permissions' do
      before do
        user.person.join create(:team, people_reader: true, people_editor: true, people_admin: true)
      end

      it 'can destroy person' do
        person = create(:person)

        visit "/people/#{person.id}"
        click_on 'Remove person'
        click_on 'Yes, do it.'

        expect(page).to have_content "#{person.name} has been removed"
        visit '/people'
        expect(page).to have_no_content person.name
      end

      it 'can change password' do
        person = create(:person)

        visit "/people/#{person.id}"
        expect(page).to have_no_content 'Change password'

        person.update_attributes user: create(:user)
        visit "/people/#{person.id}"
        expect(page).to have_content 'Change password'

        click_on 'Change password'

        within '.side-and-details--details' do
          fill_in 'New password', with: 'pass123'
          click_on 'Change password'
        end

        expect(page).to have_content "Password updated successfully"
      end

      it 'can attach new users to accounts' do
        person = create(:person)
        visit "/people/#{person.id}"

        within '.side-and-details--details' do
          click_on "Add login account"
        end

        fill_in 'Email', with: 'new_account@example.com'
        fill_in 'Password', with: 'pass123'
        click_on 'Add account'

        visit '/users/logout'
        fill_in 'Email', with: 'new_account@example.com'
        fill_in 'Password', with: 'pass123'
        click_on 'Log in'
        expect(page).to have_content 'Signed in successfully'
      end
    end
  end
end
