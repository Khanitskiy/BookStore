class Address < ActiveRecord::Base
	validates :firstname, :lastname, :address, :zipcode, :city, :phone, :country, presence: true
end
