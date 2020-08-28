FactoryBot.define do
  factory :creator do
    name { Faker::Lorem.word }
  end
end