class CustomSessionsControllerController < Devise::SessionsController

  before_filter :after_registration, :only => :create

  def after_registration 
  	cookies.delete :books
  end

end
