class SessionsController < ApplicationController
  def new
    @providers = [:google_oauth2]
  end

  def create
    Rails.logger.info "request.env: #{hash}"
    Rails.logger.info "params: #{params}"

    @user = User.find_with_oauth(hash.merge(params))

    session[:user_id] = @user.id

    redirect_to load_profile_path, notice: "Signed In!"
  end

  def hash
    @oauth_hash ||= request.env["omniauth.auth"]
  end
end
