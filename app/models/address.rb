class Address < ActiveRecord::Base
	validates_presence_of :firstname, :lastname, :address, :zipcode, :city, :phone, :country
end
