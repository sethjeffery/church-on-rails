module MailHelper
  def mail_from
    Church.first.try(:email) || "no-reply@#{(ENV["HOST_NAME"] || 'example.com').to_s.sub(/^(https?:\/\/)?www\./, '')}"
  end
end
