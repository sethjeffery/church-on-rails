FactoryGirl.define do
  factory :child_group_checkin do
    child_group_membership

    trait :checked_in do
      checked_in_at { Time.now }
    end

    trait :checked_out do
      checked_in_at { Time.now }
      checked_out_at { Time.now }
    end
  end
end
