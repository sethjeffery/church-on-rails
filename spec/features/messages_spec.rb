require "rails_helper"

RSpec.describe "Messages" do
  it_behaves_like "an authenticated feature", "/messages"

  context 'with access' do
    let!(:user)   { create(:user, :person) }
    let!(:message) { create(:message, send_to: :people, person_ids: [user.person.id], subject: 'Hello world') }
    before { login_as user }

    context 'with basic permissions' do
      before do
        visit '/messages'
      end

      it 'is read-only inbox' do
        expect(page).to have_content "Inbox"
        expect(page).to have_content message.subject

        expect(page).to have_no_content "Sent items"
        expect(page).to have_no_content "New message"
      end

      it 'can read messages' do
        expect(page).to have_selector 'a.list-group-item .fa-envelope'
        expect(message.message_recipients.first).to_not be_read

        find('a.list-group-item', text: /Hello world/).click
        expect(page).to have_content message.subject
        expect(page).to have_content message.sender.to_s
        expect(page).to have_content message.message
        click_on 'Messages'

        expect(page).to have_selector 'a.list-group-item .fa-envelope-o'
        expect(message.message_recipients.first).to be_read
      end
    end

    context 'with write permissions' do
      before do
        team = create(:team, admin: true)
        user.person.join team
        visit '/messages'
      end

      it 'is full inbox' do
        expect(page).to have_content "Inbox"
        expect(page).to have_content message.subject

        expect(page).to have_content "Sent items"
        expect(page).to have_content "New message"
      end

      it 'can send messages', :js do
        click_on 'New message'
        recipient = create(:person)

        fill_in 'Subject', with: 'Message in a bottle'
        fill_in 'Message', with: 'Sending out an SOS'

        select_ajax 'message[person_ids][]', recipient.id, recipient.name
        find('button', text: /Send/).click

        expect(page).to have_content 'Message sent'
        click_on 'Sent items'

        expect(page).to have_content 'Message in a bottle'
      end
    end
  end
end
