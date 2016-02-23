class Address < ActiveRecord::Base
	validates :address, :zipcode, :city, :phone, :country, presence: true
end
