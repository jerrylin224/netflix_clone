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

  describe "DELETE destroy" do
    describe "#destroy" do
      it "redirects to my_queue path" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it "deletes the queue item from the database" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq 0
      end

      it "doesn't delete the queue item if the current user doesn't own the queue item" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        session[:user_id] = user1.id
        queue_item1 = Fabricate(:queue_item, user: user1)
        queue_item2 = Fabricate(:queue_item, user: user2)
        delete :destroy, id: queue_item2.id
        expect(QueueItem.count).to eq 2
      end

      it "redirects to the sign in page for unauthenticated users" do
        delete :destroy, id: 3
        expect(response).to redirect_to sign_in_path
      end

      it "normalizes the remaining queue items" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, user: user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: user, position: 2)
        queue_item3 = Fabricate(:queue_item, user: user, position: 3)
        delete :destroy, id: queue_item2.id
        expect(user.queue_items.map(&:position)).to eq [1,2]
      end
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do
      it "rediects to the my queue page" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, position: 1, user: user)
        queue_item2 = Fabricate(:queue_item, position: 2, user: user)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, position: 1, user: user)
        queue_item2 = Fabricate(:queue_item, position: 2, user: user)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(user.queue_items).to eq [queue_item2, queue_item1]
      end

      it "normalizes the position numbers" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, position: 1, user: user)
        queue_item2 = Fabricate(:queue_item, position: 2, user: user)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(user.queue_items.map(&:position)).to eq [1,2]
      end
    end

    context "with invalid inputs" do 
      it "redirects to the my queue page" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, position: 1, user: user)
        queue_item2 = Fabricate(:queue_item, position: 2, user: user)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, position: 1, user: user)
        queue_item2 = Fabricate(:queue_item, position: 2, user: user)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(flash[:error]).to be_present
      end

      it "does not change the queue items" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, position: 1, user: user)
        queue_item2 = Fabricate(:queue_item, position: 2, user: user)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq 1
      end
    end
    context "with unauthenticated users" do
      it "redirects the user to sign in path" do
        post :update_queue, queue_items: [{id: 1, position: 3}, {id: 2, position: 2.1}]
        expect(response).to redirect_to sign_in_path
      end
    end
    context "with queue items that do not belong to the current user" do
      it "doesn't save data to database" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        session[:user_id] = user1.id
        queue_item1 = Fabricate(:queue_item, position: 2, user: user1)
        queue_item2 = Fabricate(:queue_item, position: 1, user: user2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item2.reload.position).to eq 1
      end
    end

    # used to prevent malicious user
  end
end