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
    before(:each) do
      StripeWrapper::Charge.stub(:create)
    end

    context "with valid input" do
      it "create the user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq 1
      end

      it "redirect to root_path" do  
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end

      it "makes the user follow the inviter" do
        charlie = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: charlie, recipient_email: 'joe@example.com')
        post :create, user: { email: 'joe@example.com', password: "password", full_name: 'Joe Doe' }, invitation_token: invitation.token
        joe = User.find_by(email: 'joe@example.com')
        expect(joe.follows?(charlie)).to be true
      end

      it "makes the inviter follow the user" do
        charlie = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: charlie, recipient_email: 'joe@example.com')
        post :create, user: { email: 'joe@example.com', password: "password", full_name: 'Joe Doe' }, invitation_token: invitation.token
        joe = User.find_by(email: 'joe@example.com')
        expect(charlie.follows?(joe)).to be true
      end

      it "expires the invitation upon acceptance" do
        charlie = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: charlie, recipient_email: 'joe@example.com')
        post :create, user: { email: 'joe@example.com', password: "password", full_name: 'Joe Doe' }, invitation_token: invitation.token
        joe = User.find_by(email: 'joe@example.com')
        expect(Invitation.first.token).to be_nil
      end

      it "signs in the user" do
        charlie = Fabricate(:user)
        post :create, user: { email: charlie.email, password: "password", full_name: charlie.full_name }
        expect(session[:user_id]).to eq charlie.id
      end
    end

    context "with invalid input" do
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
      before(:each) do
        StripeWrapper::Charge.stub(:create)
      end

      after { ActionMailer::Base.deliveries.clear }

      # it "sends out email to the user with valid inputs" do
      #   post :create, user: { email: "joe@example.com", password: "password", full_name: "Test User" }
      #   expect(ActionMailer::Base.deliveries.last.to).to eq (['joe@example.com'])
      # end

      # it "sends out email containing the user's name with valid inputs" do
      #   post :create, user: { email: "joe@example.com", password: "password", full_name: "Test User" }
      #   expect(ActionMailer::Base.deliveries.last.body).to include "Test User"
      # end

      # it "doesn't send out email with invalide inputs" do
      #   post :create, user: { email: "joe@example.com" }
      #   expect(ActionMailer::Base.deliveries).to be_empty
      # end
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders the :new template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq invitation.recipient_email
    end

    it "redirects to expired token page for invalid tokens" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: "asdfsdfasfa"
      expect(response).to redirect_to expired_token_path
    end
  end
end