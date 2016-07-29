class ShopcartUpdate
  def initialize(order, params)
    @order = order
    @params = params
  end

  def call
  	total_price = 0
    quantity = 0
    @params.try(:each) do |item|
      if item.first != 'controller' && item.first != 'action'
        @order.order_items
              .find_by_book_id(item.first)
              .update(book_id: item.first, quantity: item.second)
        byebug
        total_price += Book.find_by_id(item.first).price * item.second.to_f
        quantity += item.second.to_i
      end
    end
    @order.update(total_price: total_price,
                  book_count:  quantity,
                  order_total: @order.delivery.to_f + total_price)
    quantity
  end

  private
end