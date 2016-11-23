RSpec.shared_examples "a named model" do |name_field = :name|
  it 'returns name from #to_s' do
    expect(subject.to_s).to eq subject.send(name_field).to_s
  end
end

RSpec.shared_examples "an authenticated feature" do |url|
  context 'not signed in' do
    before { logout }
    it "redirects to login" do
      visit url
      expect(current_path).to eq '/users/login'
    end
  end
end

RSpec.shared_examples "an authorized feature" do |url|
  context 'without access' do
    let(:user) { create(:user) }
    before { login_as user }

    it "denies access to the page" do
      expect { visit url }.to raise_error CanCan::AccessDenied
    end
  end
end
