require "rails_helper"

RSpec.describe "Children" do
  it_behaves_like "an authenticated feature", "/children"
  it_behaves_like "an authorized feature", "/children"

  context 'with access' do
    let(:user)  { create(:user, :person) }
    before { login_as user }

    context 'with read permissions' do
      before do
        user.person.join create(:team, children_reader: true)
      end

      it 'can browse child groups' do
        group1 = create(:child_group, name: 'Group1', description: Faker::Lorem.paragraph, age_group: '0-3s')
        group2 = create(:child_group, name: 'Group2')

        create_list(:person, 5).each{|member| member.join group1 }

        visit '/children'

        expect(page).to have_content group1.name
        expect(page).to have_content group2.name

        click_on group1.name

        expect(page).to have_content 'Group1'
        expect(page).to have_content group1.description
        expect(page).to have_content group1.age_group

        # members
        group1.people.each do |member|
          expect(page).to have_content member.name
        end

        # no write access
        expect(page).to have_no_selector 'a.btn', text: /Edit/
        expect(page).to have_no_selector 'a.btn', text: /Add child/
      end
    end

    context 'with write permissions' do
      let!(:group) { create(:child_group, name: 'Group1', description: Faker::Lorem.paragraph, age_group: '0-3s') }
      let!(:child) { create(:person) }

      before do
        user.person.join create(:team, children_reader: true, children_editor: true)
        visit "/children/groups/#{group.id}"
      end

      it 'can edit info' do
        expect(page).to have_content 'Group1'

        # has write access
        expect(page).to have_selector 'a.btn', text: /Edit/
        expect(page).to have_selector 'a.btn', text: /Add child/

        # no delete access
        expect(page).to have_no_selector '.list-group-item form.button_to'

        click_on 'Edit'
        fill_in 'Description', with: 'New description'
        fill_in 'Name', with: 'Group2'
        click_on 'Save changes'

        expect(page).to have_content 'Group2'
        expect(page).to have_content 'New description'
      end

      it 'can add children' do
        click_on 'Add child'
        select child.name, from: 'child_group_membership[person_id]'
        click_on 'Add child'

        expect(page).to have_content child.name
      end
    end

    context 'with admin permissions' do
      let!(:group) { create(:child_group, name: 'Group1', description: Faker::Lorem.paragraph, age_group: '0-3s') }
      let!(:child) { create(:person) }
      let!(:membership) { create(:child_group_membership, child_group: group, person: child) }

      before do
        user.person.join create(:team, children_reader: true, children_editor: true, children_admin: true)
        visit "/children/groups/#{group.id}"
      end

      it 'can edit info' do
        expect(page).to have_content 'Group1'
        expect(page).to have_content child.name

        # has delete access
        expect(page).to have_selector '.list-group-item form.button_to'

        find(:css, '.list-group-item form.button_to button').click
        expect(page).to have_no_content child.name
        expect(group.reload.child_group_memberships.count).to eq 0
      end
    end
  end
end
