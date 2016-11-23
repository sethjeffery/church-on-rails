require "rails_helper"

RSpec.describe "Home" do
  it_behaves_like "an authenticated request", "/"

  context 'signed in' do
    let(:user) { create(:user) }
    before { sign_in user }

    it "redirects to account" do
      get "/"
      expect(response).to redirect_to('/account')
    end
  end
end
