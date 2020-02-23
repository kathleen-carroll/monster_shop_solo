FactoryBot.define do
  factory :random_order, class: Order do
    name              { Faker::Games::ElderScrolls.name }
    address           { Faker::Address.street_address }
    city              { GOTFaker::Geography.region }
    state             { Faker::Address.state_abbr }
    zip               { Faker::Address.zip }
    association       :user, factory: :regular_user
  end
end
