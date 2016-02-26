class Order < ActiveRecord::Base
	validates :total_price, :completed_date, presence: true
	#validates :state, presence: true

	has_many :order_items
	belongs_to :user
	belongs_to :credit_card
end
