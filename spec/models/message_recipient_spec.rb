require 'rails_helper'

RSpec.describe MessageRecipient, type: :model do
  let(:message) { build(:message) }
  subject { build(:message_recipient, message: message) }

  context 'delegates to message' do
    it 'sender' do
      expect(subject.sender).to eq message.sender
    end

    it 'content' do
      expect(subject.content).to eq message.message
    end

    it 'subject' do
      expect(subject.subject).to eq message.subject
    end
  end
end
