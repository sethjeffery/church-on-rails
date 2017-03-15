module MailHelper
  def mail_from
    church = Church.first
    if church&.email.present?
      church.email
    else
      "no-reply@#{(ENV["HOST_NAME"] || 'example.com').to_s.sub(/^(https?:\/\/)?www\./, '')}"
    end
  end
end
