module SessionsHelper
  def auth_signin(provider)
    "/auth/#{provider}"
  end
end
