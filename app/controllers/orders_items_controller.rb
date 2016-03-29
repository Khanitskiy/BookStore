class OrdersItemsController < ApplicationController

	def update

	end

	def destroy
		#byebug
		@order.total_price = @order.total_price - params[:product_count].to_i * Book.find_by_id(params[:id]).price.to_f
		@order.save
		@order.order_items.find_by_book_id(params[:id]).destroy
		session[:user_products_count] = session[:user_products_count].to_i - params[:product_count].to_i
		if session[:user_products_count] == 0
			session[:user_products_count] = 'empty'
		end
		render nothing: true
	end

end
