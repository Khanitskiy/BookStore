FactoryGirl.define do
  factory :rating do
    title        { Faker::Name.title }
    text_review  { Faker::Lorem.sentence(3) }
    book_id      { Faker::Number.between(1, 10) }
    user_id      { Faker::Number.between(1, 10) }
  end
end
