module SessionHandling
  extend ActiveSupport::Concern
  
  private

  def set_session(val)
    session[:user_products_count] = val
  end

  def addition_of_session(val)
  	session[:user_products_count] += val.to_i
  end

  def change_session
    val = session[:user_products_count].to_i - params[:product_count].to_i
    set_session(val) unless session[:user_products_count] == 0
  end
  
end