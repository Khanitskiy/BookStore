FactoryGirl.define do
  factory :country do
    name  { Faker::Address.city } 
  end
end
