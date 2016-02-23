FactoryGirl.define do
  factory :customer do
    email      { Faker::Internet.email } 
    password   { Faker::Internet.password } 
    firstname  { Faker::Name.first_name } 
    lastname   { Faker::Name.last_name } 
  end
end
