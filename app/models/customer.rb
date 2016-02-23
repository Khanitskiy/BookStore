class Customer < ActiveRecord::Base
	validates :email, :password, :firstname, :lastname, presence: true
	validates :email, uniqueness: true

	has_many   :ratings
  has_many   :books, through: :ratings
  has_many   :orders
end
