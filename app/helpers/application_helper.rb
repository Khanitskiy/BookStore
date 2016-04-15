module ApplicationHelper

  def cp(path, bool = false)
  	if bool
      "active" if current_page?(path)
    else
      "class=active" if current_page?(path)
    end
  end

  def wizard_link(path) 
    if params[:id] == path
      "c_active"
    end
  end

  def not_active(step)
    hash = {:address => 0, :delivery => 1, :payment => 2, :confirm => 3, :complete => 4}
    if @order.step_number.to_i == hash[step]
     
    elsif @order.step_number.to_i < hash[step]
      "not-active"
    end
  end

  def checked(val)
    if @order_steps_form.order.delivery.to_f == val
      true
    else
      false
    end
  end

  def count_products

    if current_user
      #@count_products = @order[:book_count] if @order
      @count_products = session[:user_products_count]
    else
    	@count_products = JSON.parse(cookies[:books])["book_count"] if cookies[:books]
    end

    if @count_products && @count_products.to_i > 0
      
      unless @count_products.to_i >= 100
        @count_products
      else
        "99+"
      end   

    else
      "empty"
    end

  end
  
end