FactoryBot.define do
  factory :record do
    key { Faker::Lorem.word }
    value { Faker::Lorem.word }
    timestamp { Faker::Time.between(from: 2.days.ago, to: Time.now) }
  end
end
