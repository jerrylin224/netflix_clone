require 'spec_helper.rb'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue for the logged in user" do
      charlie = Fabricate(:user)
      set_current_user(charlie)
      queue_item1 = Fabricate(:queue_item, user: charlie)
      queue_item2 = Fabricate(:queue_item, user: charlie)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2]) 
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    it "redirects to my_queue path" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "create a queue_item" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq 1
    end

    it "creates a queue item that is associated with the video" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq video
    end

    it "create a queue item that is associated with the sign in user" do
      charlie = Fabricate(:user)
      set_current_user(charlie)
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq charlie
    end

    it "puts the video as the last one in the queue" do
      charlie = Fabricate(:user)
      set_current_user(charlie)
      video1 = Fabricate(:video)
      Fabricate(:queue_item, user: charlie, video: video1)
      video2 = Fabricate(:video, title: "B")
      post :create, video_id: video2.id
      video2_queue_item = QueueItem.where(video_id: video2.id, user_id: charlie.id).first
      expect(video2_queue_item.position).to eq 2
    end

    it "does not add video in to the queue, if the video is already in the queue" do
      charlie = Fabricate(:user)
      set_current_user(charlie)
      inception = Fabricate(:video)
      inception_queue_item = Fabricate(:queue_item, user: charlie, video: inception)
      post :create, video_id: inception.id
      expect(charlie.queue_items.count).to eq 1
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :create, video_id: 3 }
    end
  end

  describe "DELETE destroy" do
    describe "#destroy" do
      it "redirects to my_queue path" do
        charlie = Fabricate(:user)
        set_current_user(charlie)
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it "deletes the queue item from the database" do
        charlie = Fabricate(:user)
        set_current_user(charlie)
        queue_item = Fabricate(:queue_item, user: charlie)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq 0
      end

      it "doesn't delete the queue item if the current user doesn't own the queue item" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        set_current_user(user1)
        queue_item1 = Fabricate(:queue_item, user: user1)
        queue_item2 = Fabricate(:queue_item, user: user2)
        delete :destroy, id: queue_item2.id
        expect(QueueItem.count).to eq 2
      end

      it_behaves_like "requires sign in" do
        let(:action) { delete :destroy, id: 3 }
      end

      it "normalizes the remaining queue items" do
        charlie = Fabricate(:user)
        set_current_user(charlie)
        queue_item1 = Fabricate(:queue_item, user: charlie, position: 1)
        queue_item2 = Fabricate(:queue_item, user: charlie, position: 2)
        queue_item3 = Fabricate(:queue_item, user: charlie, position: 3)
        delete :destroy, id: queue_item2.id
        expect(charlie.queue_items.map(&:position)).to eq [1,2]
      end
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do
      let(:charlie) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, position: 1, user: charlie, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, position: 2, user: charlie, video: video) }

      before(:each) { set_current_user(charlie) }

      it "rediects to the my queue page" do  
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(charlie.queue_items).to eq [queue_item2, queue_item1]
      end

      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(charlie.queue_items.map(&:position)).to eq [1,2]
      end
    end

    context "with invalid inputs" do 
      let(:charlie) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, position: 1, user: charlie, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, position: 2, user: charlie, video: video) }

      before(:each) { set_current_user(charlie) }

      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(flash[:error]).to be_present
      end

      it "does not change the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq 1
      end
    end

    it_behaves_like "requires sign in" do
      let(:action) do
        post :update_queue, queue_items: [{id: 1, position: 3}, {id: 2, position: 2.1}]
      end
    end

    context "with queue items that do not belong to the current user" do
      it "doesn't save data to database" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        session[:user_id] = user1.id
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, position: 2, user: user1, video: video)
        queue_item2 = Fabricate(:queue_item, position: 1, user: user2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item2.reload.position).to eq 1
      end
    end
  end
end