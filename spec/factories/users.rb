FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    username { Faker::Internet.unique.username }
    password { "password123" }
  end
end
