FactoryBot.define do
  factory :user do
    first_name { "Ajai" }
    last_name { "Ganesh" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "Bigil@1061" }
    status { :created }
  end
end
