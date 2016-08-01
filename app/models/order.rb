class Order < ActiveRecord::Base
  include AASM
  validates :total_price, :state, presence: true
  before_validation :set_completed_date

  has_many :order_items, dependent: :destroy
  belongs_to :user
  belongs_to :credit_card

  has_one :billing_address, class_name: 'Address', foreign_key: 'order_billing_address_id'
  has_one :shipping_address, class_name: 'Address', foreign_key: 'order_shipping_address_id'
  has_one :cupon

  aasm column: 'state' do
    state :in_progress
    state :in_queue
    state :in_delivery
    state :delivered
    state :canceled

    event :to_in_queue do
      transitions from: :in_progress, to: :in_queue
    end
  end

  def state_enum
    %w(in_progress
       processing
       shipping
       completed
       canceled)
  end

  def delivery_enum
    [['UPS Ground', '5.0'], ['UPS One Day', '10.0'], ['UPS Two Days', '20.0']]
  end

  scope :last_order_queue, -> (current_user) { 
    where(user_id: current_user.id, state: 'in_queue').last 
  }

  scope :in_queue, -> (current_user) { 
    where(user_id: current_user.id, state: 'in_queue').all 
  }

  scope :in_delivery, -> (current_user) {
    where(user_id: current_user.id, state: 'in_delivery').all
  }

  scope :delivered, -> (current_user) {
    where(user_id: current_user.id, state: 'delivered').all
  }

  def self.create_order(cookies, total_price, user_id)
    book_count = cookies.nil? ? 0 : cookies['book_count']
    order = Order.create(user_id: user_id,
                          total_price: total_price,
                          order_total: total_price + 5.0,
                          book_count: book_count.to_i)
    order.id
  end

  #def self.in_queue(current_user)
    #where(user_id: current_user.id, state: 'in_queue').all
  #end

  #def self.in_delivery(current_user)
    #where(user_id: current_user.id, state: 'in_delivery').all
  #end

  #def self.delivered(current_user)
    #where(user_id: current_user.id, state: 'delivered').all
  #end

  #def update_order(order, session, price)
    #order.book_count = session
    #order.total_price = order.total_price.to_f + price
    #order.completed_date = 3.days.from_now
    #order.order_total =  order.delivery.to_f + order.total_price.to_f
    #order.save!
  #end

  #def self.last_order_queue(current_user)
    # byebug
    # where("user_id = #{current_user.id}").order(id: :desc).first
    #where(user_id: current_user.id, state: 'in_queue').last
  #end

  #def self.in_queue(current_user)
    #where(user_id: current_user.id, state: 'in_queue').all
  #end

  #def self.in_delivery(current_user)
    #where(user_id: current_user.id, state: 'in_delivery').all
  #end

  #def self.delivered(current_user)
    #where(user_id: current_user.id, state: 'delivered').all
  #end

  # def delivery
  # byebug
  # if self.delivery.to_i == 5.0
  # 'UPS Ground'
  # elsif self.delivery.to_i == 10.0
  # 'UPS One Day'
  # elsif self.delivery.to_i == 20.0
  # 'UPS Two Days'
  # end
  # end

  private
  
  def set_completed_date
    self.completed_date = 3.days.from_now
  end
end
