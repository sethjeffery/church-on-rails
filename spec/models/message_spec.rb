require 'rails_helper'

RSpec.describe Message, type: :model do
  subject { build(:message) }

  describe 'callbacks' do
    context 'after_create' do
      it 'sends' do
        expect(subject).to receive(:send!)
        subject.save
      end
    end

    context 'before_validation' do
      it 'compacts the person_ids' do
        subject.person_ids = ["", "1"]
        subject.valid?
        expect(subject.person_ids).to eq ["1"]
      end
    end
  end

  describe '#send_to_people?' do
    it 'requires send_to == people' do
      subject.send_to = nil
      expect(subject.send_to_people?).to be false
      subject.send_to = 'people'
      expect(subject.send_to_people?).to be true
    end
  end

  describe '#send_to_team?' do
    it 'requires send_to == team' do
      subject.send_to = nil
      expect(subject.send_to_team?).to be false
      subject.send_to = 'team'
      expect(subject.send_to_team?).to be true
    end
  end

  describe '#build_reply' do
    let(:person) { build(:person) }
    let(:reply) { subject.build_reply(sender: person) }

    it 'returns a duplicate message' do
      expect(reply).to be_a Message
      expect(reply).not_to eq subject
    end

    it 'replies to message sender' do
      expect(reply.send_to_people?).to be true
      expect(reply.person_ids).to eq [subject.sender.id]
    end

    it 'can take args' do
      expect(reply.sender).to eq person
    end

    it 'quotes original message' do
      expect(reply.message).to eq "\n\n> #{subject.message}"
    end

    it 'class method usage' do
      expect(subject).to receive(:build_reply)
      Message.reply_to(subject)
    end
  end

  describe '#build_forward' do
    let(:person) { build(:person) }
    let(:forward) { subject.build_forward(sender: person) }

    it 'returns a duplicate message' do
      expect(forward).to be_a Message
      expect(forward).not_to eq subject
    end

    it 'does not reply to message sender' do
      expect(forward.send_to_people?).to be true
      expect(forward.person_ids).to eq []
    end

    it 'can take args' do
      expect(forward.sender).to eq person
    end

    it 'quotes original message' do
      expect(forward.message).to eq "\n\n> #{subject.message}"
    end

    it 'class method usage' do
      expect(subject).to receive(:build_forward)
      Message.forward(subject)
    end
  end

  describe 'sending' do
    context 'send_to_people?' do
      it 'adds recipients for each person' do
        recipients = create_list(:person, 2)
        subject.send_to = :people
        subject.person_ids = recipients.map(&:id)
        subject.save!
        expect(subject.message_recipients.map(&:recipient_id)).to match_array(recipients.map(&:id))
      end
    end

    context 'send_to_team?' do
      it 'adds recipients for each team member' do
        members = create_list(:person, 2)
        team = create(:team)
        members.each { |m| m.join team }
        subject.send_to = :team
        subject.team_id = team.id
        subject.save!
        expect(subject.message_recipients.map(&:recipient_id)).to match_array(members.map(&:id))
      end
    end

    context 'sms?' do
      it 'sends sms messages'
    end

    context 'email?' do
      let(:recipients) { create_list(:person, 2, email: 'test@example.com') }
      subject { build(:message, email: true, send_to: :people, person_ids: recipients.map(&:id)) }

      it 'sends emails' do
        expect(MessageMailer).to receive(:receive_message).twice.and_return(double(deliver_now: true))
        subject.save!
      end
    end
  end
end
