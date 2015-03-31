class CollectionController < ApplicationController
  before_filter :authenticate!

  def show
  end

  def sync
    render json: current_user.collection(params[:page])
  end
end