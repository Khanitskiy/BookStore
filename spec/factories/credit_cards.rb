FactoryGirl.define do
  factory :credit_card do
    
  	number  				  { Faker::Business.credit_card_number } 
    cvv               { Faker::Number.number(4) } 
    expiration_month 	{ Faker::Number.between(1, 12) }
    expiration_year   { Faker::Number.number(4) }
    firstname  				{ Faker::Name.first_name }
    last_name 				{ Faker::Name.last_name }

  end
end
