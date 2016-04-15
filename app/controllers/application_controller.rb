class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :load_in_progress_order 
  before_filter :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to "/", :alert => exception.message
  end

  def load_in_progress_order
    if current_user
      @order = current_user.orders.where(state: 'in_progress').first
     end
  end

  def after_sign_in_path_for(resource)
    unless  current_user.sign_in_count < 2 && @user.provider == 'facebook'
      cookies.delete :books
    end
    #byebug
    #@user_product_count = JSON.parse(cookies[:user_products_count]) if cookies[:user_products_count]
    #if @user_product_count == nil
      #product_count = current_user.orders.where(state: '1').first.book_count
      #cookies[:user_products_count] = { count: product_count }
    #end
    product_count = current_user.orders.where(state: '1').first
    session[:user_products_count] = product_count.book_count if product_count
    root_path
  end

  def after_sign_in(id = false)
    unless id 
      id = current_user.id
    end

    @order = Order.new()
    @order_items = OrderItem.new()
    @cookies_book = JSON.parse(cookies[:books]) if cookies[:books]
    if @cookies_book == nil
      @cookies_book = { "book_count" => "0", "total_price" => "0"}
    end
    order_id = @order.create_order(@cookies_book, total_price(@cookies_book),  id)
    session[:user_products_count] = @cookies_book["book_count"]
    @order_items.create_items(@cookies_book, order_id)
    cookies.delete :books
  end

  def total_price(cookies)
    @ids = Array.new
    @cookies_hash = Hash.new
    @subtotal = 0
    cookies.try(:each) do |book| 
      @cookies_hash[book[0][3..-1]] = book[1]  unless book[0] == "book_count"
      @ids << book[0][3..-1] unless book[0] == "book_count"
    end
    @books = Book.where(:id => @ids)
    @books.try(:each) do |book|
      @subtotal += book.price * @cookies_hash["#{book.id}"].to_i
    end
    @subtotal
  end

  def create_addresses_obj
      @billing_address = Address.find_or_create_by(user_billing_address_id: current_user.id)
      @shipping_address = Address.find_or_create_by(user_shipping_address_id: current_user.id)
      #byebug
      #if @billing_address.city.nil?
        #@order.billing_address = @billing_address.id
        #@order.shipping_address = @shipping_address.id
        #@order.save
      #end
  end

    protected

      def configure_permitted_parameters
          devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:firstname, :lastname, :email, :password) }
          devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:firstname, :lastname, :email, :password) }
          #devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :current_password, :is_female, :date_of_birth) }
      end

end
