class OrderStepsForm
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Model

  attribute :step
  attribute :atributes
  attribute :and_shipping
  attribute :order
  attribute :name, String
  attribute :company_name, String
  attribute :email, String
  attribute :current_step
  attribute :valid
  attribute :user
  attribute :last_order

  STEP_TYPE = { :address => 1, :delivery => 2, :payment => 3, :confirm => 4, :complete => 5 }

  def initialize(order, checkout_params)
    self.order        = order
    self.user         = checkout_params[0]
    self.step         = checkout_params[1]
    self.and_shipping = checkout_params[2] if checkout_params[2]
    self.atributes    = checkout_params[3] if checkout_params[3]
  end

  # Forms are never themselves persisted
  def persisted?
    false
  end

  def save
    persist!
    self.valid ? update_step : false
  end

  def order_items
    order.order_items
  end

  def credit_card
    order.credit_card ? order.credit_card : payment
  end

  def payment
    credit_card = CreditCard.new(user_id: @order.user_id)
    order.update(credit_card_id: credit_card.id)
    credit_card
  end

  def billing_address
    billing_shipping_adresses(:billing_address)
  end

  def shipping_address
    billing_shipping_adresses(:shipping_address)
  end

  def billing_shipping_adresses(address)
    order.public_send(address) ||
      user.public_send(address) ||
        Address.new("order_#{address.to_s}_id".to_sym => order.id)
  end

  def delivery
    order.delivery
  end

  def month
    order.credit_card.expiration_month
  end

  def year
    order.credit_card.expiration_year
  end

  private

  def update_step
    order.update(step_number: STEP_TYPE[step])
  end

  def persist!
    self.valid = true
    case step
    when :address
      address_logic
    when :delivery
      delivery_logic
    when :payment
      payment_logic
    when :confirm
      confirm_logic
    end
  end

  private

  def address_logic
    ChangeAddressService.new(order, and_shipping, atributes).call
    self.valid = false if errors_addresses
  end

  def delivery_logic
    order.update(delivery: get_delivery, order_total: addition_total_price)
  end

  def payment_logic
    SetCreditCardService.new(order, atributes[:payment]).call
    self.valid = false if order.credit_card.errors.any?
  end

  def confirm_logic
    update_cupon if @order.cupon
    order.to_in_queue!
    @cookies_book = { 'book_count' => '0'}
    order_id = Order.create_order(@cookies_book, 0, user.id)
  end

  def errors_addresses
    order.billing_address.errors.any? || order.billing_address.errors.any?
  end

  def update_cupon
    order.update(order_total: order.order_total.to_f - order.cupon.discount)
  end

  def addition_total_price
    order.total_price.to_f + get_delivery
  end

  def get_delivery
    atributes[:delivery_type][:delivery].to_f
  end

  def any_error?(val)
    order.val.errors.any? || order.val.errors.any?
  end

end
