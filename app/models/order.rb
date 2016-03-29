class Order < ActiveRecord::Base
	validates :total_price, :completed_date, presence: true
	#validates :state, presence: true
	before_create :set_completed_date

	has_many :order_items
	belongs_to :user
	belongs_to :credit_card


	def create_order(cookies, total_price, user_id)
	  order = Order.create!( user_id: user_id, 
	  							 total_price: total_price, 
	  							 book_count: cookies["book_count"].to_i)
	  order.id
	end

	private

	def completed_date
    3.days.from_now
  end

  def set_completed_date
    self.completed_date = completed_date
  end

end
