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
end