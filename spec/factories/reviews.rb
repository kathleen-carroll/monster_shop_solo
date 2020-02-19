FactoryBot.define do
  factory :random_review, class: User do
    title             { Faker::Hipster.sentence(word_count: 4) }
    content           { Faker::TvShows::SouthPark.quote }
    rating            { rand(1..5) }
    item_id           { rand(1..1000) }
  end
end
