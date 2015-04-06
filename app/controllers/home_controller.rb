class HomeController < ApplicationController
  def index
    if current_user
      redirect_to collection_path
    else
      cookies.delete :remember_user_token
    end
  end
end