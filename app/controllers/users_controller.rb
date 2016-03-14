class UsersController < ApplicationController

	before_action :authenticate_user!

	def settings
		@billing_address = current_user.billing_address || Address.new
    @shipping_address = current_user.shipping_address || Address.new
	end

end
