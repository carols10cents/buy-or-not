class HomeController < ApplicationController
  def index
    redirect_to collection_path if current_user
  end
end