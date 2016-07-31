class OrderItemsController < ApplicationController
  #load_and_authorize_resource
  
  def update
    addition_of_session(params[:quantity].to_i)
    OrderUpdate.new(@order, session, calc_price(params[:book_id], params[:quantity])).call
    items_update_or_create(get_order_items)
    render nothing: true
  end

  def destroy
    @order.update(total_price: calc_total_price,
                  order_total: calc_order_total,
                  book_count:  calc_book_count)
    @order.order_items.find_by_book_id(params[:id]).destroy
    change_session
    render nothing: true
  end

  private

  def get_order_items
    book_id = params[:book_id]
    items = @order.order_items
    items.find_by_book_id(book_id) || items.new(book_id: book_id)
  end

  def items_update_or_create(order_items)
    if order_items
      params[:quantity] = params[:quantity].to_i + order_items[:quantity].to_i
      order_items.update(order_params)
    else
      order.order_items.create(order_params)
    end
  end

  def calc_total_price
    @order.total_price - calc_price(params[:id], params[:product_count])
  end

  def calc_price(id, param)
    Book.find_by_id(id).price.to_f * param.to_i
  end

  def calc_order_total
    @order.total_price.to_f + @order.delivery.to_f
  end

  def calc_book_count
    @order.book_count - params[:product_count].to_i
  end

  def order_params
    params.permit(:book_id, :quantity, :value)
  end

end