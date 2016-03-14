class AddressesController < ApplicationController

	def update
		if params[:address][:and_shipping] == 'true'

			@billing_address = Address.find_or_create_by(billing_address_id: current_user)
			@shipping_address = Address.find_or_create_by(shipping_address_id: current_user)

			@billing_address.update address_params(true)
			@shipping_address.update address_params(false)

			redirect_to settings_path 
		else

			@billing_address = Address.find_or_create_by(billing_address_id: current_user)
			@billing_address.update address_params(true)

			redirect_to settings_path

		end
	end


	def address_params(val)
    par = params.require(:address).permit(:firstname, :lastname, :address, :city, :country, :zipcode, :phone)
    if val
    	par.merge(billing_address_id: current_user.id)
    else 
    	par.merge(shipping_address_id: current_user.id)
    end
	end

end
