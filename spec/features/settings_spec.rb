require "rails_helper"

RSpec.describe "Settings" do
  it_behaves_like "an authenticated feature", "/account/settings"

  context 'signed in' do
    let(:user) { create(:user, :person) }
    before { login_as user }

    it "cannot be accessed" do
      expect {
        visit "/account/settings"
      }.to raise_error CanCan::AccessDenied
    end

    context 'as admin' do
      before do
        user.person.join create(:team, admin: true)
      end

      it 'can change site settings' do
        visit '/account/settings'

        fill_in 'Gmaps api key', with: 'new_key'
        click_on 'Save changes'

        expect(page).to have_content 'Settings updated'

        expect(find_field('Gmaps api key').value).to eq 'new_key'
        expect(Setting.fetch(:gmaps_api_key)).to eq 'new_key'
      end
    end
  end
end
