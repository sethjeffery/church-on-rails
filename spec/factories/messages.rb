FactoryGirl.define do
  factory :message do
    subject "Subject"
    message "Message"
    sender factory: :person
    email false
    sms false
  end
end
