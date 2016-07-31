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
    if valid
      update_step
      true
    else
      false
    end
  end

  def order_items
    self.order.order_items
  end

  def credit_card
    payment
  end

  def payment
    if order.credit_card
      order.credit_card
    else
      credit_card = CreditCard.new(user_id: @order.user_id)
      order.update(credit_card_id: credit_card.id)
      credit_card
    end
  end

  def billing_address
    order.billing_address || user.billing_address  || Address.new(order_billing_address_id: order.id)
    billing_shipping_adresses(:billing_address)
  end

  def shipping_address
    order.shipping_address || user.shipping_address  || Address.new(order_shipping_address_id: order.id)
    billing_shipping_adresses(:shipping_address)
  end

  def billing_shipping_adresses(address)
    order.public_send(address) || user.public_send(address) || Address.new("order_#{address.to_s}_id".to_sym => order.id)
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

  #def set_and_shipping(params, step)
  #  params[:order_steps_form][:billing_address][:and_shipping if step == :address
  #end

  #def step_address?
  #  step.to_s == 'address'
  #end

  #def step_payment?
  #  step.to_s == 'payment'
  #end

  def update_step
    order.update(step_number: STEP_TYPE[step])
  end

  def persist!
    self.valid = true
    case step
    when :address
      ChangeAddressService.new(order, and_shipping, atributes).call
      valid = false if order.billing_address.errors.any? || order.billing_address.errors.any?
    when :delivery
      order.update(delivery: atributes[:delivery_type][:delivery].to_f,
                   order_total: order.total_price.to_f + atributes[:delivery_type][:delivery].to_f)
    when :payment
      if order.credit_card
        order.credit_card.update(atributes[:payment])
      else
        order.create_credit_card(atributes[:payment])
      end
      self.valid = false if order.credit_card.errors.any?
    when :confirm
      if @order.cupon
        order.update(order_total: order.order_total.to_f - order.cupon.discount)
      end
      order.to_in_queue!
      # @order_items = OrderItem.new()
      @cookies_book = { 'book_count' => '0'}
      order_id = Order.create_order(@cookies_book, 0, user.id)
      #OrderItem.create_items(@cookies_book, order_id)
    end
  end

  def addresses_create
    order.create_billing_address(atributes[:billing_address])
    order.create_shipping_address(atributes[:billing_address])
  end

  def addresses_update
    order.billing_address.update(atributes[:billing_address])
    order.shipping_address.update(atributes[:shipping_address])
  end

end