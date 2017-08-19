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
  end

  it_behaves_like "requires sign in" do
    let(:action) { get :index }
  end
end