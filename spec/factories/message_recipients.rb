FactoryGirl.define do
  factory :message_recipient do
    message
    recipient factory: :person
    email false
    sms false
    read false
  end
end
