class UsersController < ApplicationController

	before_action :authenticate_user!

	def settings
		@billing_address = current_user.billing_address || Address.new
    @shipping_address = current_user.shipping_address || Address.new
	end

	def update_password
		if current_user.valid_password?(params[:user][:old_password])
			updates
		else
			flash[:alert] = "Incorrect password"
			redirect_to settings_path
		end
  end

  def update_data
  	updates
  end


  private

	def updates
		#byebug
		if params[:user_id].to_i == current_user.id

	    @user = User.find(current_user.id)
	    if @user.update(user_params)
	      # Sign in the user by passing validation in case their password changed
	      sign_in @user, :bypass => true
	      flash[:notice] = "Your data have been changes"
	    else
	      flash[:notice] = "Something went wrong"
	    end

	  else
	  	flash[:notice] = "Something went wrong"
	  end
	  redirect_to settings_path
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :user_id)
	end

end
