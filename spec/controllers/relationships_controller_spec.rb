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
      delete :destroy, id: relationship.id
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
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq 1
    end

  end
end