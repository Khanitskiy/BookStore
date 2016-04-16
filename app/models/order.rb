class Order < ActiveRecord::Base
  include AASM
  validates :total_price, :completed_date, presence: true
  #validates :state, presence: true
  before_validation :set_completed_date

  has_many :order_items
  belongs_to :user
  belongs_to :credit_card

  has_one :billing_address, class_name: 'Address', foreign_key: 'order_billing_address_id'
  has_one :shipping_address, class_name: 'Address', foreign_key: 'order_shipping_address_id'

  STATE_LIST = ["in_progress", 
            "processing", 
            "shipping", 
            "completed", 
            "canceled"]

  DELIVERY_METHOD_LIST = ["UPS Ground", 
                        "UPS One Day", 
                        "UPS Two Days"]


  aasm :column => 'state' do

    state :in_progress
    state :in_queue
    state :in_delivery
    state :delivered
    state :canceled


    event :to_in_queue do
      transitions :from => :in_progress, :to => :in_queue
    end

  end

  def state_enum
    STATE_LIST
  end

  def delivery_enum
    DELIVERY_METHOD_LIST
  end

  def create_order(cookies, total_price, user_id)
    order = Order.create!( user_id: user_id, 
                   total_price: total_price, 
                   book_count: cookies["book_count"].to_i)
    order.id
  end

  def self.last_order_queue(current_user)
    #byebug
    where("user_id = #{current_user.id}").order(id: :desc).first
  end

  def self.in_queue(current_user)
    where(user_id: current_user.id, state: 'in_queue').all
  end
  
  def self.in_delivery(current_user)
    where(user_id: current_user.id, state: 'in_delivery').all
  end

  def self.delivered(current_user)
    where(user_id: current_user.id, state: 'delivered').all
  end

  private

  #def completed_date
    #3.days.from_now
  #end

  def set_completed_date
    self.completed_date = 3.days.from_now
  end

  #def now_date
  #  Time.now().strftime("%Y-%m-%d")
  #end

  #def set_completed_date(day)
  #  self.completed_date = day == "infinity" ? "infinity" : day.days.from_now
  #end

end