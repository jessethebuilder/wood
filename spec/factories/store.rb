FactoryBot.define do
  factory :store do
    name { Faker::Company.name }

    user
  end
end
