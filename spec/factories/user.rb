FactoryBot.define do
  factory :random_user, class: User do
    name              {Faker::Movies::Lebowski.actor}
    address           {Faker::Address.street_address}
    city              {Faker::Address.city}
    state             {Faker::Address.state_abbr}
    zip               {rand(0..99999).to_s.rjust(4)}
    email             {Faker::Internet.email}
    password          {"burger32"}
  end
end
