FactoryGirl.define do
  factory :category do
    title  { Faker::Category.title }
  end
end
