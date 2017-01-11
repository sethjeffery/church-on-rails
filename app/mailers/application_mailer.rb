class ApplicationMailer < ActionMailer::Base
  default from: Proc.new { mail_from }
  layout 'mailer'
  helper :users
  include UsersHelper
  include MailHelper
end
