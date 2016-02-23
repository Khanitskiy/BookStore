FactoryGirl.define do
  factory :book do
    title 		  { Faker::Book.title } 
    price       { Faker::Commerce.price } 
    description { Faker::Lorem.paragraph }
    in_stock    { Faker::Number.between(1, 200) }
  end
end
