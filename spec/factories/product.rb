FactoryBot.define do
  factory :product do
    store
    name { Faker::Lorem.word }
    price { Random.rand(0.1..10000) }
  end
end
