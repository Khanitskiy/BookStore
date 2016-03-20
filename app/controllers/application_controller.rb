class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	before_filter :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to "/", :alert => exception.message
  end

  def create_addresses_obj
      @billing_address = Address.find_or_create_by(billing_address_id: current_user)
      @shipping_address = Address.find_or_create_by(shipping_address_id: current_user)
  end

    protected

      def configure_permitted_parameters
          devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:firstname, :lastname, :email, :password) }
          devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:firstname, :lastname, :email, :password) }
          #devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :current_password, :is_female, :date_of_birth) }
      end

end
