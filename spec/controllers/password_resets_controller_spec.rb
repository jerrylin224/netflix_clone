require 'spec_helper.rb'

describe PasswordResetsController do
  describe "GET show" do
    it "render show template if the token is valid" do
      charlie = Fabricate(:user)
      charlie.update_columns(token: '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end

    it "sets @token" do
      charlie = Fabricate(:user)
      charlie.update_columns(token: '12345')
      get :show, id: '12345'
      expect(assigns(:token)).to eq '12345'
    end

    it "redirects to the expired token page ig the token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
    context "with invalid input(less than 6 digit)" do
      it "render the password_reset template" do
        charlie = Fabricate(:user)
        charlie.update_columns(token: '12345')
        post :create, token: '12345', password: 'new'
        expect(response).to render_template 'show'
      end

      it "sets the message" do
        charlie = Fabricate(:user)
        charlie.update_columns(token: '12345')
        post :create, token: '12345', password: 'new'
        expect(flash[:error]).not_to be_blank
      end
    end

    context "with valid input" do
      context "with valid token" do
        it "redirects to the sign in page" do
          charlie = Fabricate(:user)
          charlie.update_columns(token: '12345')
          post :create, token: '12345', password: 'new_password'
          expect(response).to redirect_to sign_in_path
        end

        it "updates the user's password" do
          charlie = Fabricate(:user)
          charlie.update_columns(token: '12345')
          post :create, token: '12345', password: 'new_password'
          expect(charlie.reload.authenticate('new_password')).to be charlie.reload
        end

        it "sets the flash success message" do
          charlie = Fabricate(:user)
          charlie.update_columns(token: '12345')
          post :create, token: '12345', password: 'new_password'
          expect(flash[:notice]).to be_present
        end

        it "regenerates the user token" do
          charlie = Fabricate(:user)
          charlie.update_columns(token: '12345')
          post :create, token: '12345', password: 'new_password'
          expect(charlie.reload.token).not_to eq '12345'
        end
      end

      context "with invalid token" do
        it "redirects to the expired token path" do
          post :create, token: '12345', password: 'some_password'
          expect(response).to redirect_to expired_token_path
        end
      end
    end
  end
end