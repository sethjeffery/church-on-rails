FactoryGirl.define do
  factory :person_property do
    association :propertyable, factory: :person
    property
  end
end
