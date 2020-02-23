FactoryBot.define do
  factory :merchant_user, class: User do
    name              { Faker::Games::Overwatch.hero }
    address           { Faker::Address.street_address }
    city              { GOTFaker::Geography.region }
    state             { Faker::Address.state_abbr }
    zip               { Faker::Address.zip }
    email             { Faker::Internet.email }
    password          { "burger32" }
    role              { 1 }
    association       :merchant, factory: :random_merchant
  end
end
