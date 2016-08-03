class OrderUpdateService
  def initialize(order, session, price)
    @order = order
    @session = session
    @price   = price
  end

  def call
    @order.book_count = @session[:user_products_count]
    @order.total_price = @order.total_price + @price
    @order.completed_date = 3.days.from_now
    @order.order_total =  @order.delivery.to_f + @order.total_price.to_f
    @order.save
  end
end