class VideosController < ApplicationController
  before_action :require_login

  def index
    @categories = Category.all
    @videos = Video.all
  end

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews
  end

  def search
    @results = Video.search_by_title(params[:search_term].downcase)
  end
end