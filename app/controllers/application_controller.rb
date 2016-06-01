class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :load_in_progress_order, if: :current_user
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/', alert: exception.message
  end

  def set_locale
    I18n.locale = params[:locale] || session[:omniauth_login_locale] || I18n.default_locale
    session[:omniauth_login_locale] = I18n.locale
  end

  def create_addresses_obj
    @billing_address = Address.find_or_create_by(user_billing_address_id: current_user.id)
    @shipping_address = Address.find_or_create_by(user_shipping_address_id: current_user.id)
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def load_in_progress_order
    if current_user
      @order = current_user.orders.where(state: 'in_progress').first
      session[:user_products_count] = @order.book_count
    end
  end

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    new_facebook_user
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  def new_facebook_user
    if new_facebook_user?(current_user)
      after_sign_up
    else
      after_sign_in unless current_user.id == 1
    end
  end

  def after_sign_in(id = false)
    load_in_progress_order

    cookies_json_parse
    cookies_nil
    session[:user_products_count] = @order.book_count + @cookies_book['book_count'].to_i
    @order.update(total_price: total_price(@cookies_book) + @order.total_price.to_f,
                  order_total: total_price(@cookies_book) + 5.0 + @order.total_price.to_f,
                  book_count:  @cookies_book['book_count'].to_i + @order.book_count.to_i)
    OrderItem.update_items(@cookies_book, @order.id)
    cookies.delete :books
  end

  def after_sign_up(id = false)
    id = current_user.id unless id
    cookies_json_parse
    cookies_nil

    order_id = Order.create_order(@cookies_book, total_price(@cookies_book), id)
    session[:user_products_count] = @cookies_book['book_count']
    OrderItem.create_items(@cookies_book, order_id)
    cookies.delete :books
  end

  def get_books_in_order_not_auth(cookies)
    @ids = []
    @cookies_hash = {}
    @subtotal = 0
    cookies.try(:each) do |book|
      @cookies_hash[book[0][3..-1]] = book[1]  unless book[0] == 'book_count'
      @ids << book[0][3..-1] unless book[0] == 'book_count'
    end
    @books = Book.where(id: @ids)
    @books.try(:each) do |book|
      @subtotal += book.price * @cookies_hash[book.id.to_s].to_i
    end
    @subtotal
  end

  def total_price(cookies)
    get_books_in_order_not_auth(cookies)
  end

  def new_facebook_user?(user)
    user.sign_in_count < 2 && user.provider == 'facebook' ? true : false
  end

  def cookies_nil
    unless @cookies_book
      @cookies_book = { 'book_count' => '0', 'total_price' => '0' }
    end
  end

  def cookies_json_parse
    @cookies_book = JSON.parse(cookies[:books]) if cookies[:books]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:firstname, :lastname, :email, :password) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:firstname, :lastname, :email, :password) }
  end
end
