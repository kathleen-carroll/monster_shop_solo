FactoryBot.define do
  factory :random_merchant, class: Merchant do
    name              { GOTFaker::House.name }
    address           { Faker::Address.street_address }
    city              { GOTFaker::Geography.region }
    state             { Faker::Address.state_abbr }
    zip               { Faker::Address.zip }
  end
end
