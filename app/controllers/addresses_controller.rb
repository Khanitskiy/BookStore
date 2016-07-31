class AddressesController < ApplicationController
  authorize_resource
  before_action :create_addresses_obj

  def update
    addr_params = params[:address]
    bool = addr_params[:and_shipping] == 'true'
    type = addr_params[:type] == "billing"
    adresses_update(type, bool)
    errors_manage type
    render "users/settings"
  end

  private

  def adresses_update(type, val)
    if type
      @billing_address.update address_params(val) if val
      @shipping_address.update address_params(!val)
    else
      @shipping_address.update address_params(false)
    end
  end

  def errors_manage(bool)
    @resource = bool ? @billing_address : @shipping_address
    sym = bool ? :billing_form : :shipping_form
    @resource.errors.messages[sym] = true
  end

  #def billing_shipping_adresses(address)
  #  order.public_send(address) ||
  #    user.public_send(address)  ||
  #      Address.new("order_#{address.to_s}_id".to_sym => order.id)
  #end

  def address_params(val)
    par = params.require(:address).permit(:firstname, :lastname, :address,
                                          :city, :country, :zipcode, :phone)
    type = val ? 'billing' : 'shipping'
    par.merge("user_#{type}_address_id" => current_user.id)
  end
end