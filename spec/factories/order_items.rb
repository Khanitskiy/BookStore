FactoryGirl.define do
  factory :order_item do
    price      { Faker::Commerce.price } 
    quantity   { Faker::Number.between(1, 10) } 
  end
end
