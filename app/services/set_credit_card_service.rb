class SetCreditCardService
  def initialize(order, payment)
    @order = order
    @payment = payment
  end

  def call
    if @order.credit_card
      @order.credit_card.update(@payment)
    else
      @order.create_credit_card(@payment)
    end
  end

end