class OrdersController < ApplicationController


  # Management cart on cookies or database order
  def new
    
    if current_user
      @ids = Array.new
      @cookies_hash = Hash.new
      @order.order_items.try(:each) do |item| 
        @cookies_hash[item.book_id.to_s] = item.quantity
        @ids << item.book_id
      end
      @books = Book.where(:id => @ids)
      @subtotal = @order.total_price.to_f
    else
      @cookies_book = JSON.parse(cookies[:books]) if cookies[:books]
      total_price(@cookies_book)
    end
  end

  def clear_cookies_shopcart
    cookies.delete :books
    redirect_to books_path 
  end

  def update
    price = Book.find_by_id(params[:book_id]).price.to_f * params[:quantity].to_i
    @order_items = @order.order_items.find_by_book_id(params[:book_id]) || @order.order_items.new(book_id: params[:book_id])

    session[:user_products_count] = session[:user_products_count].to_i + params[:quantity].to_i
    @order = Order.find_by_id(@order.id)
    @order.book_count = session[:user_products_count]
    @order.total_price = @order.total_price + price
    @order.completed_date =  3.days.from_now
    @order.order_total =  @order.delivery.to_f +  @order.total_price.to_f
    #byebug
    @order.save!

    unless @order_items == nil
      params[:quantity] = params[:quantity].to_i + @order_items[:quantity].to_i
      @order_items.update(order_params)
    else 
      @order.order_items.create(order_params)
    end

    render nothing: true
  end

  def update_shopcart_ajax
    #byebug
    total_price = 0
    quantity = 0
    params.try(:each) do |item| 
      if item.first != "controller" && item.first != "action"
        @order.order_items.find_by_book_id(item.first).update(book_id: item.first, quantity: item.second)
        total_price = total_price + Book.find_by_id(item.first).price * item.second.to_f
        quantity = quantity + item.second.to_i
      end
    end
    @order.update(total_price: total_price, 
                  book_count: quantity,
                  order_total: @order.delivery.to_f + total_price)
    session[:user_products_count] = quantity
    render nothing: true
  end

  def show

  end

  def index
    #render json: { "current_user" => current_user, "logged_in" => user_signed_in? }, :layout => false
    #format.json { render :json => {'ok'=>true} }
  end

  def destroy
    @order.order_items.destroy_all
    #@order.destroy
    cookies.delete :user_products_count
    session[:user_products_count] = 'empty'
    redirect_to books_path 
  end

  def add_to_order

  end

  private

    def order_params
      params.permit(:book_id, :quantity)
    end

end
