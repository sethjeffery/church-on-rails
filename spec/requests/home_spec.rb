require "rails_helper"

RSpec.describe "Home" do
  context 'not signed in' do
    context 'no users' do
      it "redirects to signup" do
        get '/'
        expect(response).to redirect_to('/users/sign_up')
      end
    end

    context 'at least one user' do
      it "redirects to login" do
        create(:user)
        get '/'
        expect(response).to redirect_to('/users/login')
      end
    end
  end

  context 'signed in' do
    let(:user) { create(:user) }
    before { sign_in user }

    it "redirects to account" do
      get "/"
      expect(response).to redirect_to('/account')
    end
  end
end
