require 'spec_helper.rb'

describe SessionsController do
  describe "GET new" do
    it "redirect the home page for authenticated user " do
      
      session[:user_id] = Fabricate(:user).id
      # session這種東西為什麼不用測？
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }


    context "with valid user" do
      before(:each) do
        post :create, {email: alice.email, password: alice.password}
      end

      it "puts the signin user in the session" do
        expect(session[:user_id]).to eq alice.id
      end

      it "redirect the signin user to home path" do
        expect(response).to redirect_to home_path
      end

      it "set the notice" do
        expect(flash[:notice]).not_to be_blank
      end
    end

    context "with invalid credential" do
      before(:each) do
        post :create, {email: alice.email, password: "123456asd"}
      end

      it "doesn't puts the signin user in session" do
        expect(session[:user_id]).not_to eq alice.id
      end

      it "render the new template" do
        expect(response).to render_template(:new)
      end

      it "sets the error message" do
        expect(flash[:error]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do
    before(:each) do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it "clear the session for user" do
      expect(session[:user_id]).to be_nil
    end
    it "redirect the signout user to root_path" do
      expect(response).to redirect_to root_path
    end
    it "sets the notice message" do
      expect(flash[:notice]).not_to be_blank
    end
  end
end