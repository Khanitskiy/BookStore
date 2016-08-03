class OrderStepsController < ApplicationController
  include Wicked::Wizard

  before_filter :authenticate_user!
  before_action :redirect_to_step, unless: :complete?

  steps :address, :delivery, :payment, :confirm, :complete

  def show
    new_order if step == :complete

    all_checkout_params = [current_user, step]
    @order_steps_form = OrderStepsForm.new(@order, all_checkout_params)
    update_cupon
    render_wizard
  end

  def update
    params = checkout_params unless step == :confirm
    all_checkout_params = [current_user, step, and_shipping, params]
    @order_steps_form = OrderStepsForm.new(@order, all_checkout_params)
    render_wizard @order_steps_form
  end

  private

  def redirect_to_step
    result = CurrentStepService.new(@order).call
    redirect_to wizard_path(result[0]) if result[1][step].nil?
  end

  def and_shipping
    params[:order_steps_form][:billing_address][:and_shipping] if step == :address
  end

  def complete?
    step == :complete
  end

  def update_cupon
    unless params[:value].nil?
      cupon = Cupon.cheking(params[:value]).first
      cupon.update(order_id: @order.id, use: true) if cupon && cupon.use == false
    end
  end

  def new_order 
    @order = Order.last_order_queue(current_user)
    set_session(0)
    cookies_delete
  end

  def address_params
    [:firstname,
     :lastname,
     :address,
     :city,
     :phone,
     :zipcode,
     :country]
  end

  def checkout_params
    params.require(:order_steps_form).permit(
      billing_address: address_params + [:order_billing_address_id,
                                         :order_shipping_address_id],
      shipping_address: address_params,
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
