FactoryGirl.define do
  factory :church_process do
    name    { Faker::Lorem.sentence }
    steps   { ["one", "two", "three"] }
  end

  factory :person_process do
    person
    church_process

    trait :active do
      complete { false }
    end
    trait :complete do
      complete { true }
    end
  end

  factory :user do
    email         { Faker::Internet.email }
    password      { Faker::Internet.password }
  end

  factory :person do
    first_name    { Faker::Name.first_name }
    last_name     { Faker::Name.last_name }
  end

  factory :family do
    name          { Faker::Name.last_name }
  end

  factory :event do
    name  { Faker::Lorem.sentence }
  end

  factory :team do
    name  { Faker::Lorem.sentence }
  end
end
