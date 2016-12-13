require "rails_helper"

RSpec.describe "Account" do
  it_behaves_like "an authenticated feature", "/account"

  context 'signed in' do
    let(:user) { create(:user) }
    before { login_as user }

    it "Confirmation and add new person" do
      # Visit account page
      visit "/account"
      expect(page).to have_text 'Confirmation needed'

      # Confirm user
      visit "/users/confirmation?confirmation_token=#{user.confirmation_token}"
      expect(page).to have_text 'Welcome!'
      expect(page).to have_text 'add your account'

      # Fill in not enough details
      fill_in 'First name', with: 'Seth'
      click_button 'Save changes'
      expect(page).to have_text "Last name can't be blank"

      # Fill in rest of details
      fill_in 'Last name', with: 'Jeffery'
      click_button 'Save changes'

      expect(page).to have_no_text 'add your account'
      expect(current_path).to eq '/account/welcome'
    end

    it "Autoconnect with existing person" do
      create(:church)
      create(:person, first_name: 'Bob', last_name: 'Jones', email: user.email)

      # Confirm user
      visit "/users/confirmation?confirmation_token=#{user.confirmation_token}"

      # Auto-connection is established
      expect(page).to have_no_text 'add your account'
      expect(page).to have_text 'Oasis Church'
      expect(current_path).to eq '/'
    end

    it "Change password" do
      create(:church)
      create(:person, first_name: 'Bob', last_name: 'Jones', email: user.email, user: user)
      user.confirm

      visit "/account"
      expect(page).to have_content 'Bob Jones'
      click_on "Change password"

      within '.side-and-details--details' do
        fill_in "New password", with: 'newpass123'
        click_on "Change password"
      end

      visit '/users/logout'

      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'newpass123'
      click_on 'Log in'
      expect(page).to have_content 'Signed in successfully'
    end
  end
end
