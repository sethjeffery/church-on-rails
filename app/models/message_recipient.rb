class MessageRecipient < ApplicationRecord
  delegate :subject, :sender, to: :message

  belongs_to :message
  belongs_to :recipient, class_name: 'Person', foreign_key: :recipient_id

  validates_presence_of :recipient_id, :message_id

  after_create :send!

  def send!
    send_email! if email?
    send_sms! if sms?
  end

  def content
    message.message
  end

  private

  def send_email!
    MessageMailer.receive_message(self).deliver_now
  end

  def send_sms!
    warn "SMS service not implemented yet"
  end
end
