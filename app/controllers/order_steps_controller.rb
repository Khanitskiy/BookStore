class OrderStepsController < ApplicationController
	include Wicked::Wizard

	before_action :authenticate_user!

	steps :confirm_password, :confirm_profile, :find_friends

	def show

	end

	def update
    #@product = Product.find(params[:product_id])
    #params[:product][:status] = 'active' if step == steps.last
    #@product.update_attributes(params[:product])
    #render_wizard @product
  end

end
