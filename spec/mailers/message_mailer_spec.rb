require "rails_helper"

RSpec.describe MessageMailer, type: :mailer do
  describe "receive_message" do
    let(:mail) { MessageMailer.receive_message(message_recipient) }
    let(:sender) { create(:person, email: 'sender@example.com') }
    let(:recipient) { create(:person, email: 'recipient@example.com') }
    let(:message) { create(:message, sender: sender) }
    let(:message_recipient) { create(:message_recipient, message: message, recipient: recipient) }

    it "renders the headers" do
      expect(mail.subject).to eq(message.subject)
      expect(mail.to).to eq([recipient.email])
      expect(mail.from).to eq(["no-reply@example.com"])
      expect(mail.reply_to).to eq([sender.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Message from #{sender}")
      expect(mail.body.encoded).to match("example.com/messages/#{message.id}")
    end
  end
end
