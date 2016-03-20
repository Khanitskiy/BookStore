class AddressesController < ApplicationController

	def update
		if params[:address][:and_shipping] == 'true'

			create_addresses_obj

			@billing_address.update address_params(true)
			@shipping_address.update address_params(false)

			flash_create true

		else

			@shipping_address = Address.find_or_create_by(shipping_address_id: current_user)
			@shipping_address.update address_params(true)

			flash_create false

		end
	end


	private

	def flash_create bool
		if bool
			flash[:error] = @billing_address.errors.messages
	  	flash[:error][:billing_form] = true
	  	#flash[:error] = @shipping.errors.messages
	  	#flash[:error][:shipping_form] = true
	  else
	  	flash[:error] = @shipping_address.errors.messages
	  	flash[:error][:shipping_form] = true
	  end
			redirect_to settings_path 
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
