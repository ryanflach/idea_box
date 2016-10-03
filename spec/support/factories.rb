FactoryGirl.define do
  factory :idea do
    title
    body Faker::Hacker.say_something_smart
  end

  # Use of n-1 due to sequence starting at 2 instead of 1 (or 0)
  sequence(:title) { |n| "Idea ##{n - 1}" }
end
