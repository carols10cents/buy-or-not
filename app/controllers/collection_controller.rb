class CollectionController < ApplicationController
  before_filter :authenticate!

  def show
  end

  def sync
    render json: '{}'
  end
end