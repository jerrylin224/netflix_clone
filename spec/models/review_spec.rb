require 'spec_helper.rb'

describe Review do
  it { should validate_presence_of :rating }
  it { should validate_presence_of :content }

  describe "#user_name" do
    it "returns the user name of associated review" do
      user = Fabricate(:user)
      review = Fabricate(:review, user: user)
      expect(review.user_full_name).to eq user.full_name
    end
  end

  describe "#video_title" do
    it "returns video title of associated review" do
      video = Fabricate(:video)
      review = Fabricate(:review, video: video)
      expect(review.video_title).to eq video.title
    end
  end
end