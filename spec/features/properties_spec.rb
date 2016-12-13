require "rails_helper"

RSpec.describe "Properties" do
  it_behaves_like "an authenticated feature", "/properties"
  it_behaves_like "an authorized feature", "/properties"

  context 'with access' do
    let(:user)  { create(:user, :person) }
    before { login_as user }

    context 'with read permissions' do
      before do
        user.person.join create(:team, people_reader: true)
      end

      it 'can browse properties' do
        prop1 = create(:property, name: 'Alpha')
        prop2 = create(:property, name: 'Beta')
        members = create_list(:person, 3)

        members.each do |member|
          member.property_joins.create property: prop1
        end

        visit '/properties'
        expect(page).to have_content prop1.name
        expect(page).to have_content prop2.name

        fill_in 'q', with: 'alp'
        click_on 'Search'
        expect(page).to have_no_content prop2.name
        expect(page).to have_content prop1.name

        click_on prop1.name
        expect(page).to have_content prop1.name

        # members
        members.each do |member|
          expect(page).to have_content member.name
        end

        # no edit or destroy
        expect(page).to have_no_selector '.btn', text: /Remove/
        expect(page).to have_no_selector '.btn', text: /Edit/
      end
    end

    context 'with write permissions' do
      before do
        user.person.join create(:team, people_reader: true, people_editor: true)
      end

      it 'can edit properties' do
        prop = create(:property, format: 'text')

        visit "/properties/#{prop.id}"
        expect(page).to have_no_selector '.btn', text: /Remove/

        click_on "Edit"

        fill_in 'Name', with: 'Alpha'
        fill_in 'Description', with: 'An alpha property'
        choose 'Flag'
        click_on "Save changes"

        expect(page).to have_content 'An alpha property'
        expect(prop.reload.format).to eq 'flag'

        new_person = create(:person)
        visit "/people/#{new_person.id}/edit"

        within '.side-and-details--details' do
          expect(page).to have_content 'Custom properties'
          expect(page).to have_content 'Alpha'
          check 'Alpha'
          click_on 'Save changes'
        end

        expect(page).to have_content 'Custom properties'
        expect(page).to have_content 'Alpha'
        expect(new_person).to have_property prop.id
      end
    end

    context 'with manage permissions' do
      before do
        user.person.join create(:team, people_reader: true, people_editor: true, people_admin: true)
      end

      it 'can remove property' do
        prop = create(:property)

        visit "/properties/#{prop.id}"
        click_on 'Remove'
        click_on 'Yes, do it.'

        expect(page).to have_content "#{prop} has been removed"
        visit '/properties'
        expect(page).to have_no_content prop.name
      end
    end
  end
end
