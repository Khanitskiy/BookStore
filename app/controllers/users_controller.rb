class UsersController < ApplicationController
  before_action :create_addresses_obj
  before_action :authenticate_user!
  before_action :authorize_current_user

  def update_password
    bool = current_user.valid_password?(params[:user][:old_password])
    bool ? updates : flash.now[:alert] = 'Incorrect password'
    current_user.errors.messages[:password_form] = true
    render "users/settings"
  end

  def update_data
    updates
    current_user.errors.messages[:data_form] = true
    render "users/settings"
  end

  private

  def authorize_current_user
    authorize! :update, current_user
  end

  def updates
    #@user = User.find(current_user.id)
    if current_user.update(user_params)
      sign_in current_user, :bypass => true
      flash.now[:notice] = 'Your data have been changes'
    else
      flash.now[:alert] = 'Something went wrong'
    end
  end

  def user_params
    params.require(:user).permit(:firstname, 
                                 :lastname, 
                                 :email, 
                                 :password, 
                                 :user_id, 
                                 :password_confirmation)
  end
end