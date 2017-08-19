class ReviewsController < ApplicationController
  before_action :require_login
  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.create(review_params.merge!(user: current_user))
    if review.valid?
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      render "videos/show"
    end
  end

  private 
    def review_params
      params.require(:review).permit(:rating, :content)
    end
end