class VideosController < ApplicationController
  def index
    @categories = Category.all
    @videos = Video.all
  end

  def show
    # binding.pry
    @video = Video.find(params[:id])
  end
end