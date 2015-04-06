class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(request.env['omniauth.auth'])
    session[:user_id] = user.id

    if request.env['omniauth.params']['remember_me']
      token = user.remember_me!

      remember_cookie_values = { httponly: true }
      remember_cookie_values.merge!(
        Rails.configuration.session_options.slice(:path, :domain, :secure)
      )
      remember_cookie_values.merge!(
        value:   token.value,
        expires: token.created_at + 2.weeks
      )

      cookies.signed[:remember_user_token] = remember_cookie_values
    end

    redirect_to root_url, notice: "Signed in."
  end

  def destroy
    session[:user_id] = nil
    current_user.forget_me!(cookies.signed[:remember_user_token]) if current_user
    cookies.delete :remember_user_token
    redirect_to root_url, notice: "Signed out."
  end
end