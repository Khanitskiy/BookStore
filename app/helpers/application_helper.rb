module ApplicationHelper
  def cp(path, bool = false)
    if current_page?(path)
      bool ? 'active' : 'class=active'
    end
  end

  def wizard_link(path)
    'c_active' if params[:id] == path
  end

  def not_active(step)
    hash = { address: 0, delivery: 1, payment: 2, confirm: 3, complete: 4 }
    if @order.step_number.to_i == hash[step]

    elsif @order.step_number.to_i < hash[step]
      'not-active'
    end
  end

  def checked(val)
    @order_steps_form.order.delivery.to_f == val
  end

  def count_products
    if current_user
      @count_products = session[:user_products_count]
    else
      @count_products = JSON.parse(cookies[:book_count])['book_count'] if cookies[:book_count]
    end

    bool = @count_products && @count_products.to_i > 0
    bool ? @count_products.to_i >= 100 ? '99+' : @count_products : 'empty'
  end

  def cupon(order_total)
    if @order.cupon.nil?
      order_total
    else @order.cupon.nil?
         if @order.cupon.use == true
           if defined?(step)
             if step == :complete
               order_total
             else
               order_total - @order.cupon.discount
              end
           else
             order_total
           end
         end
    end
  end


  def discount
    @order.cupon ? cupon_discount(@order.cupon.discount.to_s) : ''
  end

  def cupon_discount(val)
    '(-$<div id="cupon-value">' << val << '</div>)<br><br>'
  end

  def items_calc(book, type = false)
    val = 0
    quantity = 0
    if current_user
      @obj.try(:each) do |item|
        val = book.price * item.quantity if book.id == item.book_id
        quantity = item.quantity if book.id == item.book_id
      end
    else
      val = book.price * @obj[book.id.to_s].to_i
      quantity = @obj[book.id.to_s]
    end
    type ? quantity : number_to_currency(val)
  end

end