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
    session[:user_products_count] == 0 ? set_session('empty') : set_session(val)
  end
  
end