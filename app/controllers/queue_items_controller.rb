class QueueItemsController < ApplicationController
  before_action :require_login

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.delete if current_user.queue_items.include?(queue_item)
    redirect_to my_queue_path
  end

  def update_queue
    params[:queue_items].each do |queue_item_data|
      queue_item = QueueItem.find(queue_item_data["id"])
      if !queue_item.update(position: queue_item_data["position"])
        redirect_to my_queue_path
        flash[:error] = "Invalid position numbers."
        return
        # means the end of the execution, or the code will continues
      end
    end

    current_user.queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index + 1)
    end
    # update the new position, but you need to set default order
    redirect_to my_queue_path
  end

  private
  def queue_video(video)
    QueueItem.create(video: video, user: current_user, position: new_queue_item_position) unless current_user_queued_video?(video)
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def current_user_queued_video?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def queue_items_params
    params.require(:queue_items).permit!
  end
end