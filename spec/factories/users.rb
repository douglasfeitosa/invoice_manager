FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    token { SecureRandom.uuid }
    email_token { SecureRandom.uuid }
  end
end