class OrdersItemsController < ApplicationController
  load_and_authorize_resource
  
  def update
  end

  def destroy
    @order.total_price = @order.total_price - params[:product_count].to_i * Book.find_by_id(params[:id]).price.to_f
    @order.order_total = @order.total_price.to_f + @order.delivery.to_f
    @order.book_count = @order.book_count - params[:product_count].to_i
    # byebug
    @order.save
    @order.order_items.find_by_book_id(params[:id]).destroy
    session[:user_products_count] = session[:user_products_count].to_i - params[:product_count].to_i
    if session[:user_products_count] == 0
      session[:user_products_count] = 'empty'
    end
    render nothing: true
  end
end
