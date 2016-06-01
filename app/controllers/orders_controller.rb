class OrdersController < ApplicationController
  load_and_authorize_resource except: :show
  authorize_resource only: :show
  # Management cart on cookies or database order
  def new
    if current_user
      get_books_in_order
    else
      @cookies_book = JSON.parse(cookies[:books]) if cookies[:books]
      get_books_in_order_not_auth(@cookies_book)
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
    @order.completed_date = 3.days.from_now
    @order.order_total =  @order.delivery.to_f + @order.total_price.to_f
    @order.save!

    if @order_items
      params[:quantity] = params[:quantity].to_i + @order_items[:quantity].to_i
      @order_items.update(order_params)
    else
      @order.order_items.create(order_params)
    end

    render nothing: true
  end

  def update_shopcart_ajax
    total_price = 0
    quantity = 0
    params.try(:each) do |item|
      if item.first != 'controller' && item.first != 'action'
        @order.order_items
              .find_by_book_id(item.first)
              .update(book_id: item.first, quantity: item.second)

        total_price += Book.find_by_id(item.first).price * item.second.to_f
        quantity += item.second.to_i
      end
    end
    @order.update(total_price: total_price,
                  book_count: quantity,
                  order_total: @order.delivery.to_f + total_price)
    session[:user_products_count] = quantity
    render nothing: true
  end

  def check_cupon_ajax
    checking = Cupon.cheking(params[:value])
    if checking
      if checking.use
        render text: 'This code has been used'
      else
        render text: 'Your discount is $' << checking.discount.to_s << '. Continue?'
      end
    else
      render text: 'This code is not found'
    end
  end

  def show
    #byebug

    @order = Order.find_by_id(params[:id])
    #authorize_resource
    authorize! :show, @order
    #byebug
  end

  def index
    get_books_in_order
    @in_queue    = Order.in_queue(current_user)
    @in_delivery = Order.in_delivery(current_user)
    @delivered   = Order.delivered(current_user)
  end

  def destroy
    @order.order_items.destroy_all
    @order.update(total_price: 0.0, book_count: 0, order_total: 0.0)
    cookies.delete :user_products_count
    session[:user_products_count] = 'empty'
    redirect_to books_path
  end

  private

  def order_params
    params.permit(:book_id, :quantity, :value)
  end

  def get_books_in_order
    @ids = []
    @cookies_hash = {}
    @order.order_items.try(:each) do |item|
      @cookies_hash[item.book_id.to_s] = item.quantity
      @ids << item.book_id
    end
    @books = Book.where(id: @ids)
    @subtotal = @order.total_price.to_f
  end
end
