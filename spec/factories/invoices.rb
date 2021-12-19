FactoryBot.define do
  factory :invoice do
    user { create(:user) }
    number { '123456789' }
    date { DateTime.new(2021, 12, 18) }
    company { 'Apple' }
    billing_for { 'DFG' }
    total { '9.99' }
    emails { "douglasfeitosa@outlook.com\n" }

    trait :invalid_email do
      emails { "douglasfeitosa@outlook\n" }
    end
  end
end
