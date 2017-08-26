require 'spec_helper.rb'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it_behaves_like "requires admin" do
      let(:action) { get :new }
    end

    it "sets the @video to a new video" do
      set_current_admin
      get :new 
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end

    it "sets the flash error meesage for regular user" do
      set_current_user
      get :new 
      expect(flash[:error]).to be_present
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end

    context "with valid input" do
      it "redirect to the add new video path" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Mononokenohime", description: "Great movie!", category_id: category.id}
        expect(response).to redirect_to new_admin_video_path
      end

      it "create a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Mononokenohime", description: "Great movie!", category_id: category.id}
        expect(Video.count).to eq 1
      end
      it "sets flash success message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: "Mononokenohime", description: "Great movie!", category_id: category.id}
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      it "doesn't create video" do
        set_current_admin
        post :create, video: { title: "Mononokenohime" }
        expect(Video.count).to eq 0
      end

      it "render the new template" do
        set_current_admin
        post :create, video: { title: "Mononokenohime" }
        expect(response).to render_template :new
      end

      it "sets the @video variable" do
        set_current_admin
        post :create, video: { title: "Mononokenohime" }
        expect(assigns(:video)).to be_instance_of Video
        expect(assigns(:video)).to be_new_record
      end

      it "sets the flash error message" do
        set_current_admin
        post :create, video: { title: "Mononokenohime" }
        expect(flash[:error]).to be_present
      end
    end
  end
end