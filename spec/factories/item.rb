FactoryBot.define do
  factory :random_item, class: Item do
    sequence(:name)   { Faker::Commerce.product_name }
    description       { Faker::Hipster.sentence(word_count: 5) }
    price             { Faker::Commerce.price }
    sequence(:image)  { |n| "https://picsum.photos/id/#{1000 + n}/300/300" }
    active?           { true }
    inventory         { rand(1..100) }
    merchant_id       { rand(1..100) }
  end
end
