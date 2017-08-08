require 'spec_helper.rb'

describe UsersController do
  describe "GET new" do
    it "set @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid input" do
      before(:each) do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "create the user" do
        expect(User.count).to eq 1
      end

      it "redirect to root_path" do  
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with invalide input" do
      before(:each) do
        post :create, user: {full_name: "Lin", password: "password"}
      end
 
      it "doesn't create @user" do
        expect(User.count).to eq 0
      end

      it "render the :new template" do
        expect(response).to render_template :new
      end

      it "set @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end
end