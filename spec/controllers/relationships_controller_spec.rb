require 'spec_helper.rb'

describe RelationshipsController do
  describe "GET index" do
    it "sets @relationships to the current user's following relationships" do
      charlie = Fabricate(:user)
      set_current_user(charlie)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: charlie, leader: bob)
      get :index
      expect(assigns(:relationships)).to eq [relationship]
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 4  }
    end

    it "redirect to the people page" do
      charlie = Fabricate(:user)
      set_current_user(charlie)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: charlie, leader: bob)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end

    it "deletes the relationship if the current user is the follower" do
      charlie = Fabricate(:user)
      set_current_user(charlie)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: charlie, leader: bob)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq 0
    end
    
    it "doesn't delete the relationship if the current user is not the follower" do
      charlie = Fabricate(:user)
      set_current_user(charlie)
      bob = Fabricate(:user)
      john = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: john, leader: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq 1
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, leader_id: 3 }
    end

    it "creates a relationship that the current user follows the leader" do
      charlie = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(charlie)
      post :create, leader_id: bob.id
      expect(charlie.following_relationships.first.leader).to eq bob
    end

    it "redirects to the people page" do
      charlie = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(charlie)
      post :create, leader_id: bob.id
      expect(response).to redirect_to people_path
    end

    it "doesn't create a relationship if the current user already follows the leader" do
      charlie = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(charlie)
      relationship = Fabricate(:relationship, follower: charlie, leader: bob)
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq 1
    end

    it "deos not allow one to follow themselves" do
      charlie = Fabricate(:user)
      set_current_user(charlie)
      post :create, leader_id: charlie.id
      expect(Relationship.count).to eq 0
    end
  end
end