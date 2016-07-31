class OrdersController < ApplicationController
  load_and_authorize_resource except: :show
  authorize_resource only: :show
  # Management cart on cookies or database order

  def new
    get_books
  end

  def update_shopcart_ajax
    set_session(ShopcartUpdate.new(@order, params).call)
    render nothing: true
  end

  def clear_cookies_shopcart
    cookies_delete
    redirect_to books_path
  end

  def check_cupon_ajax
    checking = Cupon.cheking(params[:value])
    msg = checking.empty? ? 'This code is not found' : checking_message(checking.first)
    render text: msg
  end

  def show
    @order = Order.find_by_id(params[:id])
    authorize! :show, @order # check it
  end

  def index
    get_books
    [:in_queue, :in_delivery, :delivered].each do |item|
      instance_variable_set("@#{item}".to_sym,
        Order.public_send(item, current_user))
    end
  end

  def destroy
    clear_order
    cookies_delete
    set_session('empty')
    redirect_to books_path
  end

  private

  def checking_message(first)
    str = 'Your discount is $' << first.discount.to_s << '. Continue?'
    first.use ? 'This code has been used' : str
  end

  def clear_order
    @order.order_items.destroy_all
    @order.update(total_price: 0.0, book_count: 0, order_total: 0.0)
  end

end
