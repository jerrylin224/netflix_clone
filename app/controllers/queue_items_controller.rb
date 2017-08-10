class QueueItemsController < ApplicationController
  before_action :require_login

  def index
    @queue_items = current_user.queue_items
  end
end