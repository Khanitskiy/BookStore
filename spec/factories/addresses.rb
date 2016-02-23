FactoryGirl.define do
  factory :address do
  	address  { Faker::Address.city } 
    zipcode  { Faker::Address.zip_code } 
    city     { Faker::Address.city }
    phone 	 { Faker::PhoneNumber.phone_number }
    country  { Faker::Address.country }
  end
end