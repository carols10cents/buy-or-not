class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def authenticate!
    redirect_to root_path unless current_user
  end

  def current_user
    if @current_user
      @current_user
    elsif session[:user_id]
      @current_user = User.find(session[:user_id])
    elsif cookies.signed[:remember_user_token]
      @current_user = User.from_token(cookies.signed[:remember_user_token])
    end
  end

  helper_method :current_user
end
