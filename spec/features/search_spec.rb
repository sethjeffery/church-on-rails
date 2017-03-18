require "rails_helper"

RSpec.describe "Search" do
  context 'with access to people' do
    let(:user)  { create(:user, :person) }
    before { login_as user }

    context 'with read permissions' do
      before do
        user.person.join create(:team, people_reader: true)
      end

      it "can search people", :js do
        person = create(:person)

        visit "/"
        find('.nav-item-search .nav-link').click

        find('#search-modal input').send_keys(person.first_name)
        expect(page).to have_text person.name

        find("#search-modal a", :text => /#{person.name}/).click
        expect(page).to have_text person.name
        expect(page.current_url).to end_with "people/#{person.id}"
      end
    end
  end
end
