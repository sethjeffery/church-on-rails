FactoryGirl.define do
  factory :child_group_membership do
    child_group
    person

    trait :checked_in do
      checked_in true
    end

    trait :checked_out
  end
end
