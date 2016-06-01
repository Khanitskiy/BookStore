class AddressesController < ApplicationController
  authorize_resource
  before_action :create_addresses_obj

  def update
    if params[:address][:and_shipping] == 'true'
      shipping_true
    else
      shipping_false
    end
    flash_create false
  end

  private

  def shipping_true
    @billing_address.update address_params(true)
    @shipping_address.update address_params(false)
  end

  def shipping_false
    @shipping_address.update address_params(true)
  end

  def flash_create(bool)
    if bool
      flash[:error] = @billing_address.errors.messages
      flash[:error][:billing_form] = true
    else
      flash[:error] = @shipping_address.errors.messages
      flash[:error][:shipping_form] = true
    end
    redirect_to settings_path
  end

  def address_params(val)
    par = params.require(:address).permit(:firstname, :lastname, :address,
                                          :city, :country, :zipcode, :phone)
    if val
      par.merge(user_billing_address_id: current_user.id)
    else
      par.merge(user_shipping_address_id: current_user.id)
    end
  end
end
