require 'spec_helper.rb'

describe VideosController do
  describe 'GET show' do
    it "sets @video for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq video
    end

    it "sets @reviews for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it "redirect the user to sign in page if not authenticated user" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe 'GET search' do
    it "set @results for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video, title: "The Hangover")
      get :search, search_term: "ngov"
      expect(assigns(:results)).to eq [video]
    end

    it "redirect the user to sign in page if not authenticated user" do
      get :search
      expect(response).to redirect_to sign_in_path
    end
  end
end