FactoryGirl.define do
  factory :cupon do
    value             { Faker::Lorem.characters(9) } 
  end
end
