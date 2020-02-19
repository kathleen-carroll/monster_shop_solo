FactoryBot.define do
  factory :random_review, class: Review do
    title             { Faker::Hipster.sentence(word_count: 4) }
    content           { Faker::TvShows::SouthPark.quote }
    rating            { rand(1..5) }
    association    :item, factory: :random_item
  end
end
