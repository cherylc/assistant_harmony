class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate
    unless logged_in?
      flash[:error] = "This area requires authentication"
      redirect_to register_path
    end
  end

  def logged_in?
    session[:user_id] && User.exists?(session[:user_id])
  end

  def current_user
    @current_user ||= User.find session[:user_id]
  end
end
