FactoryGirl.define do
  factory :idea do
    title
    body 'great!'
  end

  sequence :title do |n|
    "Idea ##{n}"
  end
end
