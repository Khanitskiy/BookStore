FactoryGirl.define do
  factory :order do
  	total_price  { Faker::Commerce.price } 
    completed_date  { Faker::Date.between(2.days.ago, Date.today) } 
  end
end
