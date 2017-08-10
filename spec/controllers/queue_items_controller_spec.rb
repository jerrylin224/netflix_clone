require 'spec_helper.rb'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue for the logged in user" do
      charlie = Fabricate(:user)
      session[:user_id] = charlie.id
      queue_item1 = Fabricate(:queue_item, user: charlie)
      queue_item2 = Fabricate(:queue_item, user: charlie)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2]) 
    end

    it "redirects to the sign in page for unauthenticated user" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do
      it "redirects to my_queue path" do
        session[:user_id] = Fabricate(:user).id
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end

      it "create a queue_item" do
        session[:user_id] = Fabricate(:user).id
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.count).to eq 1
      end

      it "creates a queue item that is associated with the video" do
        session[:user_id] = Fabricate(:user).id
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq video
      end

      it "create a queue item that is associated with the sign in user" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq user
      end
      
      
      it "puts the video as the last one in the queue" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        video1 = Fabricate(:video)
        Fabricate(:queue_item, user: user, video: video1)
        video2 = Fabricate(:video, title: "B")
        post :create, video_id: video2.id
        video2_queue_item = QueueItem.where(video_id: video2.id, user_id: user.id).first
        expect(video2_queue_item.position).to eq 2
      end
      it "does not add video in to the queue, if the video is already in the queue" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        inception = Fabricate(:video)
        inception_queue_item = Fabricate(:queue_item, user: user, video: inception)
        post :create, video_id: inception.id
        expect(user.queue_items.count).to eq 1
      end
    

      it "redirects to the sign in page for unauthenticated users" do
        user = Fabricate(:user)
        inception = Fabricate(:video)
        post :create, video_id: inception.id
        expect(response).to redirect_to sign_in_path
      end

  end
end