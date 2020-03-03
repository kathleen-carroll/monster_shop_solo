FactoryBot.define do
  factory :discount, class: Discount do
    name              { Faker::Subscription.plan + " " + Faker::Hipster.sentence(word_count: 1) }
    item_count        { ((Faker::Number.within(range: 20..100))/10).round * 10 }
    percent           { ((Faker::Number.within(range: 5..35))/5).round * 5}
    association       :merchant, factory: :random_merchant
  end
end
