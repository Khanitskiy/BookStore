FactoryGirl.define do
  factory :order_item do
    quantity  { Faker::Number.between(1, 10) } 
  end
end
