FactoryGirl.define do
  factory :idea do
    title "Idea!"
    body Faker::Hacker.say_something_smart
  end
end
