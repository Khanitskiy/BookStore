class OrderStepsController < ApplicationController
  include Wicked::Wizard

  before_filter :authenticate_user!
  before_action :redirect_to_step, unless: :complete?

  steps :address, :delivery, :payment, :confirm, :complete

  def show
    new_order if step == :complete

    @order_steps_form = OrderStepsForm.new(@order)
    @order_steps_form.user = current_user
    unless params[:value].nil?
      cupon = Cupon.cheking(params[:value])
      cupon.update(order_id: @order.id, use: true) if cupon && cupon.use == false
    end
    render_wizard
  end

  def update
    @order_steps_form = OrderStepsForm.new(@order)
    @order_steps_form.step = step
    @order_steps_form.atributes = checkout_params unless step == :confirm
    @order_steps_form.user = current_user if @order_steps_form.user.nil?
    if step == :address
      @order_steps_form.and_shipping = params[:order_steps_form][:billing_address][:and_shipping]
    end
    render_wizard @order_steps_form
  end

 def redirect_to_step
    # byebug
    # root_path if step == :confirm
    hash = { address: 0, delivery: 1, payment: 2, confirm: 3, complete: 4 }
    hash.each do |variable|
      # byebug
      if variable.second > @order.step_number.to_i
        hash.delete(variable.first)
      else
        @last_step = variable.first
      end
    end
    # byebug
    redirect_to wizard_path(@last_step) if hash[step].nil?
  end

  private

  def complete?
    step == :complete
  end

  def new_order 
    @order = Order.last_order_queue(current_user)
    session[:user_products_count] = 0
    cookies.delete :user_products_count
  end

  def checkout_params
    params.require(:order_steps_form).permit(
      billing_address: [:firstname,
                        :lastname,
                        :address,
                        :city,
                        :phone,
                        :zipcode,
                        :country,
                        :order_billing_address_id,
                        :order_shipping_address_id],
      shipping_address: [:firstname,
                         :lastname,
                         :address,
                         :city,
                         :phone,
                         :city,
                         :zipcode,
                         :country],
      delivery_type:   [:delivery],
      payment:         [:firstname,
                        :lastname,
                        :number,
                        :expiration_year,
                        :expiration_month,
                        :cvv]
    )
  end
end
