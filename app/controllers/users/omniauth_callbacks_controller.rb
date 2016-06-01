class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env['omniauth.auth'])
    # byebug
    if @user.persisted?
      # byebug
      # if  new_facebook_user?(@user)
      # byebug
      # after_sign_up(@user.id)
      # end
      # byebug
      I18n.locale = session[:omniauth_login_locale] || I18n.default_locale
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      # byebug
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to root_path
    end
  end

  def failure
    redirect_to root_path
  end
end
