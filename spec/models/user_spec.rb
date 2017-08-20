require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:reviews).order(created_at: :desc) }
  it { should have_many(:queue_items).order(:position) }

  describe "#queued_video?" do
    it "returns true when the user queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be true
    end

    it "returns false when the user hasn't queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued_video?(video)).to be false
    end
  end

  describe "#another_user" do
    it "returns true if the user has a following reloationship with another user" do
      charlie = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: charlie)
      expect(charlie.follows?(bob)).to be_true
    end

    it "returns false if the user doesn't have a following relationship with another user" do
      charlie = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: charlie, follower: bob)
      expect(charlie.follows?(bob)).to be_false
    end
  end
end
