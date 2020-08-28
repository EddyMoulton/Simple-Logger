FactoryBot.define do
  factory :record do
    key { Faker::Lorem.word }
    value { Faker::Lorem.word }
  end
end