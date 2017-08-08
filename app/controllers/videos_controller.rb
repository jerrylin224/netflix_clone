class VideosController < ApplicationController
  before_action :require_login

  def index
    @categories = Category.all
    @videos = Video.all
  end

  def show
    binding.pry
    @video = Video.find(params[:id])
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end
end