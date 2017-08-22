require 'spec_helper.rb'

describe UsersController do
  describe "GET new" do
    it "set @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 2 }
    end

    it "sets @user for authenticated user" do
      charlie = Fabricate(:user)
      set_current_user(charlie)
      get :show, id: charlie.id
      expect(assigns(:user)).to eq charlie
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

    context "sending emails" do
      after { ActionMailer::Base.deliveries.clear }

      it "sends out email to the user with valide inputs" do
        post :create, user: { email: "joe@example.com", password: "password", full_name: "Test User" }
        expect(ActionMailer::Base.deliveries.last.to).to eq (['joe@example.com'])
      end

      it "sends out email containing the user's name with valid inputs" do
        post :create, user: { email: "joe@example.com", password: "password", full_name: "Test User" }
        expect(ActionMailer::Base.deliveries.last.body).to include "Test User"
      end

      it "doesn't send out email with invalide inputs" do
        post :create, user: { email: "joe@example.com" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end