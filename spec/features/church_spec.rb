require "rails_helper"

RSpec.describe "Church" do
  it_behaves_like "an authenticated feature", "/"

  context 'with access' do
    let!(:user)   { create(:user, :person) }
    let!(:church) { create(:church, address1: nil, address2: nil, postcode: nil, country: nil, phone: nil, email: nil) }
    before { login_as user }

    context 'with basic permissions' do
      it 'shows very basic church info' do
        visit '/'
        expect(page).to have_content "No address"
        expect(page).to have_content "The administrator has not set your church address yet"
        expect(page).to have_no_selector 'a.btn', :text => /Edit/

        expect(page).to have_no_content 'Age distribution'
        expect(page).to have_no_content 'Gender distribution'
        expect(page).to have_no_content 'Joined members'
      end
    end

    context 'with admin permissions' do
      it 'can edit church info' do
        user.person.join create(:team, admin: true)
        visit '/'
        expect(page).to have_content "No address"
        expect(page).to have_content "You have not set your church address yet"
        expect(page).to have_selector 'a.btn', :text => /Edit/
        click_on 'Edit'

        fill_in 'Address', with: '1 The Street'
        fill_in 'Town', with: 'District'
        fill_in 'Post code', with: 'AB1 2CD'
        fill_in 'Country', with: 'United Kingdom'
        fill_in 'Phone', with: '01234567890'
        fill_in 'Email', with: 'test@example.com'
        click_on 'Save changes'

        expect(page).to have_content '1 The Street District AB1 2CD United Kingdom'
        expect(page).to have_no_content 'No address'
        expect(page).to have_content '01234567890'
        expect(page).to have_content 'test@example.com'
      end

      it 'can view stats' do
        create_list(:person, 5)
        create_list(:event, 1)
        create_list(:team, 2)
        create_list(:person_process, 1, :active)

        user.person.join create(:team, admin: true)
        visit '/'

        expect(page).to have_content 'Age distribution'
        expect(page).to have_content 'Gender distribution'
        expect(page).to have_content 'Joined per month'
      end
    end
  end
end
