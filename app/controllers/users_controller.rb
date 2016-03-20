class UsersController < ApplicationController

	before_action :authenticate_user!

	def settings
		create_addresses_obj
	end

	def update_password
		if params[:user][:old_password] != '' && current_user.valid_password?(params[:user][:old_password]) == false
				flash[:alert] = "Something went wrong"
				flash[:error] = {'old_password' => 'Incorrect password' }
				flash[:error][:password_form] = true
		else	
			updates
			flash[:error] = @user.errors.messages
	  	flash[:error][:password_form] = true
	  	flash[:error][:old_password] = ['can\'t be blank'] if params[:user][:old_password] == ''
	  end
		redirect_to settings_path

  end

  def update_data
  	updates
  	flash[:error] = @user.errors.messages
  	flash[:error]['data_form'] = true

	  redirect_to settings_path
  end


  private

	def updates
		if params[:user_id].to_i == current_user.id

	    @user = User.find(current_user.id)
	    if @user.update(user_params)
	      # Sign in the user by passing validation in case their password changed
	      sign_in @user, :bypass => true
	      flash[:notice] = "Your data have been changes"
	    else
	      flash[:alert] = "Something went wrong"
	    end

	  else
	  	flash[:alert] = "Something went wrong"
	  end
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :user_id)
	end

end
