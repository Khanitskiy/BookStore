class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :create_addresses_obj
  before_action :authenticate_user!

  def update_password
    bool = current_user.valid_password?(params[:user][:old_password])
    bool ? updates : flash.now[:alert] = 'Incorrect password'
    current_user.errors.messages[:password_form] = true
    render "users/settings.html.haml"
  end

  def update_data
    updates
    current_user.errors.messages[:data_form] = true
    render "users/settings.html.haml"
  end

  private

  def updates
    if current_user.update(user_params)
      flash.now[:notice] = 'Your data have been changes'
    else
      flash.now[:alert] = 'Something went wrong'
    end
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :user_id, :password_confirmation)
  end
end
