class Admin::VideosController < ApplicationController
  before_action :require_login
  before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "You have created the video #{@video.title}!"
      redirect_to new_admin_video_path
    else
      flash[:error] = "Please check the error, something wrong with your input."
      render :new
    end
  end


  private

  def require_admin
    unless current_user.admin?
      flash[:error] = "You are not authorized to do that."
      redirect_to home_path
    end
  end

  def video_params
    params.require(:video).permit!
  end
end