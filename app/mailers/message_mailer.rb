class MessageMailer < ApplicationMailer
  default from: Proc.new { mail_from }
  layout 'mailer'
  helper :users
  helper :application
  include UsersHelper
  include MailHelper

  def receive_message(message_recipient)
    @message = message_recipient.message
    mail to: message_recipient.recipient.email, subject: @message.subject, reply_to: @message.sender.email
  end
end
