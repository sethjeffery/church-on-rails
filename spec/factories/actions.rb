FactoryGirl.define do
  factory :action do
    action_type "MyString"
    actor nil
    actionable nil
    data "MyText"
  end
end
