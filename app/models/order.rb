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

  def state_enum
    %w(in_progress
       in_queue
       in_delivery
       delivered
       canceled)
  end

  aasm column: 'state', whiny_transitions: false do 
    state :in_progress, initial: true
    state :in_queue
    state :in_delivery 
    state :delivered 
    state :canceled

    event :process do
      transitions from: :in_progress, to: :in_queue
    end

    event :ship do
      transitions from: :in_queue, to: :in_delivery
    end

    event :complete do
      transitions from: [:in_queue, :in_delivery], to: :delivered
    end

    event :cancel do
      transitions from: [:in_queue, :in_delivery], to: :canceled
    end
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

  private
  
  def set_completed_date
    self.completed_date = 3.days.from_now
  end
end
