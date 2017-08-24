require 'spec_helper.rb'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_instance_of Invitation
      expect(assigns(:invitation)).to be_new_record
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    context "valid input" do
      it "redirects to the invitation new page" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joe@example.com", message: "Join the site" }
        expect(response).to redirect_to new_invitation_path
      end

      it "creates an invitation" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joe@example.com", message: "Join the site" }
        expect(Invitation.count).to eq 1
      end

      it "sends an email to the recipient" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joe@example.com", message: "Join the site" }
        expect(ActionMailer::Base.deliveries.last.to).to eq ["joe@example.com"]
      end

      it "sets the flash success message" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joe@example.com", message: "Join the site" }
        expect(flash[:success]).to be_present
      end
    end

    context "invalid input" do
      it "renders the :new template" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@example.com" }
        expect(response).to render_template :new
      end

      it "doesn't create invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@example.com" }
        expect(Invitation.count).to eq 0
      end

      it "doesn't send the email" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@example.com" }
        expect(ActionMailer::Base.deliveries.count).to eq 0
      end

      it "sets the flash error message" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@example.com" }
        expect(flash[:error]).to be_present
      end

      it "sets @invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "joe@example.com" }
        expect(assigns(:invitation)).to be_instance_of Invitation
      end
    end
  end
end