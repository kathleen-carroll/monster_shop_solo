FactoryBot.define do
  factory :random_item_order, class: ItemOrder do
    price             { Faker::Commerce.price }
    quantity          { rand(0..25) }
    association       :order, factory: :random_order
    association       :item, factory: :random_item
  end
end
