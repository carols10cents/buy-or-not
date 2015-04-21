class ReleasesController < ApplicationController
  before_filter :authenticate!

  def show
    release = Release.fetch(params[:id], current_user.discogs)
    redirect_to release.discogs_url
  end
end
