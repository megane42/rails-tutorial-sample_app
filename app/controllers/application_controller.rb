class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def require_login
    unless logged_in?
      flash[:danger] = 'Please log in.'
      store_location
      redirect_to login_url
    end
  end
end
