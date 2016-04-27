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


  def initialize(order)
    self.order = order
  end

  # Forms are never themselves persisted
  def persisted?
    false
  end
 
  def save
    persist!
    if self.valid
      update_step
      true
    else
      #byebug
      false
    end
  end

  def order_items
    order.order_items
  end

  def credit_card
    self.payment
  end

  def payment
    if order.credit_card.nil?
      credit_card = CreditCard.new(user_id: @order.user_id)
      order.update(credit_card_id: credit_card.id)
      credit_card
    else
      order.credit_card
    end
  end

  def billing_address
    #byebug
    if order.billing_address.nil?
      if user.billing_address.nil? 
        billing_address = Address.new( order_billing_address_id: @order.id)
        billing_address
      else
        billing_address = user.billing_address
        billing_address
      end
    else
      order.billing_address
    end
  end

  def shipping_address
    if order.shipping_address.nil?
      if user.shipping_address.nil? 
        shipping_address = Address.new( order_shipping_address_id: @order.id)
        shipping_address
      else
        shipping_address = user.shipping_address
        shipping_address
      end
    else
      order.shipping_address
    end
  end

  def delivery
    order.delivery
  end

  def month
     @order.credit_card.expiration_month
  end

  def year
     @order.credit_card.expiration_year
  end

  private

  def step_address?
    step.to_s == 'address'
  end

  def step_payment?
    step.to_s == 'payment'
  end

  def update_step
    case step
    when :address
      @order.update(step_number: 1)
    when :delivery
      @order.update(step_number: 2)
    when :payment
      @order.update(step_number: 3)
    when :confirm
      @order.update(step_number: 4)
    when :complete
      @order.update(step_number: 5)
    end
  end

  def persist!
    self.valid = true
    #byebug
    case step
    when :address
      if and_shipping == 'true'
        if order.billing_address.nil? && order.shipping_address.nil?
          order.create_billing_address(atributes[:billing_address])
          order.create_shipping_address(atributes[:billing_address])
        else
          order.billing_address.update(atributes[:billing_address])
          order.shipping_address.update(atributes[:shipping_address])
        end
      else
        if order.billing_address.nil? || order.shipping_address.nil?
          #byebug
          order.create_billing_address(atributes[:billing_address])
          order.create_shipping_address(atributes[:shipping_address])
        else
          #byebug
          order.billing_address.update(atributes[:billing_address])
          order.shipping_address.update(atributes[:shipping_address])
        end
      end
      self.valid = false if order.billing_address.errors.any? || order.shipping_address.errors.any?
    when :delivery
       order.update( delivery: atributes[:delivery_type][:delivery].to_f,
                     order_total: order.total_price.to_f + atributes[:delivery_type][:delivery].to_f) 
    when :payment
      #byebug
      if order.credit_card.nil?
        order.create_credit_card(atributes[:payment])
      else
        order.credit_card.update(atributes[:payment])
      end
      self.valid = false if order.credit_card.errors.any?
    when :confirm
      unless @order.cupon.nil?
        order.update(order_total: order.order_total.to_f - order.cupon.discount)
      end
      order.to_in_queue!
      @new_order = Order.new()
      @order_items = OrderItem.new()
      @cookies_book = { "book_count" => "0", "total_price" => "0"}
      order_id = @new_order.create_order(@cookies_book, 0,  user.id)
      @order_items.create_items(@cookies_book, order_id)
    end
  end

end