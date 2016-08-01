class ApplicationController < ActionController::Base

  include CookiesHandling
  include SessionHandling
  include ValueCalculation

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

  protected

  def configure_permitted_parameters
    fields = [:firstname, :lastname, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(fields) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(fields) }
  end

  private

  def load_in_progress_order
    if current_user
      @order = current_user.orders.where(state: 'in_progress').first
      set_session(@order.book_count)# unless current_user.admin
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
    return if current_user.id == 1
    new_facebook_user?(current_user) ? after_sign_up : after_sign_in
  end

  def after_sign_up
    parse_cookies
    id = current_user.id unless id
    @order = Order.create_order(@cookies_count , total_price, id)
    OrderItem.update_items(@cookies_book, @order)
    cookies_delete
  end

  def after_sign_in
    load_in_progress_order
    parse_cookies
    set_session(@order.book_count + @cookies_count['book_count'].to_i)
    @order.update(total_price: total_calc,
                  order_total: total_calc(5.0),
                  book_count:  @cookies_count['book_count'].to_i + @order.book_count)
    OrderItem.update_items(@cookies_book, @order.id)
    cookies_delete
  end

  def parse_cookies
    @cookies_book = cookies_json_parse(:books)
    @cookies_count = cookies_json_parse(:book_count)
    cookies_nil
  end

  def get_books(bool = true)
    value = current_user && bool
    @obj = value ? @order.order_items : cookies_json_parse(:books)
    @books = Book.get_books(parse_ids(@obj, value))
    @subtotal = current_user && bool ? @order.total_price : calc_subtotal(@books)
  end

  def new_facebook_user?(user)
    user.sign_in_count < 2 && user.provider == 'facebook'
  end
end