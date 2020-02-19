FactoryBot.define do
  factory :random_item, class: Item do
    sequence(:name)   {|n| "#{Faker::Commerce.product_name} #{n}"}
    description       {Faker::Lorem.sentence}
    price             {rand(1..100)}
    sequence(:image)  {|n| "https://picsum.photos/id/#{1000 + n}/300/300"}
    active?           {true}
    inventory         {rand(1..100)}
    association       :merchant, factory: :factory_shop
  end
end
